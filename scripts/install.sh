#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/lib.sh"

install_podman_and_enable_linger() {
  log "Installing podman on $SERVER"
  ssh -t "$SERVER" 'sudo apt-get update && sudo apt-get install -y podman rsync && sudo loginctl enable-linger "$USER" && podman --version'
}

read_quadlet_dir_and_server "$@"
install_podman_and_enable_linger
