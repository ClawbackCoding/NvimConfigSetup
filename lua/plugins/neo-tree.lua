return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  config = function()
    vim.keymap.set("n", "<leader>es", "<cmd>Neotree filesystem toggle left<cr>", { desc = "Toggle Neo-tree" })
    vim.keymap.set("n", "<leader>e", "<cmd>Neotree focus<cr>", { desc = "Focus Neo-tree" })

    vim.keymap.set("n", "<leader>r", function()
      vim.cmd("Neotree reveal")
      vim.cmd("wincmd p")
    end, { desc = "Reveal in Neo-tree" })

    require("neo-tree").setup({
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
      },
    })
  end,
}

