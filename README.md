# redmine_devcontainer

A tool that builds a development environment for Redmine plugins using GitHub Codespaces or Visual Studio Code Dev Containers.

## Supported versions

| Redmine | Ruby | Docker image tag |
|---------|------|-----------------|
| 6.1-stable | 3.2 | `haru/redmine_devcontainer:6.1-stable-ruby3.2` |
| 6.1-stable | 3.3 | `haru/redmine_devcontainer:6.1-stable-ruby3.3` |
| 6.1-stable | 3.4 | `haru/redmine_devcontainer:6.1-stable-ruby3.4` |
| 6.0-stable | 3.1 | `haru/redmine_devcontainer:6.0-stable-ruby3.1` |
| 6.0-stable | 3.2 | `haru/redmine_devcontainer:6.0-stable-ruby3.2` |
| 6.0-stable | 3.3 | `haru/redmine_devcontainer:6.0-stable-ruby3.3` |
| 5.1-stable | 3.0 | `haru/redmine_devcontainer:5.1-stable-ruby3.0` |
| 5.1-stable | 3.1 | `haru/redmine_devcontainer:5.1-stable-ruby3.1` |
| 5.1-stable | 3.2 | `haru/redmine_devcontainer:5.1-stable-ruby3.2` |
| master | 3.2 | `haru/redmine_devcontainer:master-ruby3.2` |
| master | 3.3 | `haru/redmine_devcontainer:master-ruby3.3` |
| master | 3.4 | `haru/redmine_devcontainer:master-ruby3.4` |

All images are multi-arch (amd64 + arm64) and are built and pushed to DockerHub automatically via GitHub Actions.

## How to setup

### If you already have your plugin code

Download the latest `dot_devcontainer.tgz` from https://github.com/haru/redmine_devcontainer/releases .

```shell
$ cd root_directory_of_your_plugin
$ tar xvfz dot_devcontainer.tgz
```

A `.devcontainer` directory will be created in your plugin directory.

#### Select the Redmine version

Edit `.devcontainer/docker-compose.yml` and set `REDMINE_VERSION` and `RUBY_VERSION` to match your target environment:

```yaml
args:
  RUBY_VERSION: "3.2"
  REDMINE_VERSION: "6.1-stable"
```

Commit and push to GitHub, then open GitHub Codespaces (or reopen in VS Code Dev Container).

### If you don't have your plugin yet

1. Create a new GitHub repository and open GitHub Codespaces.
2. Download the latest `dot_devcontainer.tgz` from https://github.com/haru/redmine_devcontainer/releases .

```shell
$ cd root_directory_of_your_plugin
$ tar xvfz dot_devcontainer.tgz
```

3. Click `Full Rebuild Container`.
4. Open a terminal and run:

```shell
$ sh .devcontainer/plugin_generator.sh
```
