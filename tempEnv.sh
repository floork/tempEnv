#!/usr/bin/env bash

# Step 1: Detect current shell
detect_shell() {
  if command -v zsh &>/dev/null; then
    echo "zsh"
  elif command -v bash &>/dev/null; then
    echo "bash"
  else
    echo "Error: Neither zsh nor bash is available." >&2
    exit 1
  fi
}

# Step 2: Create a temporary directory
create_temp_dir() {
  mktemp -d -t shellenv-XXXXXX
}

# Step 3: Clone the GitHub repository
clone_configs() {
  local temp_dir=$1
  local repo_url="https://github.com/floork/shell.git"

  echo "Cloning shell configurations from GitHub..."
  if command -v git &>/dev/null; then
    git clone --depth 1 "$repo_url" "$temp_dir/configs"
  else
    echo "Error: git is not installed."
    exit 1
  fi
}

# Step 4: Link zsh configuration
start_zsh() {
  local config_file=$1
  echo "Starting zsh with temporary configuration..."

  # Set ZDOTDIR to the temp directory
  export ZDOTDIR=$(dirname "$config_file")

  # Launch zsh
  zsh
}

link_zsh_config() {
  local temp_dir=$1
  cp "$temp_dir/configs/zsh/zshrc" "$temp_dir/.zshrc"
  echo "$temp_dir/.zshrc"
}

# Step 5: Start zsh with the temporary configuration
start_zsh() {
  local config_file=$1
  echo "Starting zsh with temporary configuration..."
  ZDOTDIR=$(dirname "$config_file") zsh
}

# Step 6: Cleanup function
cleanup() {
  echo "Cleaning up temporary environment..."
  rm -rf "$TEMP_DIR"
}

# Main script logic
main() {
  TEMP_DIR=$(create_temp_dir)
  trap cleanup EXIT # Ensure cleanup happens on script exit

  clone_configs "$TEMP_DIR"
  CONFIG_FILE=$(link_zsh_config "$TEMP_DIR")

  start_zsh "$CONFIG_FILE"
}

main "$@"
