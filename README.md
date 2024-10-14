# Laptop initialization script

The main goal of this project is to help developers to focus on delivering value instead of struggling with the workstation configuration.

The solution provided is a *one-liner* script that will fully configure a workstation for mobile and web development.

Its core values are :

- 🤖 Automated : provide all *required* tools with almost no manual action
- ✅ Safe : multiple runs should always work
- 🧑‍🏫 Opiniated yet Customizable : some configurations might not suit everybody, but for most people it will provide a great working experience. When possible, provide a simple way to customize/override setup

## Launch installation

1. Open a terminal ( [How to](https://www.wikihow.com/Open-a-Terminal-Window-in-Mac) )

2. Run the installation command :

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jpolo/laptop/main/install.sh)"
```

## Features

Platform supported :

- ✅ macOS
- ✅ Debian like distros (Ubuntu, Debian)
  - devcontainers (i.e. Docker) supported

Package Manager :

- [Homebrew] (macOS)

Shell :

- [ZSH] default shell
- [ZDharmaContinuum/zinit] default zsh plugin manager
- [PowerLevel10k] default zsh theme (customizable)
- [SSH] default algorithm `ed25519` [(explanation)](https://docs.gitlab.com/ee/user/ssh.html#ed25519-ssh-keys)

Source Control Manager :

- [Git] default version control
- [GitHub CLI] for interacting with the GitHub API

Programming language :

- [asdf-vm] multi-language version manager (replaces nvm, rbenv, etc)
  - ✅ Plugin Ruby
  - ✅ Plugin NodeJS (+ `npm`, `yarn`)
  - ✅ Plugin Java
  - ✅ Plugin Python
  - ✅ Plugin Terraform
  - ✅ Plugin Cocoapods

Code Editor :

- [Visual Studio Code] default visual editor
- `nano` default text based editor

Misc :

- [Watchman] for watching for filesystem events
- `~/Code` folder to clone all repositories / organize projects
- `~/Captures` folder to manage screen shots and screen captures

## Configuration

### ZSH Recipes

<details>
  <summary>🔧 Override/Customize ZSH configuration</summary>

  ⚠️ You should never modify `.zshrc` because any changes will be lost when `laptop` script is run.

  Here is the order of profile loading :
    - 🔒 `$XDG_DATA_HOME/zsh/global.{sh,zsh}` : default settings (always overwritten by `laptop`)
    - 🔒 `$XDG_DATA_HOME/zsh/organization.{sh,zsh}` : organization settings (always overwritten by `laptop`)
    - ✍️ `$XDG_DATA_HOME/zsh/personal.{sh,zsh}` : custom personal settings
    - ✍️ `.zshrc.local` : For local override (that should not be synched between devices)

  Instead, configuration can be overridden in the following files () :
    - `.zshrc.local` : For local override (that should not be synched between devices)
    - `$XDG_DATA_HOME/zsh/*.sh` : For generic overrides (zsh plugins, etc). Files are included in alphabetic order, so as a convention each file starts with two digits.

  Example `$XDG_DATA_HOME/zsh/20_personal.sh` :

  ```shell
  # Load OhMyZSH ruby plugin
  zinit snippet OMZP::ruby
  # Load OhMyZSH rails plugin
  zinit snippet OMZP::rails

  ```

</details>
<details>
  <summary>🎨 Customize ZSH Theme</summary>

  ```console
  > p10k configure
  ```

</details>


## `laptop` CLI

The laptop ZSH plugin provides a `laptop` executable. This executable was created to make easier the maintenance of your laptop.

Laptop CLI has 3 subcommands `configure`, `upgrade` and `cleanup`

More information is available with the command `laptop help`.

### `laptop configure`

Try to install all software from the current profile (that was configured at first installation).

### `laptop upgrade`

Detect many tools (`brew`, `asdf`, etc) and launch their respective update command.

This will also update the laptop plugin and executable itself.

Launch this command regularly to be up to date and avoir keeping old software with potential security vulnerabilities.

### `laptop cleanup`

Detect many tools (`brew`, `asdf`, etc) and try to free disk space (in a "safe" manner) :

- Remove cache
- Prune unused data

NPM, docker, mobile development can be quite greedy on disk space. Launch this command regularly to avoid to be out of free disk space.

[asdf-vm]: https://github.com/asdf-vm/asdf
[Git]: https://git-scm.com/
[GitHub CLI]: https://cli.github.com/
[Homebrew]: http://brew.sh/
[PowerLevel10k]: https://github.com/romkatv/powerlevel10k
[SSH]: https://en.wikipedia.org/wiki/Secure_Shell
[Visual Studio Code]: https://code.visualstudio.com/
[Watchman]: https://facebook.github.io/watchman/
[ZDharmaContinuum/zinit]: https://zdharma-continuum.github.io/
[ZSH]: http://www.zsh.org/
