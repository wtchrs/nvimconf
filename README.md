# Neovim Configuration with [💤 LazyVim][lazyvim]

This configuration is based on the [LazyVim starter template][lazyvim-starter].
See the [documentation][lazyvim-doc] for details.

## Why [LazyVim][lazyvim]?

Previously, I managed plugins and their configurations manually.
However, dealing with breaking changes in some plugins was often tiring.
So, I decided to use [LazyVim][lazyvim], a well-maintained, pre-configured Neovim setup.

## Getting Started

Clone this repository into your Neovim configuration directory and start Neovim.
The required plugins will be installed automatically.

```bash
git clone https://github.com/wtchrs/nvimconf ~/.config/nvim
nvim
```

## LSP servers, formatters, and linters

> [!NOTE]
> Since `mason.nvim` is disabled, LSP servers, formatters, and linters must be installed manually.
> Alternatively, you can re-enable `mason.nvim` to manage them automatically.
> You can check what's missing with `:LspInfo`, `:ConformInfo`, and `:LintInfoAll`.

## Troubleshooting

If you get a Tree-sitter error such as `Invalid node type "tab"` when pressing `:`, follow the steps below:

- Install [tree-sitter-cli][tree-sitter-cli]
- Run `:TSUninstall vim`
- Restart Neovim

Source: [Reddit](https://www.reddit.com/r/neovim/comments/1psyhxj/neovim_treesitter_error_invalid_node_type_when/)


[lazyvim]: https://github.com/LazyVim/LazyVim
[lazyvim-starter]: https://github.com/LazyVim/starter
[lazyvim-doc]: https://lazyvim.github.io/installation
[tree-sitter-cli]: https://www.npmjs.com/package/tree-sitter-cli
