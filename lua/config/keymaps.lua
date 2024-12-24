-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opt = { noremap = true, silent = true }

-- Key:         <leader>;
-- Action:      Enter command mode.
keymap.set("n", "<leader>;", ":", opt)

-- Key:         Ctrl-e
-- Action:      Show treesitter capture group for textobject under cursor.
keymap.set("n", "<C-e>", function()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end, { noremap = true, silent = false })
