local bufferline = require("bufferline")

return {
  {
    "akinsho/bufferline.nvim",

    init = function()
      -- Set the Neovim option to always show the tabline by default (value 2)
      vim.opt.showtabline = 0

      -- Use an autocmd to hide the tabline when there is only 1 buffer
      -- and show it otherwise.
      vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufDelete", "TabEnter", "WinEnter" }, {
        group = vim.api.nvim_create_augroup("BufferLineAutoToggle", { clear = true }),
        callback = function()
          -- Count the number of non-listed and valid buffers
          local buffer_count = 0
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
              buffer_count = buffer_count + 1
            end
          end

          -- Toggle the tabline visibility
          if buffer_count < 1 then
            vim.opt.showtabline = 0
          else
            vim.opt.showtabline = 2
          end
        end,
      })
    end,

    opts = {
      options = {
        -- Disable all offsets in bufferline.nvim
        offsets = {},
        always_show_bufferline = true,
        style_preset = {
          bufferline.style_preset.no_italic,
          bufferline.style_preset.minimal,
        },
        separator_style = { "", "" },
        hover = {
          enabled = true,
          delay = 20,
          reveal = { "close" },
        },
      },
    },
  },
}
