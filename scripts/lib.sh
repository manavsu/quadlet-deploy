set -eu

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

read_quadlet_dir_and_server() {
  [ $# -eq 2 ] || die "usage: $0 QUADLET_DIR SERVER"
  QUADLET_DIR=$1
  SERVER=$2
  [ -d "$QUADLET_DIR" ] || die "no such directory: $QUADLET_DIR"
}
