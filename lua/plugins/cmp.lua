return {
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim",
    },
    opts = function()
      local cmp = require("cmp")
      local types = require("cmp.types")
      local str = require("cmp.utils.str")
      local lspkind = require("lspkind")

      return {
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        formatting = {
          fields = {
            cmp.ItemField.Kind,
            cmp.ItemField.Abbr,
            cmp.ItemField.Menu,
          },
          format = lspkind.cmp_format({
            with_text = false,
            before = function(entry, vim_item)
              -- Get the full snippet (and only keep first line)
              local word = entry:get_insert_text()
              if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
                word = vim.lsp.util.parse_snippet(word)
              end
              word = str.oneline(word)

              if
                entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
                and string.sub(vim_item.abbr, -1, -1) == "~"
              then
                word = word .. "~"
              end
              vim_item.abbr = word

              return vim_item
            end,
          }),
        },
        window = {
          completion = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, scrollbar = "║" },
          documentation = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, scrollbar = "║" },
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = "vsnip" },
          { name = "path" },
          { name = "buffer", keyword_length = 8 },
        },
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item { cmp.SelectBehavior.Select },
          ["<C-n>"] = cmp.mapping.select_next_item { cmp.SelectBehavior.Select },
          ["<S-Tab>"] = cmp.mapping.select_prev_item { cmp.SelectBehavior.Select },
          ["<C-p>"] = cmp.mapping.select_prev_item { cmp.SelectBehavior.Select },
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
        },
      }
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
      vim.cmd [[hi Pmenu guibg=None]]
    end,
  }
}
