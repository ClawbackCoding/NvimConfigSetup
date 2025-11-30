return {
  "stevearc/conform.nvim",
  opts = {
    config = function() 
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          markdown = { "prettier" },
        },
        format_on_save = {
          lsp_fallback = true,
          timeout_ms = 500,
        },
      })
    end,
  }, 

  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  }
}
