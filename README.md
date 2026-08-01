# Development Environments

Versioned, non-root development images and project templates for the repositories under `~/devel`.

## Images

- `ghcr.io/pyrodie18/python-dev`: Python 3.12, uv, Git, build tools, and the pinned standalone Codex CLI.
- `ghcr.io/pyrodie18/ansible-dev`: the same Python 3.12 foundation plus controller-side Ansible system dependencies. Ansible itself stays in each collection's `uv.lock`.

The Dockerfiles pin the upstream Dev Container and uv images by digest, and pin
the standalone Codex CLI release by version and SHA-256. Project devcontainer
definitions pin the published release tag to its immutable GHCR manifest digest.
Use `scripts/pin-image-digest` after publishing each future image release.

## Local build

```bash
./scripts/build-images
./scripts/validate-repository
```

The equivalent `make build` and `make validate` targets are provided for hosts
that have Make installed.

The local tags match the tags produced by CI:

```text
ghcr.io/pyrodie18/python-dev:2026.08.01.1
ghcr.io/pyrodie18/ansible-dev:2026.08.01.1
```

Published manifest digests:

```text
python-dev  sha256:f9f58a7231d037ca519f987c7cb1d58de00083ffafbcc8c3ef52697b8fa15c95
ansible-dev sha256:809842b075b72df2ac1e93313909e8950e31349b52039cb0d2eda88066ac889e
```

## New projects

Copy the appropriate directory from `templates/`, replace every `__PLACEHOLDER__`, and run `scripts/validate-project` from this repository against the new project.

See `docs/workflow.md` for the daily, worktree, cloud-task, and disposable
cross-collection workflows. See `docs/account-boundaries.md` for the required
development, personal, and retired-account split.

Create isolated linked worktrees with `scripts/create-worktree`; do not manually
copy and edit devcontainer state, cache, or Git mount settings.

Secrets are never stored here or in project repositories. Put project secret files at `~/.config/dev-secrets/<repo>.env` with mode `0600` and pass them only to the command that needs them.

## Git authentication

Project containers mount a VM-side SSH agent socket at
`/tmp/codex-dev-ssh-agent.sock`; they never mount `~/.ssh` or a private key. The
host-side `scripts/ensure-ssh-agent` command creates the UID-1000 agent on demand
before each container starts. Set `CODEX_DEV_SSH_KEY` on the VM only if the
development key is not `~/.ssh/id_ed25519`.

## Codex state

Every project mounts an isolated host directory from `~/.local/state/codex-dev/<repo-slug>` as `/home/vscode/.codex`. The image-provided `bootstrap-codex-home` command creates model-neutral `fast` and `deep-review` profiles and forces ChatGPT authentication. Run `codex login` once inside each new project container. On later starts, `setup-codex-project` automatically verifies Codex health, the curated GitHub plugin, and forwarded GitHub SSH authentication.

## Codex sandbox

The installed Codex CLI's `:workspace` sandbox was tested inside these images.
Docker's built-in seccomp profile blocked creation of the nested user namespace;
adding only `--security-opt seccomp=unconfined` made the real Codex sandbox pass.
The templates therefore carry that one verified relaxation. They do not disable
AppArmor, add capabilities, use privileged mode, or mount the Docker socket.

## Publishing

Push this repository to `pyrodie18/dev-environments`. The `publish-images` workflow publishes both images to GHCR on a version tag such as `v2026.08.01.1` and on manual dispatch. Package write permission is supplied by GitHub Actions; no registry credential belongs in this repository.
