set -eu

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

read_quadlet_dir_and_server() {
  [ $# -eq 2 ] || die "usage: $0 QUADLET_DIR SERVER"
  QUADLET_DIR=$1
  SERVER=$2
  [ -d "$QUADLET_DIR" ] || die "no such directory: $QUADLET_DIR"
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
