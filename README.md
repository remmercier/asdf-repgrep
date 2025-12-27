<div align="center">

# asdf-repgrep [![Build](https://github.com/remmercier/asdf-repgrep/actions/workflows/build.yml/badge.svg)](https://github.com/remmercier/asdf-repgrep/actions/workflows/build.yml) [![Lint](https://github.com/remmercier/asdf-repgrep/actions/workflows/lint.yml/badge.svg)](https://github.com/remmercier/asdf-repgrep/actions/workflows/lint.yml)

[repgrep](https://github.com/acheronfail/repgrep) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, `git` and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add repgrep
# or
asdf plugin add repgrep https://github.com/remmercier/asdf-repgrep.git
```

repgrep:

```shell
# Show all installable versions
asdf list-all repgrep

# Install specific version
asdf install repgrep latest

# Set a version globally (on your ~/.tool-versions file)
asdf global repgrep latest

# Now repgrep commands are available
rgr --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/remmercier/asdf-repgrep/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Rémi Mercier](https://github.com/remmercier/)
