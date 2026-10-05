#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/lib.sh"

journalctl_unit_flags() {
  for service in $1; do
    printf -- '-u %s ' "$service"
  done
}

follow_logs() {
  ssh -t "$SERVER" "journalctl --user -n 100 -f $(journalctl_unit_flags "$1")"
}

read_quadlet_dir_and_server "$@"
services=$(service_names_from_container_files)
die_if_no_services "$services"
follow_logs "$(build_service_names_from_build_files)$services"
