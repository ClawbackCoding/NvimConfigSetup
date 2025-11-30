return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false, -- loads during startup
  build = ":TSUpdate", -- runs after install/update
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true, -- automatically install missing parsers
      highlight = { enable = true },
      indent = { enable = true },
      -- optionally, add autopairs, autotag, etc. if you use them
    })
  end,
}
