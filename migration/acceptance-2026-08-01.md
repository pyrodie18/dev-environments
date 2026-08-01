# Pilot acceptance — 2026-08-01

## Base images

- Python local tag: `ghcr.io/pyrodie18/python-dev:2026.08.01.1`
  - local image ID: `sha256:369d6e5e1f1054957f32702eed52af8dcf84ee7f36ef9ab5e397dd38cd0ef8cb`
  - GHCR manifest digest: `sha256:f9f58a7231d037ca519f987c7cb1d58de00083ffafbcc8c3ef52697b8fa15c95`
- Ansible local tag: `ghcr.io/pyrodie18/ansible-dev:2026.08.01.1`
  - local image ID: `sha256:e173ed8d5b078061fe699c24078a8d3892efaf979ab9aeacf553a79f6ae7c7b7`
  - GHCR manifest digest: `sha256:809842b075b72df2ac1e93313909e8950e31349b52039cb0d2eda88066ac889e`

Both images run as `vscode` (UID 1000), set `HOME=/home/vscode`, use Python
3.12.13, uv 0.8.15, and the checksum-verified standalone Codex CLI 0.144.4.
Both expose Codex at `/usr/local/bin/codex`, include ripgrep 13.0.0, and contain no `OPENAI_API_KEY`.
Neither image contains project dependencies or credentials.

GitHub Actions run `30715348030` published both images successfully from tag
`v2026.08.01.1`. Both pilots and all templates are pinned to the portable GHCR
manifest digests above.

## Python pilot: gmail_mcp

- Lock SHA-256: `f32b8fd5324f7a52aebec23ae4393be09dbf8fe800c1297b583be7d4c29bcacb`
- Repeated empty-cache `uv lock --check` and frozen sync resolved 64 packages.
- Tests: 18 passed.
- Flake8: passed with the repository's documented 120-column convention.
- Source distribution and wheel: built successfully.
- Observed empty-cache end-to-end time: approximately 11 seconds after the base
  image was present locally.

## Ansible pilot: pyrodie18.utils

- Host relocation: `~/devel/ansible/pyrodie18.utils`.
- Container path: `/workspace/ansible_collections/pyrodie18/utils`.
- Lock SHA-256: `085a906f5bbe47ae70f020e348a064e35e40e4649327bdc7030cda3011b57934`.
- Locked controller: ansible-core 2.20.7 on Python 3.12.13.
- Ansible lint, Flake8, and antsibull-changelog lint: passed.
- `ansible-test sanity --python 3.12`: passed.
- `test_passphrase` integration: 24 tasks passed.
- Galaxy artifact `pyrodie18-utils-1.0.0.tar.gz`: built and installed
  successfully into an empty destination.
- Observed empty-cache full acceptance time: approximately 90 seconds, primarily
  from ansible-test's own pinned sanity-test environments.

## Isolation and Codex

Both pilot mounts were tested as UID 1000. Each could write its own repository
and read its own `0700` Codex home, but had no sibling repository mount, host SSH
mount, Docker socket, or OpenAI API key.

The real installed Codex CLI `:workspace` sandbox failed under Docker's built-in
seccomp profile because it could not create its nested user namespace. It passed
with only `seccomp=unconfined`. No AppArmor override, capability, privileged mode,
or Docker socket was required. A generated isolated Codex home also loaded
successfully during that real sandbox invocation.

Both pilots were rebuilt from the `2026.08.01.1` digest pins. In each live
container, Codex Doctor reported 17 checks OK, 0 warnings, and 0 failures;
ripgrep was detected; `github@openai-curated` was installed and enabled; and the
forwarded ED25519 agent authenticated successfully to GitHub as `pyrodie18`.
Both repositories remained clean and synchronized after the rebuild. Their mount
inventories contained only the current repository, isolated Codex state,
project-specific caches, the forwarded agent socket, and VS Code support state.

A second `gmail_mcp` linked worktree was opened in its own devcontainer on branch
`test/worktree-isolation`. The container mounted the linked checkout plus only
the primary checkout's shared Git metadata, not its source tree. It used separate
Codex state, uv cache, and `.venv`; its Codex Doctor and GitHub/SSH setup passed.
Both containers ran the 18-test suite concurrently and passed. A temporary marker
created in the worktree Codex home was not visible from the primary container.

## Recovery and gates

- `legacy/ansible-devcontainer-history.bundle` verifies as complete.
- `legacy/ansible-devcontainer-working-tree.patch` preserves the tracked legacy
  working-tree changes without copying the untracked credential environment file.
- Dirty repositories listed in `snapshot-2026-08-01.md` were not modified.
- The old shared Ansible environment and outer Git repository remain in place.

Completed pilot gates:

1. Created and pushed `pyrodie18/dev-environments` with an independent root
   commit, published both GHCR images, and pinned every template and pilot image.
2. Rebuilt both pilots from their digest pins and verified automated Codex,
   GitHub plugin, SSH-agent, non-root, secret, and mount-isolation checks.
3. Used the migrated Ansible repository to test, commit, and push successfully.
4. Ran the primary Gmail checkout and a linked worktree concurrently with
   isolated dependencies, caches, Codex state, branches, and source mounts.

Before the remaining repositories or shared environments are touched:

1. Complete the Gmail MCP real OAuth/read-only end-to-end check if it was not
   included in the user's pilot testing.
2. Commit or separately back up every dirty repository before relocating it.
3. Only then archive/retire the old shared collection mirror, shared Codex state,
   and language-level devcontainers.
