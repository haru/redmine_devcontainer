# Repository Guidelines

## Project Structure & Module Organization
- `docker/` holds the Dockerfile, launch profile, and helper scripts for building Redmine-ready devcontainers. Keep new tooling scripts here.
- `dot_devcontainer/` contains the packaging script that assembles the `.devcontainer` bundle shipped in releases.
- `README.md` documents onboarding steps; update it whenever workflow changes.

## Build, Test, and Development Commands
- `bash docker/build.sh 6.1-stable 3.2` builds and pushes a multi-arch devcontainer image for the named Redmine and Ruby versions.
- `bash docker/build_all_versions.sh` iterates the versions listed in `docker/supported_versions.conf` and builds each image.
- `bash dot_devcontainer/build_archive.sh` refreshes the distributable `dot_devcontainer.tgz` after you modify `.devcontainer` assets.

## Coding Style & Naming Conventions
- Shell scripts: prefer POSIX sh, four-space indents, and `set -euo pipefail` when adding new entry points.
- Dockerfiles: group related RUN instructions; keep image ARG defaults in sync with supported Redmine releases.
- Use kebab-case for new script filenames and keep environment variables uppercase with underscores.

## Testing Guidelines
- Validate images locally with `docker buildx build --load` before pushing to registries.
- Inside a built container, run `bundle exec rake test:scm:setup:all` and a targeted Redmine test suite (`bundle exec rake test TEST=plugins/your_plugin_test.rb`) to verify plugin compatibility.
- Record any manual verification steps in PR descriptions when automated coverage is not feasible.

## Commit & Pull Request Guidelines
- Follow the existing `area: concise change` pattern (e.g., `Dockerfile: Update bashrc handling`); keep the first line under 72 characters.
- Each PR should describe the rationale, list commands executed (build, test), and link the corresponding Redmine issue when applicable.
- Include screenshots or logs if the change affects developer experience or container boot behavior.

## Devcontainer Usage Tips
- After cloning the target plugin, extract `dot_devcontainer.tgz` at the repository root so Codespaces picks up the configuration automatically.
- Use the generated `.vscode/launch.json` inside the container to attach debuggers to the Rails server during plugin development.
