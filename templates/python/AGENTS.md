# Project guidance

- Bootstrap with `uv sync --frozen --group dev`.
- Run tests with `uv run --frozen pytest`.
- Run lint with `uv run --frozen flake8 src tests`.
- Build with `uv build` after pinning the build-system requirements exactly.
- Add dependencies through `uv add`; never install project packages directly with `pip`.
- Do not read or modify files outside this repository.
- Do not commit secrets, `.env` files, virtual environments, caches, or generated data.
