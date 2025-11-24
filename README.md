# 💻 Laptop initialization script

The main goal of this project is to help developers to focus on delivering value instead of struggling with the workstation configuration.

The solution provided is a composed of :

- *one-liner* installer script that will fully configure a workstation for mobile and web development.
- a cli tool named "laptop" to help workstation maintenance event after the script was installed
- an extended bash function collection to be able to create other configuration profile than the one on this repository

Its core values are :

- 🤖 Automated : provide all *required* tools with almost no manual action
- ✅ Safe : multiple runs should always work
- 🧑‍🏫 Opinionated yet Customizable : some configurations might not suit everybody, but for most people it will provide a great working experience. When possible, provide a simple way to customize/override setup

## 🚀 Launch installation

Available profiles :

- [default](./profile/default/README.md)

1. Open a terminal ( [How to](https://www.wikihow.com/Open-a-Terminal-Window-in-Mac) )

2. Install `laptop` executable and custom `.zshrc` :

    ```shell
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jpolo/laptop/main/install.sh)"
    ```

3. Install all programs :

    ```shell
    laptop setup
    ```

## ✨ Features

### ✅ Portable (`bash` is required)

Platform supported :

- ✓ macOS
- ✓ Debian like distros (Ubuntu, Debian)
  - devcontainers (i.e. Docker) supported

Package Manager supported :

- [Homebrew] (macOS)
- [apt-get](https://help.ubuntu.com/community/AptGet/Howto) (Debian like distros)

### ✅ `laptop` command line tool included to maintain your laptop

The laptop ZSH plugin provides a `laptop` executable. This executable was created to make easier the maintenance of your laptop by providing a simple way to :

- update all tools and dependencies, to avoid security issues and benefit from latest bug fixes
- remove all unneeded files and free disk space
- auto-update itself. laptop can be updated itself to benefit to the latest tools / configuration of the organization

### ✅ Customize your laptop tool for your organization

- Built to be easily forked (better for security, so everyone can review the code)
- Many bash functions for your needs in [`./src/functions`](./src/functions)
- Multiple configuration profile is possible

### ✅ Customizable for your needs

`laptop` aims to give a common full feature basis for each laptop machine.

Although there are some implementation tradeoffs, it should never limit developers to customize their workstation.

## 🔧 Configuration

### Shell customization

<details>
  <summary>🔧 Override/Customize ZSH configuration</summary>

  ⚠️ You should never modify `.zshrc` because any changes will be lost when `laptop` script is run.

  Here is the order of profile loading :
    - 🔒 `$XDG_DATA_HOME/zsh/global.{sh,zsh}` : default settings (always overwritten by `laptop`)
    - ✍️ `$XDG_DATA_HOME/zsh/personal.{sh,zsh}` : custom personal settings
    - ✍️ `.zshrc.local` : For local override (that should not be synched between devices)

  Instead, configuration can be overridden in the following files () :
    - `.zshrc.local` : For local override (that should not be synched between devices)
    - `$XDG_DATA_HOME/zsh/*.sh` : For generic overrides (zsh plugins, etc). Files are included in alphabetic order, so as a convention each file starts with two digits.

  Example `$XDG_DATA_HOME/zsh/personal.sh` :

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
  > code $STARSHIP_CONFIG
  ```

</details>

### Fork this repository

1. Fork this repository
2. Copy `profile/default/profile.sh` to `profile/{{my-company-profile}}/profile.sh`
3. Customize `profile/{{my-company-profile}}` (Avoid changing `profile/default`)
    1. Modify `profile/{{my-company-profile}}/profile.sh` to fit your needs
    2. Put any resources / template in this folder
4. Customize the installer script `install.sh`
5. Update the `README.md` installation instructions

## 💡 The `laptop` CLI

Laptop CLI has 3 subcommands `setup`, `upgrade` and `cleanup`

More information is available with the command `laptop help`.

### `laptop setup`

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

## ⭐️ Contributing

Original repository is hosted at [https://github.com/jpolo](https://github.com/jpolo)

Contributions are welcome especially when :

- adding documentation to the laptop shell library `./src/functions`
- adding new capabilities / support for the tool
- reporting / fixing security issues

## 🩷 Funding

If you like this repository and it made you win a lot of time / money (by not hiring a devops for example :) ), you may consider a small donation to help me maintaining this repository [Link to my profile](https://github.com/jpolo#-donate).

[Homebrew]: http://brew.sh/
