# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

asdf plugin test repgrep https://github.com/remmercier/asdf-repgrep.git "rgr --help"
```

Tests are automatically run in GitHub Actions on push and PR.
