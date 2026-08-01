# Development workflow

## Daily work

1. Connect to the Rocky Linux VM with VS Code Remote SSH.
2. Open one Git repository, never the `python` or `ansible` organizer directory.
3. Choose **Dev Containers: Reopen in Container**.
4. Run the bootstrap command from that repository's `AGENTS.md`.
5. Use only the repository-owned test, lint, build, and release commands.

The project directory is the only source tree mounted into its container. Before
container creation, `scripts/ensure-ssh-agent` starts a VM-side agent as UID 1000
and loads the VM's development key. The container mounts only that agent socket;
host SSH files and private keys are never mounted. Dependencies, Codex state,
secrets, and caches are project-specific.

After rebuilding a container, verify GitHub authentication with:

```bash
ssh-add -l
ssh -T git@github.com
```

GitHub's successful SSH test exits without providing a shell, which is expected.

## Parallel work

Create a worktree beside the main checkout and open that worktree in its own
devcontainer:

```bash
git fetch origin
git worktree add ../<repository>-<task> -b <task-branch> origin/main
```

Each worktree gets its own container. If simultaneous tasks must not share caches
either, change the volume names and Codex state slug in the copied
`.devcontainer/devcontainer.json` before opening it.

Use Codex cloud for longer GitHub-backed tasks and review the resulting branch
locally. Promote a repeated, stable procedure from `AGENTS.md` into a repo-local
skill only after it has proven reusable.

## Intentional cross-collection testing

Do not recreate the old Galaxy mirror. Start from
`templates/ansible-integration`, declare exact collection versions or Git SHAs in
its `requirements.yml`, and let that disposable repository own the integration
scenario. Never bind-mount sibling collection worktrees into a normal collection
container.
