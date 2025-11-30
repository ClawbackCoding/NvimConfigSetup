return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "lua_ls",
          "html",
          "cssls",
          "ts_ls",
          "rust_analyzer",
        },
      })

      -- Updated for 0.11 compatibility (get_active_clients is also deprecated)
      local function kill_global_pyright()
        -- vim.lsp.get_clients() is the modern replacement for get_active_clients()
        for _, client in ipairs(vim.lsp.get_clients()) do
          if client.name == "pyright" then
            local cmd = table.concat(client.config.cmd or {}, " ")
            -- kill the one that uses plain pyright-langserver and is not from mason
            if cmd:find("pyright%-langserver") and not cmd:lower():find("mason") then
              vim.lsp.stop_client(client.id)
            end
          end
        end
      end

      local on_attach = function(client, bufnr)
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = bufnr, silent = true, noremap = true }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        if client.name == "pyright" then
          kill_global_pyright()
        end
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local mason_pyright_cmd = {
        vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver.cmd",
        "--stdio",
      }

      -- 1. Configure Pyright (Native 0.11 Style)
      vim.lsp.config("pyright", {
        cmd = mason_pyright_cmd,
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "off",
            },
          },
        },
      })
      -- 2. Enable Pyright
      vim.lsp.enable("pyright")

      local other_servers = {
        "lua_ls",
        "html",
        "cssls",
        "ts_ls",
        "rust_analyzer",
      }

      -- Loop for other servers
      for _, server in ipairs(other_servers) do
        -- Register the config
        vim.lsp.config(server, {
          on_attach = on_attach,
          capabilities = capabilities,
        })
        -- Enable the server
        vim.lsp.enable(server)
      end
    end,
  },
}
