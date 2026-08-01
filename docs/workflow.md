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

On every container start, `setup-codex-project` checks the forwarded SSH key,
verifies GitHub SSH authentication, ensures the curated GitHub plugin is
installed when Codex is logged in, and runs `codex doctor`. These checks warn
without making the development container unusable during a transient network
failure.

The first time a repository is opened, run `codex login` for its isolated Codex
home. Restart the container once after login; subsequent setup and health checks
are automatic. They can also be requested immediately with:

```bash
setup-codex-project <project-slug>
```

GitHub's successful SSH test exits without providing a shell, which is expected.

## Parallel work

Create a worktree beside the main checkout with the central helper, then open
the reported path in its own Remote SSH window:

```bash
~/devel/dev-environments/scripts/create-worktree \
  ~/devel/<type>/<repository> <task-branch> origin/main
```

Run `git fetch origin` in the primary repository first when `origin/main` is not
current. The helper creates a sibling checkout, corrects its UID ownership, and
generates worktree-local devcontainer settings for Git metadata, caches, and
Codex state. It marks only that generated devcontainer file `skip-worktree` so it
cannot be accidentally committed with task changes.

A linked worktree's `.git` file points to the primary checkout's shared Git
database. Because a normal project container must not mount the primary source
tree, the generated worktree devcontainer instead:

- mount only the primary checkout's `.git` directory at a container-only path;
- set `GIT_DIR` to that mount's `worktrees/<worktree-name>` directory;
- set `GIT_WORK_TREE` to the linked worktree's container workspace path; and
- ensure both the linked checkout and its worktree-specific Git metadata are
  writable by UID 1000.

Keep the VM-side worktree links absolute. The VM currently uses Git 2.47, which
does not understand the newer `extensions.relativeWorktrees` repository format.
Do not mount the primary checkout's source files into the worktree container.

Use Codex cloud for longer GitHub-backed tasks and review the resulting branch
locally. Promote a repeated, stable procedure from `AGENTS.md` into a repo-local
skill only after it has proven reusable.

## Intentional cross-collection testing

Do not recreate the old Galaxy mirror. Start from
`templates/ansible-integration`, declare exact collection versions or Git SHAs in
its `requirements.yml`, and let that disposable repository own the integration
scenario. Never bind-mount sibling collection worktrees into a normal collection
container.
