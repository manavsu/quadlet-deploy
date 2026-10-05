#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/lib.sh"

project_dir_name() {
  basename "$(dirname "$(cd "$QUADLET_DIR" && pwd)")"
}

service_names_from_container_files() {
  for f in "$QUADLET_DIR"/*.container; do
    [ -e "$f" ] || continue
    printf '%s.service ' "$(basename "$f" .container)"
  done
}

build_service_names_from_build_files() {
  for f in "$QUADLET_DIR"/*.build; do
    [ -e "$f" ] || continue
    printf '%s-build.service ' "$(basename "$f" .build)"
  done
}

die_if_no_services() {
  [ -n "$1" ] || die "no .container files in $QUADLET_DIR"
}

copy_quadlets_to_server() {
  dest=.config/containers/systemd/$(project_dir_name)
  log "Copying $QUADLET_DIR to $SERVER:~/$dest"
  rsync -av --delete --mkpath "$QUADLET_DIR"/ "$SERVER:$dest/"
}

restart_services() {
  log "Restarting $1"
  ssh "$SERVER" "systemctl --user daemon-reload && systemctl --user restart $1"
}

read_quadlet_dir_and_server "$@"
services=$(service_names_from_container_files)
die_if_no_services "$services"
build_services=$(build_service_names_from_build_files)
copy_quadlets_to_server
restart_services "$build_services$services"
