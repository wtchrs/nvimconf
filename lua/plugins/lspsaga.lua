return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter"  --Please make sure you install markdown and markdown_inline parser
    },
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
    },
    config = function(_, opts)
      require("lspsaga").setup(opts)

      vim.cmd [[
        " lsp provider to find the cursor word definition and reference
        nnoremap <silent> gh <cmd>Lspsaga lsp_finder<CR>
        " code action
        nnoremap <silent> <leader>ca <cmd>Lspsaga code_action<CR>
        vnoremap <silent> <leader>ca <cmd><C-U>Lspsaga range_code_action<CR>
        " show hover doc
        nnoremap <silent> K <cmd>Lspsaga hover_doc<CR>
        " scroll hover doc or scroll in definition preview
        nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
        nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
        " rename symbol
        nnoremap <silent> <leader>rn <cmd>Lspsaga rename<CR>
        " preview definition
        nnoremap <silent> gd <cmd>Lspsaga preview_definition<CR>
        " show signature help
        nnoremap <silent> gs <cmd>Lspsaga signature_help<CR>
        " jump diagnostics
        nnoremap <silent> [g <cmd>Lspsaga diagnostic_jump_prev<CR>
        nnoremap <silent> ]g <cmd>Lspsaga diagnostic_jump_next<CR>
      ]]
    end,
  }
}
