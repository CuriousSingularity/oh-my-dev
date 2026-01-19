#!/usr/bin/env bash
# Script plugin for Oh My Dev
# Provides useful script aliases and functions

# Store the script path when the file is sourced
# Use namespaced variable to avoid conflicts
readonly OMD_SCRIPTS_PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to run ec2.py script by resolving its path
ec2() {
    local script_path="$OMD_SCRIPTS_PLUGIN_DIR/python/ec2.py"

    if [[ -f "$script_path" ]]; then
        python3 "$script_path" "$@"
    else
        echo "Error: ec2.py not found at $script_path" >&2
        return 1
    fi
}
