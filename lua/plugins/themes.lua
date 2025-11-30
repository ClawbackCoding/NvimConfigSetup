return {
  -- Catppuccin (default)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
  },

  -- Tokyonight
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
  },

  -- Everforest
  {
    "sainnhe/everforest",
    name = "everforest",
  },

  -- OneDark (OneDarkPro)
  {
    "olimorris/onedarkpro.nvim",
    name = "onedark",
  },
}

