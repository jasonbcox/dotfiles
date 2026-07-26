#!/bin/bash

set -euo pipefail

FILE=""
SESSION=""
DEFAULT_FILE="${HOME}/.tmuxrestore.tar.gz"

usage() {
    echo "Script to restore tmux session from a single file"
    echo "Usage: $0 save [session] [file]"
    echo "       $0 restore [file]"
    echo "Default file: ${DEFAULT_FILE}"
    exit 1
}

cmd_save() {
    SESSION="${1:-}"
    FILE="${2:-${DEFAULT_FILE}}"

    if [ -z "${SESSION}" ]; then
        SESSION_COUNT=$(tmux list-sessions | wc -l)
        if [ "${SESSION_COUNT}" -eq "0" ]; then
            echo "Error: No tmux sessions exist"
            exit 1
        elif [ "${SESSION_COUNT}" -gt "1" ]; then
            echo "Error: session must be supplied (found ${SESSION_COUNT} sessions):"
            tmux list-sessions
            exit 1
        else
            SESSION=$(tmux list-sessions -F '#{session_name}')
        fi
    fi

    # Sanity check
    if ! tmux has-session -t "${SESSION}" 2>/dev/null; then
        echo "Error: Session '${SESSION}' does not exist"
        exit 1
    fi

    # Directory to pack restore data into a single file
    TMPDIR=$(mktemp -d)

    WINDOWS=$(tmux list-windows -t "${SESSION}" -F '#{window_index}:#{window_name}:#{window_layout}')
    echo "${WINDOWS}" > "${TMPDIR}/windows.txt"

    while IFS=: read -r WINDOW_INDEX WINDOW_NAME WINDOW_LAYOUT; do
        echo "${WINDOW_LAYOUT}" > "${TMPDIR}/window_${WINDOW_INDEX}_layout.txt"
        echo "${WINDOW_NAME}" > "${TMPDIR}/window_${WINDOW_INDEX}_name.txt"

        PANES=$(tmux list-panes -t "${SESSION}:${WINDOW_INDEX}" -F '#{pane_index}:#{pane_current_path}')
        echo "${PANES}" > "${TMPDIR}/window_${WINDOW_INDEX}_panes.txt"

        while IFS=: read -r PANE_INDEX PANE_PATH; do
            echo "${PANE_PATH}" > "${TMPDIR}/window_${WINDOW_INDEX}_pane_${PANE_INDEX}_pwd.txt"

            # Capture entire scrollback history
            tmux capture-pane -e -t "${SESSION}:${WINDOW_INDEX}.${PANE_INDEX}" -S - -p > "${TMPDIR}/window_${WINDOW_INDEX}_pane_${PANE_INDEX}_scrollback.txt" 2>/dev/null || true
        done <<< "${PANES}"
    done <<< "${WINDOWS}"

    # Pack into a single file
    tar -czf "${FILE}" -C "${TMPDIR}" .
    rm -rf "${TMPDIR}"
    echo "Saved session '${SESSION}' to ${FILE}"
}

cmd_restore() {
    FILE="${1:-${DEFAULT_FILE}}"

    if [ ! -f "${FILE}" ]; then
        echo "File ${FILE} not found"
        exit 1
    fi

    TMPDIR=$(mktemp -d)
    tar -xzf "${FILE}" -C "${TMPDIR}"
    CHECK_SCROLL_FILES=()

    SESSION=$(tmux new-session -d -P -F '#{session_name}')
    while IFS= read -r LINE; do
        WINDOW_INDEX=$(echo "${LINE}" | cut -d: -f1)
        WINDOW_NAME=$(echo "${LINE}" | cut -d: -f2)
        WINDOW_LAYOUT=$(echo "${LINE}" | cut -d: -f3-)

        if [ "${WINDOW_INDEX}" != "0" ]; then
            tmux new-window -t "${SESSION}:" -n "${WINDOW_NAME}" 2>/dev/null || true
        else
            # Rename first window because it already exists
            tmux rename-window -t "${SESSION}:0" "${WINDOW_NAME}" 2>/dev/null || true
        fi

        # Split window panes
        PANE_FILE="${TMPDIR}/window_${WINDOW_INDEX}_panes.txt"
        if [ -f "${PANE_FILE}" ]; then
            PANE_COUNT=$(wc -l < "${PANE_FILE}")
            CURRENT_PANE_COUNT=1
            while [ "${CURRENT_PANE_COUNT}" -lt "${PANE_COUNT}" ]; do
                tmux split-window -t "${SESSION}:${WINDOW_INDEX}" -v
                CURRENT_PANE_COUNT=$((CURRENT_PANE_COUNT + 1))
            done
        fi

        # Apply pane layouts
        if [ -f "${TMPDIR}/window_${WINDOW_INDEX}_layout.txt" ]; then
            LAYOUT=$(cat "${TMPDIR}/window_${WINDOW_INDEX}_layout.txt")
            tmux select-layout -t "${SESSION}:${WINDOW_INDEX}" "${LAYOUT}" 2>/dev/null || true
        fi

        while IFS=: read -r PANE_INDEX PANE_PATH; do
            PANE_TARGET="${SESSION}:${WINDOW_INDEX}.${PANE_INDEX}"
            SCROLL_FILE="${TMPDIR}/window_${WINDOW_INDEX}_pane_${PANE_INDEX}_scrollback.txt"
            if ! tmux list-panes -t "${SESSION}:${WINDOW_INDEX}" -F '#{pane_index}' | grep -qx "${PANE_INDEX}"; then
                # Pane index does not exist
                printf -v ERROR_MESSAGE '%q' "Error: Failed to set pane ${PANE_INDEX} working directory to ${PANE_PATH}"
                printf -v SCROLL_MESSAGE '%q' "  Scrollback history can be found at ${SCROLL_FILE}"
                tmux send-keys -t "${SESSION}:${WINDOW_INDEX}.0" "echo ${ERROR_MESSAGE}" C-m
                tmux send-keys -t "${SESSION}:${WINDOW_INDEX}.0" "echo ${SCROLL_MESSAGE}" C-m
                continue
            fi

            # Set PWD by sending cd command
            tmux send-keys -t "${PANE_TARGET}" "cd '${PANE_PATH}'" C-m 2>/dev/null || true

            if [ -f "${SCROLL_FILE}" ]; then
                # There doesn't appear to be a way to actually restore scrollback history, so this is the next best method
                SCROLL_DONE_FILE="${SCROLL_FILE}.done"
                tmux send-keys -t "${PANE_TARGET}" \
                    "cat -- '${SCROLL_FILE}' && mv -- '${SCROLL_FILE}' '${SCROLL_DONE_FILE}'" C-m
                CHECK_SCROLL_FILES+=("${SCROLL_DONE_FILE}")
            fi
        done <<< "$(cat "${PANE_FILE}" 2>/dev/null || echo '')"
    done <<< "$(cat "${TMPDIR}/windows.txt" 2>/dev/null || echo '')"

    SCROLL_TIMEOUT=$((SECONDS + 10))
    while :; do
        PENDING_SCROLL_COUNT=0
        for SCROLL_DONE_FILE in "${CHECK_SCROLL_FILES[@]}"; do
            if [ ! -f "${SCROLL_DONE_FILE}" ]; then
                PENDING_SCROLL_COUNT=$((PENDING_SCROLL_COUNT + 1))
            fi
        done

        if [ "${PENDING_SCROLL_COUNT}" -eq 0 ]; then
            break
        fi

        if [ "${SECONDS}" -gt "${SCROLL_TIMEOUT}" ]; then
            echo "Warning: Timed out waiting for ${PENDING_SCROLL_COUNT} pane scrollback file(s)." >&2
            echo "         Some pane scrollback history will be missing."
            break
        fi

        sleep 0.1
    done

    # Clean up
    rm -rf "${TMPDIR}"
    echo "Restored session to '${SESSION}'"
    echo "Attach to it with:"
    echo "  tmux a -t '${SESSION}'"
}

if [ $# -lt 1 ]; then usage; fi
case "$1" in
    save)
        cmd_save "${2:-}" "${3:-}"
        ;;
    restore)
        cmd_restore "${2:-}"
        ;;
    *)
        usage
        ;;
esac
