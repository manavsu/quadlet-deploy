# quadlet-deploy

Shell scripts + a Makefile fragment for deploying Podman Quadlet units to a server over SSH.
Projects pull this repo in automatically via `make`; it is not deployed itself.

## Layout

```
quadlet-deploy/
├── quadlet-deploy.mk # Makefile fragment projects include
└── scripts/
    ├── lib.sh        # shared helpers (set -eu, logging, arg checks)
    ├── install.sh    # install podman + rsync, enable linger
    ├── deploy.sh     # push quadlets, restart build + container services
    ├── status.sh     # systemctl status of the project's services
    └── logs.sh       # follow the project's service logs
```

Scripts locate their own files relative to themselves:

```sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/lib.sh"
```

## Using it from a project

Project layout:

```
myapp/
├── Makefile
└── quadlet/
    └── myapp.container
```

Project `Makefile`:

```make
QUADLET_DEPLOY_VERSION := v0.1.0
SERVER := me@myhost

include .quadlet-deploy/quadlet-deploy.mk

.quadlet-deploy/quadlet-deploy.mk:
	git -c advice.detachedHead=false clone --depth 1 --branch $(QUADLET_DEPLOY_VERSION) \
	  https://github.com/manavsu/quadlet-deploy.git .quadlet-deploy
```

Add `.quadlet-deploy/` to `.gitignore`.

Then:

```sh
make install               # once per server: podman, rsync, linger, auto-update timer
make deploy                # first run clones the helper
make status                # are the services running?
make logs                  # last 100 lines, then follow (Ctrl+C to stop)
make quadlet-deploy-update # after bumping QUADLET_DEPLOY_VERSION
```

Override `QUADLET_DIR` (default `$(CURDIR)/quadlet`) or `SERVER` in the project Makefile
or on the command line.

## Releasing

```sh
git tag v0.1.0 && git push --tags
```

## On the server

Debian 13+, rootless. You connect as your normal user (needs sudo for `make install`).

- `install.sh`: installs podman + rsync, enables linger so services survive logout, and
  enables `podman-auto-update.timer`. It skips anything already set up, so it only needs
  sudo on a fresh server.
- `deploy.sh`: copies `quadlet/` to `~/.config/containers/systemd/<project>/`, then
  `systemctl --user daemon-reload` and restarts `<name>-build.service` for each `.build`
  file and `<name>.service` for each `.container` file.

## Auto-update

`make install` enables `podman-auto-update.timer` (daily). To have a container follow
its registry image, add to its `.container` file:

```ini
[Container]
Image=docker.io/library/nginx:latest
AutoUpdate=registry
```

The image name must be fully qualified. Images built from `.build` files are only
rebuilt on `make deploy`.
