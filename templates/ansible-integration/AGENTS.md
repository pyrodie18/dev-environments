# Integration workspace guidance

- Bootstrap with `uv sync --frozen --group dev`.
- Install collection dependencies with `uv run --frozen ansible-galaxy collection install -r requirements.yml -p .ansible/collections`.
- Keep every collection requirement at an exact Galaxy version or Git commit SHA.
- Keep integration scenarios and their commands in this repository.
- Do not mount or edit sibling repositories.
- Delete and recreate this workspace when the intentional cross-collection scenario is complete.
