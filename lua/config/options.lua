-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set Powershell as default terminal if OS is Windows
WINDOWS = "Windows_NT"
if string.sub(vim.loop.os_uname().sysname, 1, string.len(WINDOWS)) == WINDOWS then
  vim.o.shell = "pwsh.exe"
end

-- Set markdown rendering disable
vim.opt.conceallevel = 0

-- Set indent size
vim.opt.shiftwidth = 4
