#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/lib.sh"

read_server() {
  [ $# -eq 1 ] || die "usage: $0 SERVER"
  SERVER=$1
}

podman_and_rsync_are_installed() {
  ssh "$SERVER" 'command -v podman && command -v rsync' >/dev/null
}

install_podman_and_rsync() {
  log "Installing podman and rsync on $SERVER"
  ssh -t "$SERVER" 'sudo apt-get update && sudo apt-get install -y podman rsync'
}

linger_is_enabled() {
  ssh "$SERVER" 'test -f "/var/lib/systemd/linger/$USER"'
}

enable_linger() {
  log "Enabling linger on $SERVER"
  ssh -t "$SERVER" 'sudo loginctl enable-linger "$USER"'
}

read_server "$@"
if podman_and_rsync_are_installed; then
  log "podman and rsync already installed on $SERVER"
else
  install_podman_and_rsync
fi
if linger_is_enabled; then
  log "linger already enabled on $SERVER"
else
  enable_linger
fi
