#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/lib.sh"

show_status() {
  ssh "$SERVER" "systemctl --user status --no-pager $1"
}

read_quadlet_dir_and_server "$@"
services=$(service_names_from_container_files)
die_if_no_services "$services"
show_status "$(build_service_names_from_build_files)$services"
