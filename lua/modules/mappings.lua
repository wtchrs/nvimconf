local u = require "modules.util"
local noremap = u.noremap
local nnoremap = u.nnoremap
local inoremap = u.inoremap
local tnoremap = u.tnoremap
local vnoremap = u.vnoremap

nnoremap("<Leader>n", "<CMD>Neotree<CR>", { desc = "Show NeoTree"})

-- Better movement between windows
nnoremap("<C-h>", "<C-w><C-h>", { desc = "Go to the left window" })
nnoremap("<C-l>", "<C-w><C-l>", { desc = "Go to the right window" })
nnoremap("<C-j>", "<C-w><C-j>", { desc = "Go to the bottom window" })
nnoremap("<C-k>", "<C-w><C-k>", { desc = "Go to the top window" })

-- -- Resize buffer easier
-- nnoremap("<Left>", ":vertical resize +2<CR>", {
--   desc = "Resize buffer to the left",
-- })
-- nnoremap("<Right>", ":vertical resize -2<CR>", {
--   desc = "Resize buffer to the right",
-- })
-- nnoremap("<Up>", ":resize +2<CR>", {
--   desc = "Resize buffer to the top",
-- })
-- nnoremap("<Down>", ":resize -2<CR>", {
--   desc = "Resize buffer to the bottom",
-- })

-- Buffer movements
noremap("<A-h>", "<CMD>bp<CR>", { desc = "Go to previous buffer" })
noremap("<A-l>", "<CMD>bn<CR>", { desc = "Go to next buffer" })

nnoremap("j", "gj", {
  desc = "Move down by visual line on wrapped lines",
})
nnoremap("k", "gk", {
  desc = "Move up by visual line on wrapped lines",
})

nnoremap("Q", "<Nop>", { desc = "Remove annoying exmode" })
nnoremap("q:", "<Nop>", { desc = "Remove annoying exmode" })

vnoremap("<A-y>", '"+y', {
  desc = "Yank selection to clipboard",
})

-- inoremap("<C-W>", "<C-S-W>", {
--   desc = "Delete word backwards (this is needed for telescope prompt)",
-- })
inoremap("<C-BS>", "<C-w>", { desc = "Ctrl-Backspace to erase a word" })

vnoremap("<", "<gv", { desc = "Dedent current selection" })
vnoremap(">", ">gv", { desc = "Indent current selection" })

nnoremap("<Leader>v", function()
    vim.cmd [[
      vnew
      setlocal buftype=nofile bufhidden=hide
    ]]
  end,
  { desc = "Open scratch buffer", }
)

nnoremap("<F2>", function()
    vim.cmd [[
      let g:strip_whitespace = !g:strip_whitespace
      echo "Strip whitespace mode is now " . (g:strip_whitespace ? "on" : "off")
    ]]
  end,
  { desc = "Toggle whitespace stripping", }
)
