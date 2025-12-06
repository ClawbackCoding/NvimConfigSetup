return {
  {
    "tinted-theming/tinted-vim",
    lazy = false,
    priority = 1000,
    config = function()
      -- pick any base16 scheme from the plugin
      -- you can list them later with :Telescope colorscheme or :colorscheme <Tab>
      vim.cmd.colorscheme("base16-gruvbox-dark-pale")
    end,
  },
}

