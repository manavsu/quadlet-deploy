# podman_deploy

Shell scripts + a Makefile fragment for deploying Podman Quadlet units to a server over SSH.
Projects pull this repo in automatically via `make`; it is not deployed itself.

## Layout

```
podman_deploy/
├── podman.mk         # Makefile fragment projects include
└── scripts/
    ├── lib.sh        # shared helpers (set -eu, logging, arg checks)
    ├── install.sh    # install podman + rsync, enable linger
    ├── deploy.sh     # push quadlets, daemon-reload, restart
    ├── status.sh
    └── logs.sh
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
PODMAN_DEPLOY_VERSION := v0.1.0
SERVER := me@myhost

include .podman_deploy/podman.mk

.podman_deploy/podman.mk:
	git clone --depth 1 --branch $(PODMAN_DEPLOY_VERSION) \
	  https://github.com/<you>/podman_deploy.git .podman_deploy
```

Add `.podman_deploy/` to `.gitignore`.

Then:

```sh
make deploy                 # first run clones the helper
make status
make logs
make podman-deploy-update   # after bumping PODMAN_DEPLOY_VERSION
```

Override `QUADLET_DIR` (default `$(CURDIR)/quadlet`) or `SERVER` in the project Makefile
or on the command line.

## Releasing

```sh
git tag v0.1.0 && git push --tags
```

## On the server

Debian 13+, rootless. You connect as your normal user (needs sudo for `make install`).

- `install.sh`: installs podman + rsync and enables linger so services survive logout.
- `deploy.sh`: copies `quadlet/` to `~/.config/containers/systemd/<project>/`, then
  `systemctl --user daemon-reload` and restarts one service per `.container` file.
