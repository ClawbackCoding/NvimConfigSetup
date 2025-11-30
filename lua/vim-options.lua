vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.keymap.set("i", "jj", "<Esc>", { noremap = true})
vim.opt.relativenumber = true

vim.keymap.set("n", "<leader>cr", ":!cargo run<CR>")
vim.keymap.set("n", "<leader>cb", ":!cargo build<CR>")
vim.keymap.set("n", "<leader>cc", ":!cargo check<CR>")
vim.keymap.set("n", "<leader>cf", ":!cargo fmt<CR>")
vim.keymap.set("n", "<leader>tr", ":!cargo tree<CR>")
vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ct", ":!cargo test<CR>", { noremap = true, silent = true })
vim.keymap.set('v', 'gc', function()
  local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'x', false)
  require('Comment.api').toggle.linewise(vim.fn.visualmode())
end, { noremap = true, silent = true })

vim.keymap.set("n", "yy", '"+yy', { noremap = true, silent = true })
vim.keymap.set("v", "y", '"+y', { noremap = true, silent = true })

-- In ~/.config/nvim/lua/vim_options.lua

-- Add Python to Neovim's PATH (use forward slashes for Lua)
vim.env.PATH = vim.env.PATH .. ";C:/Users/Pxrse/AppData/Local/Microsoft/WindowsApps"

-- Optionally, set Python provider explicitly
vim.g.python3_host_prog = "C:/Users/Pxrse/AppData/Local/Microsoft/WindowsApps/python3.exe"

-- Define on_attach for LSP keymaps
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
end

-- LazyVim plugin spec for LSP
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Rust: rust-analyzer
        rust_analyzer = {
          on_attach = on_attach,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
            },
          },
        },
        -- Python: pylsp
        pylsp = {
          on_attach = on_attach,
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = { enabled = true },
                jedi_completion = { enabled = true },
              },
            },
          },
        },
      },
    },
  },
}
