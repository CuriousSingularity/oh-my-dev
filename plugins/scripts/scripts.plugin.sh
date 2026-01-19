#!/usr/bin/env bash
# Script plugin for Oh My Dev
# Provides useful script aliases and functions

# Store the script path when the file is sourced

# Function to run ec2.py script by resolving its path
ec2() {
    local SCRIPT_BASE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local script_path="$SCRIPT_BASE_PATH/python/ec2.py"

    if [[ -f "$script_path" ]]; then
        python3 "$script_path" "$@"
    else
        echo "Error: ec2.py not found at $script_path" >&2
        return 1
    fi
}
