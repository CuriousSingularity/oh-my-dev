#!/usr/bin/env bash
# Plugin loader for Oh My Dev

# Default plugins list
readonly OMD_DEFAULT_PLUGINS=(
  "claude-code"
  "devtools"
  "docker"
  "gemini"
  "git"
  "scripts"
  "shortcuts"
  "utils"
  "uv"
  "weather"
)

readonly OMD_SCRIPTS_PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)/../plugins/scripts"


# Load all enabled plugins
omd_load_plugins() {
  local -a plugins_to_load=("${OMD_PLUGINS[@]:-${OMD_DEFAULT_PLUGINS[@]}}")

  for plugin in "${plugins_to_load[@]}"; do
    omd_load_plugin "$plugin"
  done
}

# Load a single plugin
omd_load_plugin() {
  local plugin="$1"
  local plugin_path
  
  # Try custom plugins first, then default plugins
  plugin_path="$OMD_DIR/custom/plugins/$plugin/$plugin.plugin.sh"
  [[ ! -f "$plugin_path" ]] && plugin_path="$OMD_DIR/plugins/$plugin/$plugin.plugin.sh"
  
  if [[ -f "$plugin_path" ]]; then
    # shellcheck disable=SC1090
    source "$plugin_path"
  else
    omd_warning "Plugin '$plugin' not found"
    return 1
  fi
}

# List available plugins
omd_list_plugins() {
  echo "Available plugins:"
  echo ""
  
  # List default plugins
  if [[ -d "$OMD_DIR/plugins" ]]; then
  echo "Default plugins:"
    for plugin_dir in "$OMD_DIR/plugins"/*; do
      if [[ -d "$plugin_dir" ]]; then
        echo "  - $(basename "$plugin_dir")"
      fi
    done
  fi

  # List custom plugins
  if [[ -d "$OMD_DIR/custom/plugins" ]]; then
    echo ""
    echo "Custom plugins:"
    for plugin_dir in "$OMD_DIR/custom/plugins"/*; do
      if [[ -d "$plugin_dir" ]]; then
        echo "  - $(basename "$plugin_dir")"
      fi
    done
  fi
}
