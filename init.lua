-- map leader key to space
local map = vim.api.nvim_set_keymap
map('n', '<Space>', '', {})
vim.g.mapleader = ' '

-- order matters
vim.cmd [[
  runtime! lua/modules/options.lua
  runtime! lua/modules/util.lua
  runtime! lua/modules/mappings.lua
]]

require("bootstrap")
require("deps")

-- enable filetype.lua
vim.g.do_filetype_lua = 1

-- open file at last position
vim.cmd [[
augroup NewBuffer
  autocmd!
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "norm g`\"" |
      \ endif
augroup END
]]
