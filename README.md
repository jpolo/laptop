# Laptop initialization script

Laptop is a *one-liner* script that will configure a workstation for mobile and web development.

Its core values are :

- Automated : provide all *required* tools with almost no manual action
- Safe : multiple runs should always work
- Opiniated yet Customizable : some configurations might not suit everybody, but for most people it will provide a great working experience. When possible, provide a simple way to customize/override setup

## Launch installation

1. Open a terminal ( [How to](https://www.wikihow.com/Open-a-Terminal-Window-in-Mac) )

2. Run the installation command :

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jpolo/laptop/main/install.sh)"
```

## Features

Platform supported :

- ✅ macOS
- ✅ Debian like distros (Ubuntu, Debian) ⚠️ never tested but should be officially supported

Package Manager :

- [Homebrew] (macOS)

Shell :

- [ZSH] default shell
- [Zinit] default zsh plugin manager

Source Control Manager :

- [Git] default version control
- [GitHub CLI] for interacting with the GitHub API

Programming language :

- [asdf-vm] multi-language version manager (replaces nvm, rbenv, etc)
  - ✅ Plugin Ruby
  - ✅ Plugin NodeJS (+ `npm`, `yarn`)
  - ✅ Plugin Java
  - ✅ Plugin Python

Code Editor :

- [Visual Studio Code] default visual editor
- `nano` default text based editor

Misc :

- [Watchman] for watching for filesystem events

## Configuration

### ZSH Recipes

<details>
  <summary>➕ Add a <code>zsh</code> plugin using <code>zinit</code></summary>

  Edit the shell script `$XDG_DATA_HOME/zsh/01_custom.sh` (or create a new one in `$XDG_DATA_HOME/zsh`)

  Example :

  ```shell
  # Load OhMyZSH ruby plugin
  zinit snippet OMZP::ruby
  # Load OhMyZSH rails plugin
  zinit snippet OMZP::rails

  ```

</details>
<details>
  <summary>🔄 Update all plugins</summary>

  ```console
  > zinit update
  ```

</details>
<details>
  <summary>🧹 Clean unused plugins</summary>

  ```console
  > zinit delete --clean
  ```

</details>

[Git]: https://git-scm.com/
[GitHub CLI]: https://cli.github.com/
[Homebrew]: http://brew.sh/
[asdf-vm]: https://github.com/asdf-vm/asdf
[Watchman]: https://facebook.github.io/watchman/
[Visual Studio Code]: https://code.visualstudio.com/
[Zinit]: https://github.com/zdharma-continuum/zinit
[ZSH]: http://www.zsh.org/
