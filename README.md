# redmine_devcontainer

 This is a tool that builds a development environment for Redmine plugins using Github Codespaces or Visual Studio Code.

 ## How to setup

 ### If you already have your plugin code

Download latest `dot_devcontainer.tgz` from https://github.com/haru/redmine_devcontainer/releases .

```shell
$ cd root_directory_of_you_plugin
$ tar xvfz dot_devcontainer.tgz
```

Then, you can find a directory `.devcontainer` in your plugin directory.
Commit and push to Github and open Github Codespaces.

### If don't have your plugin yet

Create new Github repository and open Github Codespaces.

Download latest `dot_devcontainer.tgz` from https://github.com/haru/redmine_devcontainer/releases .

```shell
$ cd root_directory_of_you_plugin
$ tar xvfz dot_devcontainer.tgz
```

Click `Full Rebuild Container`. 
Then Open terminal and execute command below.

```shell
$ sh .devcontainer/plugin_generator.sh 
```

