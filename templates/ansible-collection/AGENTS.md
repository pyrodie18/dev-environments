# Collection guidance

- Bootstrap with `uv sync --frozen --group dev`.
- Install collection dependencies with `uv run --frozen ansible-galaxy collection install -r requirements.yml -p /home/vscode/.ansible/collections`.
- Run lint with `uv run --frozen ansible-lint` and `uv run --frozen flake8 plugins`.
- Run sanity checks with `uv run --frozen ansible-test sanity --python 3.12`.
- Run integration tests only from the collection's FQCN workspace path.
- Build with `uv run --frozen ansible-galaxy collection build --force`.
- Add controller dependencies through `uv add --group dev`; pin collection test dependencies in `requirements.yml`.
- Do not read or modify sibling collection repositories.
- Do not commit secrets, inventories containing credentials, virtual environments, caches, or test output.
