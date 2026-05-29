#!/usr/bin/env bash

# https://github.com/anakin4747/neovim-killed-tmux/blob/main/nvim-stuff/v

# Function to check if any parent process is nvim
is_inside_nvim() {
    local current_pid=$$
    while [ "$current_pid" -gt 1 ]; do
        # Get the process name and parent PID
        local stats
        stats=$(ps -p "$current_pid" -o ppid=,comm= 2>/dev/null)
        [ -z "$stats" ] && break

        local ppid=$(echo "$stats" | awk '{print $1}')
        local comm=$(echo "$stats" | awk '{print $2}')

        if [[ "$comm" == *"nvim"* ]]; then
            return 0
        fi
        current_pid=$ppid
    done
    return 1
}

if is_inside_nvim; then
    # inside neovim
    if [ "$#" -ne "0" ]; then
        # Ensure NVIM socket variable is actually set
        if [ -n "$NVIM" ]; then
            realpath --zero "$@" | xargs -0 -n1 nvim --server "$NVIM" --remote
        else
            echo "Error: NVIM server socket not found." >&2
            exit 1
        fi
    fi
    exit
fi

# outside neovim
if [ "$#" -eq "0" ]; then
    nvim --startuptime /tmp/nvim-startup.log
    exit
fi

nvim "$@" --startuptime /tmp/nvim-startup.log
