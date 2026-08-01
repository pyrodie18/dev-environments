# Pilot acceptance — 2026-08-01

## Base images

- Python local tag: `ghcr.io/pyrodie18/python-dev:2026.08.01`
  - local image ID: `sha256:fb32c79322f270ea8abcb31e0f3585622572bc1f22d0be3bb37004b4d79b60ae`
- Ansible local tag: `ghcr.io/pyrodie18/ansible-dev:2026.08.01`
  - local image ID: `sha256:f3ce9b0038768fc091308a207a5aa3b7e16f936484e15cb09e067acb2d31f094`

Both images run as `vscode` (UID 1000), set `HOME=/home/vscode`, use Python
3.12.13, uv 0.8.15, and the checksum-verified standalone Codex CLI 0.144.4.
Both expose Codex at `/usr/local/bin/codex` and contain no `OPENAI_API_KEY`.
Neither image contains project dependencies or credentials.

These are local image IDs, not portable GHCR manifest digests. The publication
and digest-pinning gate remains open until the new GitHub repository and package
exist.

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

## Recovery and gates

- `legacy/ansible-devcontainer-history.bundle` verifies as complete.
- `legacy/ansible-devcontainer-working-tree.patch` preserves the tracked legacy
  working-tree changes without copying the untracked credential environment file.
- Dirty repositories listed in `snapshot-2026-08-01.md` were not modified.
- The old shared Ansible environment and outer Git repository remain in place.

Before the remaining repositories or shared environments are touched:

1. Create and push `pyrodie18/dev-environments`, publish both GHCR images, and pin
   every template and pilot image reference with `scripts/pin-image-digest`.
2. Open each pilot through Remote SSH + Dev Containers, run `codex login` with the
   primary development account, install `github@openai-curated`, and run
   `codex doctor`.
3. Exercise two simultaneous worktree containers and use at least one migrated
   production repository successfully.
4. Commit or separately back up every dirty repository before relocating it.
5. Only then archive/retire the old shared collection mirror, shared Codex state,
   and language-level devcontainers.
