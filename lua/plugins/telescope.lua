return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },

  config = function()
    local telescope = require("telescope")

    -- Path where we persist the last chosen theme
    local theme_file = vim.fn.stdpath("data") .. "/last_theme.txt"

    -- Try to load last saved theme on startup
    local ok_read, last_theme = pcall(function()
      local lines = vim.fn.readfile(theme_file)
      return lines[1]
    end)

    if ok_read and last_theme and last_theme ~= "" then
      pcall(vim.cmd, "colorscheme " .. last_theme)
    end

    telescope.setup({
      defaults = {
        file_ignore_patterns = {
          -- VCS folders
          "[/\\]%.git[/\\]",

          -- Virtual environments
          "[/\\]venv[/\\]",
          "[/\\]%.venv[/\\]",

          -- Literal folder named %USERPROFILE%
          "[/\\]%%USERPROFILE%%[/\\]",

          -- Python
          "[/\\]__pycache__[/\\]",
          "%.pyc",

          -- Node and frontend junk
          "[/\\]node_modules[/\\]",
          "[/\\]bower_components[/\\]",
          "[/\\]dist[/\\]",
          "[/\\]build[/\\]",
          "%.min%.js",
          "[/\\]%.next[/\\]",
          "[/\\]%.nuxt[/\\]",
          "[/\\]out[/\\]",
          "[/\\]coverage[/\\]",

          -- Rust
          "[/\\]target[/\\]",
          "%.rlib",
          "%.rmeta",

          -- Generic compiled or binary files
          "%.o",
          "%.obj",
          "%.exe",
          "%.dll",
          "%.so",
          "%.dylib",
          "%.bin",
          "%.class",
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })

    telescope.load_extension("ui-select")

    local builtin = require("telescope.builtin")

    ----------------------------------------------------------------------
    -- File finding
    ----------------------------------------------------------------------
    vim.keymap.set("n", "<leader>ff", function()
      builtin.find_files({
        hidden = true,
        no_ignore = false,
        no_ignore_parent = false,
      })
    end, { desc = "Find files (clean)" })

    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })

    ----------------------------------------------------------------------
    -- LSP fuzzy navigation
    ----------------------------------------------------------------------
    vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, { desc = "Find definitions" })
    vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
    vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
    vim.keymap.set("n", "<leader>fw", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })

    ----------------------------------------------------------------------
    -- Theme Switcher with live preview and persistence (<leader>st)
    ----------------------------------------------------------------------
    local possible_themes = {
      "catppuccin",
      "gruvbox",
      "tokyonight",
      "everforest",
      "onedark",
    }

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
      local actions = require("telescope.actions")
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

          map("i", "<Tab>", wrap_move(actions.move_selection_next))
          map("i", "<S-Tab>", wrap_move(actions.move_selection_previous))
          map("n", "<Tab>", wrap_move(actions.move_selection_next))
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
              if original then
                vim.cmd("colorscheme " .. original)
                print("Theme reverted to " .. original)
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

