#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/lib.sh"

die_unless_in_versions_dir() {
  [ "$(basename "$versions_dir")" = .quadlet-deploy ] ||
    die "$current_version_dir is not inside a .quadlet-deploy/ folder"
}

remove_other_versions() {
  for dir in "$versions_dir"/*/; do
    dir=${dir%/}
    [ "$dir" = "$current_version_dir" ] && continue
    log "Removing $dir"
    rm -rf "$dir"
  done
}

current_version_dir="$(cd "$SCRIPT_DIR/.." && pwd)"
versions_dir="$(dirname "$current_version_dir")"
die_unless_in_versions_dir
remove_other_versions
