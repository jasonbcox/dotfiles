#!/bin/bash

set -eux

# Helper function to execute commands in the same bash session as the window when it's created.
# This prevents the window from dieing after the commands complete since bash is holding the
# window open.
function inWindow() {
  echo "bash --init-file <(echo 'source ~/.bashrc ; $1')"
}

# First call creates a new detached session (-d), names the window (-n), and changes to some directory (-c)
tmux new-session -d -n WINDOW_NAME -c ~/projects
# Horizontal split
tmux split-window -h -c ~/projects/SOME-PROJECT "$(inWindow "git lg-b")"
# Vertical split
tmux split-window -v -c ~/projects/SOME-PROJECT/build "$(inWindow "echo 'Some useful message to see when the session is created'")"

# Successive calls to create new windows in the same session
tmux new-window -n ANOTHER_WINDOW_NAME -c ~/projects/SOME-OTHER-PROJECT

# Finally, attach to the new session, using the directory specified by -c for new windows
tmux attach-session -d -c ~/
