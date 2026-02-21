# Neovim Configuration with [💤 LazyVim][lazyvim]

I customized the [starter template][lazyvim-starter] of [LazyVim][lazyvim].
Refer to the [documentation][lazyvim-doc] to learn more.

## Why [LazyVim][lazyvim]

Previously, I had managed packages and their configurations manually.
However, handling breaking changes in some packages was often a tiring task.
So, I decided to use [LazyVim][lazyvim], a well-maintained and pre-configured Neovim setup.

## Get Started

Clone this repository into your Neovim configuration directory, then launch Neovim.
The required packages will be downloaded automatically.

```bash
git clone https://github.com/wtchrs/nvimconf ~/.config/nvim
nvim
```

## LSP servers, formatters, and linters

I disabled `mason.nvim`, so you'll need to install LSP servers, formatters, and linters manually. Alternatively, you can re-enable `mason.nvim` to manage them automatically.
You can check what's missing with `:LspInfo`, `:ConformInfo`, and `:LintInfoAll`.

[lazyvim]: https://github.com/LazyVim/LazyVim
[lazyvim-starter]: https://github.com/LazyVim/starter
[lazyvim-doc]: https://lazyvim.github.io/installation
