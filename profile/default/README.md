# Default profile configuration

Shell :

- [ZSH] default shell
- [zimfw] default zsh plugin manager
- [Starship] Cross-shell prompt
- [SSH] default algorithm `ed25519` [(explanation)](https://docs.gitlab.com/ee/user/ssh.html#ed25519-ssh-keys)

Source Control Manager :

- [Git] default version control
- [GitHub CLI] for interacting with the GitHub API

Programming language :

- [mise] multi-language version manager (replaces nvm, rbenv, etc)
  - Uses the profile's `.tool-versions` for Ruby, Node.js, Java, and Python
- Existing asdf installations retain the recommended asdf plugin setup and `.tool-versions` support

Code Editor :

- [Visual Studio Code] default visual editor
- `nano` default text based editor

Misc :

- [Watchman] for watching for filesystem events
- `~/Code` folder to clone all repositories / organize projects
- `~/Captures` folder to manage screen shots and screen captures

[mise]: https://mise.jdx.dev/
[Git]: https://git-scm.com/
[GitHub CLI]: https://cli.github.com/
[Starship]: https://starship.rs
[SSH]: https://en.wikipedia.org/wiki/Secure_Shell
[Visual Studio Code]: https://code.visualstudio.com/
[Watchman]: https://facebook.github.io/watchman/
[zimfw]: https://zimfw.sh/
[ZSH]: http://www.zsh.org/
