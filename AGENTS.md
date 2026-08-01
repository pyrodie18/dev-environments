# Repository guidance

- Keep upstream image and tool references pinned by digest.
- Do not add credentials, `.env` files, Docker authentication, Codex authentication, or project data.
- Run `./scripts/validate-repository` after changing images, templates, or scripts.
- Run `./scripts/build-images` after changing a Dockerfile.
- Keep the two base images small. Runtime and test dependencies belong to each project lockfile.
- Project templates must run as `vscode`, mount only the project plus project-specific state/cache, and must not mount SSH directories or the host Docker socket.
