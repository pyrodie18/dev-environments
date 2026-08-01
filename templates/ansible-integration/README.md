# Disposable Ansible integration workspace

Use this as a standalone Git repository only for intentional cross-collection
tests. Put exact Galaxy versions or Git commit SHAs in `requirements.yml`; do not
mount collection worktrees from sibling host directories.

Before opening the devcontainer, create and commit `uv.lock` with `uv lock` in the
versioned Ansible base image. Recreate this workspace freely when its scenario is
finished.
