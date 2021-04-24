#!/bin/bash

set -eux

# Helper function to execute commands in the same bash session as the window when it's created.
# This prevents the window from dieing after the commands complete since bash is holding the
# window open.
# Note: The sleep attempts to delay any output until after the tmux session has completely started,
# otherwise the output will mysteriously be cleared.
function inWindow() {
  echo "bash --init-file <(echo 'source ~/.bashrc ; sleep 1 ; $@')"
}

function gitLog() {
  inWindow git --no-pager l -n 30 \; echo
}

# First call creates a new detached session (-d), names the window (-n), and changes to some directory (-c)
tmux new-session -d -n WINDOW_NAME -c ~/projects
# Horizontal split
tmux split-window -h -c ~/projects/SOME-PROJECT "$(gitLog)"
# Vertical split
tmux split-window -v -c ~/projects/SOME-PROJECT/build "$(inWindow echo -e "Some useful message to see when the session is created\\\n\\\texample command")"
# Vertical split on the first pane of the current window
tmux split-window -t 0 -v -c ~/projects/SOME-PROJECT

# Successive calls to create new windows in the same session
tmux new-window -n ANOTHER_WINDOW_NAME -c ~/projects/SOME-OTHER-PROJECT

# Finally, attach to the new session, using the directory specified by -c for new windows
tmux attach-session -d -c ~/
