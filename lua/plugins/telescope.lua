return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },

  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")

    ----------------------------------------------------------------------
    -- 1. Theme Persistence (Load saved theme on startup)
    ----------------------------------------------------------------------
    local theme_file = vim.fn.stdpath("data") .. "/last_theme.txt"

    local ok_read, last_theme = pcall(function()
      local lines = vim.fn.readfile(theme_file)
      return lines[1]
    end)

    if ok_read and last_theme and last_theme ~= "" then
      pcall(vim.cmd, "colorscheme " .. last_theme)
    end

    ----------------------------------------------------------------------
    -- 2. DYNAMIC SELECTION HIGHLIGHTING
    ----------------------------------------------------------------------
    local theme_overrides = {
      catppuccin = { bg = "#45475a", fg = "#cdd6f4", bold = true },
      gruvbox    = { bg = "#504945", fg = "#ebdbb2", bold = true },
      tokyonight = { bg = "#3b4261", fg = "#c0caf5", bold = true },
      everforest = { bg = "#4f5b58", fg = "#d3c6aa", bold = true },
      onedark    = { bg = "#3e4452", fg = "#abb2bf", bold = true },
    }

    local function set_telescope_highlights()
      local current_theme = vim.g.colors_name or "default"
      local override = theme_overrides[current_theme]

      if override then
        vim.api.nvim_set_hl(0, "TelescopeSelection", override)
        vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", {
          fg = override.fg,
          bg = override.bg,
        })
      else
        vim.api.nvim_set_hl(0, "TelescopeSelection", { link = "Visual" })
        vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { link = "Visual" })
      end
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = set_telescope_highlights,
    })

    set_telescope_highlights()

    ----------------------------------------------------------------------
    -- 3. Telescope Setup
    ----------------------------------------------------------------------
    telescope.setup({
      defaults = {
        -- Use fd for fast file search, include hidden, ignore .gitignore so .env shows
        find_command = {
          "fd",
          "--type", "f",
          "--hidden",
          "--no-ignore",      -- <== this makes .env visible even if in .gitignore
          "--exclude", ".git",
          "--exclude", "node_modules",
          "--exclude", "venv",
          "--exclude", ".venv",
          "--exclude", "__pycache__",
        },

        mappings = {
          i = {
            ["<Tab>"]   = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
          },
          n = {
            ["<Tab>"]   = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
          },
        },

        prompt_prefix   = " ",
        selection_caret = "  ",
        entry_prefix    = "  ",

        file_ignore_patterns = {
          "^%.git[/\\]",        -- .git at project root
          "[/\\]%.git[/\\]",    -- .git in subdirs
          "[/\\]venv[/\\]",
          "[/\\]%.venv[/\\]",
          "[/\\]%%USERPROFILE%%[/\\]",
          "[/\\]__pycache__[/\\]",
          "%.pyc",
          "[/\\]node_modules[/\\]",
          "[/\\]dist[/\\]",
          "[/\\]build[/\\]",
          "%.min%.js",
          "[/\\]target[/\\]",
          "%.exe",
          "%.dll",
          "%.wav",
          "%.mp3",
          "%.mp4",
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })

    telescope.load_extension("ui-select")

    ----------------------------------------------------------------------
    -- 4. Keymaps
    ----------------------------------------------------------------------
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files (clean)" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, { desc = "Find definitions" })
    vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
    vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
    vim.keymap.set("n", "<leader>fw", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })

    ----------------------------------------------------------------------
    -- 5. Theme Switcher Logic
    ----------------------------------------------------------------------
    local possible_themes = { "catppuccin", "gruvbox", "tokyonight", "everforest", "onedark" }

    local function get_installed_themes()
      local list = {}
      local current = vim.g.colors_name
      for _, t in ipairs(possible_themes) do
        if pcall(vim.cmd, "colorscheme " .. t) then
          table.insert(list, t)
        end
      end
      if current then
        pcall(vim.cmd, "colorscheme " .. current)
      end
      return list
    end

    local function pick_theme()
      local themes = get_installed_themes()
      local original = vim.g.colors_name
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local action_state = require("telescope.actions.state")

      pickers.new({}, {
        prompt_title = "Choose Theme (Live Preview)",
        finder = finders.new_table(themes),
        sorter = conf.generic_sorter({}),
        initial_mode = "insert",
        attach_mappings = function(prompt_bufnr, map)
          local function preview()
            local sel = action_state.get_selected_entry()
            if sel then
              pcall(vim.cmd, "colorscheme " .. sel[1])
            end
          end

          local function wrap_move(fn)
            return function(...)
              fn(...)
              preview()
            end
          end

          map("i", "<Tab>",   wrap_move(actions.move_selection_next))
          map("i", "<S-Tab>", wrap_move(actions.move_selection_previous))
          map("n", "<Tab>",   wrap_move(actions.move_selection_next))
          map("n", "<S-Tab>", wrap_move(actions.move_selection_previous))

          actions.select_default:replace(function()
            local sel = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            local name = sel[1]
            vim.cmd("colorscheme " .. name)
            pcall(vim.fn.writefile, { name }, theme_file)
            print("Theme set to " .. name)
          end)

          actions.close:enhance({
            post = function()
              if original and vim.g.colors_name ~= original then
                -- keep whatever user saved
              end
            end,
          })

          return true
        end,
      }):find()
    end

    vim.keymap.set("n", "<leader>st", pick_theme, { desc = "Switch Theme (Live Preview)" })
  end,
}

