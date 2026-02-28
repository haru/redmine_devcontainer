# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Does

This repository builds Docker-based development environments for Redmine plugin development, distributed as a `.tgz` archive that developers extract into their plugin repositories. It supports GitHub Codespaces and VS Code Dev Containers.

## Build Commands

```bash
# Build and push a single version combination locally (maintainer use)
bash docker/build.sh 6.1-stable 3.2          # Redmine 6.1-stable, Ruby 3.2
bash docker/build.sh 6.1-stable 3.2 trixie   # explicit Debian version

# Validate locally without pushing (before running build.sh)
docker buildx build --load docker/

# Package the .devcontainer bundle for distribution
bash dot_devcontainer/build_archive.sh       # outputs dot_devcontainer/dot_devcontainer.tgz
```

> **Note:** Building all supported version combinations is handled automatically by GitHub Actions
> (`.github/workflows/release.yml`). There is no need to run them manually.

## Testing (inside a built container)

```bash
bundle exec rake test:scm:setup:all
bundle exec rake test TEST=plugins/your_plugin_test.rb
```

## Project Layout

- `docker/` — Dockerfile and build scripts for the base devcontainer image
  - `Dockerfile` — builds `ruby:<version>-<debian>`, installs Redmine, gems, Node.js (via nvm), GitHub CLI, and debugging tools
  - `supported_versions.conf` — matrix of tested Redmine/Ruby/Debian combinations; update this when adding version support
  - `build.sh` — local single-version build script (multi-arch via QEMU)
- `dot_devcontainer/` — assets packaged into the distributable `.tgz`
  - `.devcontainer/devcontainer.json` — VS Code dev container config with extensions
  - `.devcontainer/docker-compose.yml` — app + postgres + mysql services
  - `.devcontainer/post-create.sh` — symlinks plugin, installs gems, migrates all three databases
  - `.devcontainer/plugin_generator.sh` — generates new Redmine plugin boilerplate
  - `build_archive.sh` — packages `.devcontainer/` into `dot_devcontainer.tgz`
- `.github/workflows/release.yml` — builds and pushes Docker images; triggers on push to `main`/`develop` when `docker/**` changes, and on manual dispatch
- `docs/` — design documents
  - `github-actions-docker-build.md` — design specification for the GitHub Actions Docker build workflow

## Coding Conventions

- **Shell scripts:** POSIX sh, four-space indents, `set -euo pipefail` on new entry points, kebab-case filenames
- **Dockerfiles:** group related `RUN` instructions; keep `ARG` defaults in sync with `supported_versions.conf`
- **Environment variables:** UPPERCASE_WITH_UNDERSCORES
- **Commit messages:** `area: concise change` pattern (e.g., `Dockerfile: Update bashrc handling`), first line ≤72 chars

## CI/CD

Pushing changes to `docker/**` or `.github/workflows/release.yml` on `main`/`develop` triggers the GitHub Actions workflow (`.github/workflows/release.yml`), which:

1. Builds all Docker images in the matrix for both `amd64` and `arm64` using native GitHub-hosted runners
2. Merges the per-arch images into multi-arch manifests and pushes them to DockerHub

Build failures are notified via Slack (`SLACK_WEBHOOK_URL` secret).

To add a new version combination, update `docker/supported_versions.conf` and add the corresponding entry to the matrix in `.github/workflows/release.yml`.
