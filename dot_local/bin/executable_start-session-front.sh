#!/bin/bash

# 1. Setup variables
TARGET_DIR=$(realpath "${1:-.}")
SESSION=${2:-dev}

# 2. The Chain: Create -> Window 1 -> Window 2 -> Server
# If the 'new-session' fails, it skips to the echo.
tmux new-session -d -s "$SESSION" -c "$TARGET_DIR" -n "neovim" && \
tmux send-keys -t "$SESSION:neovim" "nvim" C-m && \
tmux new-window -t "$SESSION" -n "serve" -c "$TARGET_DIR" && \
tmux send-keys -t "$SESSION:serve" "ng serve" C-m || echo "Session '$SESSION' is already running."

# 3. Final Step: Attach
# We use switch-client if you're already in tmux, otherwise attach.
if [ -z "$TMUX" ]; then
    tmux attach -t "$SESSION"
else
    tmux switch-client -t "$SESSION"
fi
