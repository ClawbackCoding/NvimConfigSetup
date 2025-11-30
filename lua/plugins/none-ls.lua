return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- Ruff formatter
        null_ls.builtins.formatting.ruff,
        -- Ruff linter
        null_ls.builtins.diagnostics.ruff,
      },
    })
  end,
}

