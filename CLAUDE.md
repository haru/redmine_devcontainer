# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Does

This repository builds Docker-based development environments for Redmine plugin development, distributed as a `.tgz` archive that developers extract into their plugin repositories. It supports GitHub Codespaces and VS Code Dev Containers.

## Build Commands

```bash
# Build and push a multi-arch image (amd64 + arm64) for a specific version combination
bash docker/build.sh 6.1-stable 3.2          # Redmine 6.1-stable, Ruby 3.2
bash docker/build.sh 6.1-stable 3.2 trixie   # explicit Debian version

# Build all supported version combinations (reads docker/supported_versions.conf)
bash docker/build_all_versions.sh

# Validate locally without pushing (before running build.sh)
docker buildx build --load docker/

# Package the .devcontainer bundle for distribution
bash dot_devcontainer/build_archive.sh       # outputs dot_devcontainer/dot_devcontainer.tgz
```

## Testing (inside a built container)

```bash
bundle exec rake test:scm:setup:all
bundle exec rake test TEST=plugins/your_plugin_test.rb
```

## Project Layout

- `docker/` — Dockerfile and build scripts for the base devcontainer image
  - `Dockerfile` — builds `ruby:<version>-<debian>`, installs Redmine, gems, Node.js (via nvm), GitHub CLI, and debugging tools
  - `supported_versions.conf` — matrix of tested Redmine/Ruby/Debian combinations; update this when adding version support
  - `build.sh` / `build_all_versions.sh` — multi-arch build pipeline
- `dot_devcontainer/` — assets packaged into the distributable `.tgz`
  - `.devcontainer/devcontainer.json` — VS Code dev container config with extensions
  - `.devcontainer/docker-compose.yml` — app + postgres + mysql services
  - `.devcontainer/post-create.sh` — symlinks plugin, installs gems, migrates all three databases
  - `.devcontainer/plugin_generator.sh` — generates new Redmine plugin boilerplate
  - `build_archive.sh` — packages `.devcontainer/` into `dot_devcontainer.tgz`
- `.github/workflows/release.yml` — on git tag, builds archive and uploads to GitHub Releases

## Coding Conventions

- **Shell scripts:** POSIX sh, four-space indents, `set -euo pipefail` on new entry points, kebab-case filenames
- **Dockerfiles:** group related `RUN` instructions; keep `ARG` defaults in sync with `supported_versions.conf`
- **Environment variables:** UPPERCASE_WITH_UNDERSCORES
- **Commit messages:** `area: concise change` pattern (e.g., `Dockerfile: Update bashrc handling`), first line ≤72 chars

## Release Process

Tag a commit to trigger the GitHub Actions release workflow, which automatically runs `build_archive.sh` and uploads `dot_devcontainer.tgz` to the GitHub Release.
