# A collection of roles to setup a developer machine

## Launch installation

1. Open a terminal ( [How to](https://www.wikihow.com/Open-a-Terminal-Window-in-Mac) )

2. Run the installation command :

```shell
curl -fsSL https://raw.githubusercontent.com/jpolo/laptop/main/install.sh | bash
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

Misc :

- [Watchman] for watching for filesystem events

[Git]: https://git-scm.com/
[GitHub CLI]: https://cli.github.com/
[Homebrew]: http://brew.sh/
[asdf-vm]: https://github.com/asdf-vm/asdf
[Watchman]: https://facebook.github.io/watchman/
[Zinit]: https://github.com/zdharma-continuum/zinit
[ZSH]: http://www.zsh.org/
