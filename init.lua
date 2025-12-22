-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- -- DEBUG: Check if plugins directory exists
-- local plugins_path = vim.fn.stdpath("config") .. "/lua/plugins"
-- print("Plugins path: " .. plugins_path)
-- print("Plugins directory exists: " .. tostring(vim.fn.isdirectory(plugins_path) == 1))
--
-- -- DEBUG: List files in plugins directory
-- local files = vim.fn.glob(plugins_path .. "/*.lua", false, true)
-- print("Plugin files found:")
-- for _, file in ipairs(files) do
--   print("  " .. file)
-- end
--
-- Load plugins from lua/plugins/
require("lazy").setup({
  spec = { import = "plugins" },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
})

-- Load vim options
require("vim-options")

-- Setup ToggleTerm (if not already)
require("toggleterm").setup {
  direction = "vertical",   -- or "float", "vertical"
  size = 15,
  open_mapping = [[<c-\>]], -- default keybinding to open terminal
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
}
vim.api.nvim_create_user_command("Restart", function()
  vim.cmd("wa") -- Save all buffers
  -- Detect OS and use appropriate restart method
  if vim.fn.has("win32") == 1 then
    vim.cmd("!start /B cmd /C \"nvim && exit\" & exit")
  else
    vim.cmd("!exec nvim")
  end
end, { desc = "Restart Neovim in same terminal" })

vim.g.copilot_enabled = true 

-- split windows
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>sh", "<cmd>split<cr>",  { desc = "Horizontal split" })

-- optional: quickly close the current split
vim.keymap.set("n", "<leader>sq", "<cmd>close<cr>", { desc = "Close split" })

-- optional: equalize split sizes
vim.keymap.set("n", "<leader>se", "<cmd>wincmd =<cr>", { desc = "Equalize splits" })

-- Rotate splits
vim.keymap.set("n", "<leader>sr", "<cmd>wincmd r<cr>", { desc = "Rotate splits" })

-- Neotree file explorer
vim.keymap.set("n", "<C-w>", "<cmd>Neotree focus<cr>", { desc = "Focus file tree" })

-- Move between coding windows with Ctrl-h/j/k/l
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })
