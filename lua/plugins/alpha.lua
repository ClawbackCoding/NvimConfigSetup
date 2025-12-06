return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Header
    dashboard.section.header.val = {
      [[                                                                       ]],
      [[██     ██ ███████ ██       ██████  ██████  ███    ███ ███████     ████████]],
      [[██     ██ ██      ██      ██      ██    ██ ████  ████ ██             ██   ]],
      [[██  █  ██ █████   ██      ██      ██    ██ ██ ████ ██ █████          ██   ]],
      [[██ ███ ██ ██      ██      ██      ██    ██ ██  ██  ██ ██             ██   ]],
      [[ ███ ███  ███████ ███████  ██████  ██████  ██      ██ ███████        ██   ]],
      [[                                                                       ]],
    }

    -- Function that sets the highlight groups
    local function set_alpha_highlights()
      vim.api.nvim_set_hl(0, "AlphaGradient1", { fg = "#5e99f5" })
      vim.api.nvim_set_hl(0, "AlphaGradient2", { fg = "#8e7ae3" })
      vim.api.nvim_set_hl(0, "AlphaGradient3", { fg = "#be5bd1" })
      vim.api.nvim_set_hl(0, "AlphaGradient4", { fg = "#ee3cbf" })
    end

    -- Apply highlights on startup and whenever colorscheme changes
    set_alpha_highlights()
    vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
      callback = set_alpha_highlights,
    })

    dashboard.section.header.opts.hl = {
      { { "AlphaGradient1", 0, -1 } },
      { { "AlphaGradient1", 0, -1 } },
      { { "AlphaGradient2", 0, -1 } },
      { { "AlphaGradient2", 0, -1 } },
      { { "AlphaGradient3", 0, -1 } },
      { { "AlphaGradient3", 0, -1 } },
      { { "AlphaGradient4", 0, -1 } },
    }

    -- Recent files (unchanged)
    local function get_recent_files()
      local start = 1
      local amount = 5
      local tbl = {}
      local oldfiles = vim.v.oldfiles

      for _, file in pairs(oldfiles) do
        local file_info = vim.loop.fs_stat(file)
        if file_info then
          local short_name = vim.fn.fnamemodify(file, ":~:.")
          local shortcut = tostring(start - 1)

          local btn = dashboard.button(shortcut, " " .. short_name, ":e " .. file .. "<CR>")
          btn.opts.hl = "Comment"
          btn.opts.hl_shortcut = "Number"

          table.insert(tbl, btn)
          start = start + 1
          if start > amount then
            break
          end
        end
      end

      if #tbl == 0 then
        return {
          type = "text",
          val = "(No recent files found - Open some files!)",
          opts = { hl = "Comment", position = "center" },
        }
      end

      return {
        type = "group",
        val = tbl,
        opts = { spacing = 1 },
      }
    end

    -- Buttons
    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
      dashboard.button("n", "  New File", ":ene <BAR> startinsert <CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }

    -- Layout
    dashboard.config.layout = {
      { type = "padding", val = 4 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      { type = "text", val = "Recent Files", opts = { hl = "SpecialComment", position = "center" } },
      { type = "padding", val = 1 },
      get_recent_files(),
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    -- Open Neo tree when Alpha is ready without sending keys
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function()
        vim.defer_fn(function()
          local ok, cmd = pcall(require, "neo-tree.command")
          if ok then
            cmd.execute({
              source = "filesystem",
              position = "left",
              reveal = true,
            })
          else
            -- Fallback command in case require fails
            vim.cmd("Neotree filesystem reveal left")
          end
        end, 80)
      end,
    })

    alpha.setup(dashboard.config)
  end,
}

