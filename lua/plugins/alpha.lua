 -- return {
 --   "goolord/alpha-nvim",
 --   dependencies = { "nvim-tree/nvim-web-devicons" },
 --   config = function() 
 --     local startify = require("alpha.themes.startify")
 --
 --     startify.file_icons.provider = "devicons"
 --      require("alpha").setup(startify.config)
 --   end, 
 -- }

return {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        local alpha = require'alpha'
        local dashboard = require'alpha.themes.dashboard'

        -- 1. Header (Same as before)
        dashboard.section.header.val = {
            [[                                                                       ]],
            [[██     ██ ███████ ██       ██████  ██████  ███    ███ ███████     ████████]],
            [[██     ██ ██      ██      ██      ██    ██ ████  ████ ██             ██   ]],
            [[██  █  ██ █████   ██      ██      ██    ██ ██ ████ ██ █████          ██   ]],
            [[██ ███ ██ ██      ██      ██      ██    ██ ██  ██  ██ ██             ██   ]],
            [[ ███ ███  ███████ ███████  ██████  ██████  ██      ██ ███████        ██   ]],
            [[                                                                       ]],
        }

        vim.api.nvim_set_hl(0, 'AlphaGradient1', { fg = '#5e99f5' })
        vim.api.nvim_set_hl(0, 'AlphaGradient2', { fg = '#8e7ae3' })
        vim.api.nvim_set_hl(0, 'AlphaGradient3', { fg = '#be5bd1' })
        vim.api.nvim_set_hl(0, 'AlphaGradient4', { fg = '#ee3cbf' })

        dashboard.section.header.opts.hl = {
            { { "AlphaGradient1", 0, -1 } },
            { { "AlphaGradient1", 0, -1 } },
            { { "AlphaGradient2", 0, -1 } },
            { { "AlphaGradient2", 0, -1 } },
            { { "AlphaGradient3", 0, -1 } },
            { { "AlphaGradient3", 0, -1 } },
            { { "AlphaGradient4", 0, -1 } },
        }

        -- 2. ROBUST Recent Files Function
        local function get_recent_files()
            local start = 1
            local amount = 5
            local tbl = {}
            local oldfiles = vim.v.oldfiles -- Grabs the history
            
            for _, file in pairs(oldfiles) do
                -- Check if file exists (Windows safe)
                local file_info = vim.loop.fs_stat(file)
                if file_info then
                    local short_name = vim.fn.fnamemodify(file, ":~:.")
                    local shortcut = tostring(start - 1)
                    
                    local btn = dashboard.button(shortcut, " " .. short_name, ":e " .. file .. "<CR>")
                    btn.opts.hl = "Comment"
                    btn.opts.hl_shortcut = "Number"
                    
                    table.insert(tbl, btn)
                    start = start + 1
                    if start > amount then break end
                end
            end

            -- IF EMPTY: Return a fallback message so you know it's working
            if #tbl == 0 then
                return {
                    type = "text",
                    val = "(No recent files found - Open some files!)",
                    opts = { hl = "Comment", position = "center" }
                }
            end

            return {
                type = "group",
                val = tbl,
                opts = { spacing = 1 }
            }
        end

        -- 3. Buttons
        dashboard.section.buttons.val = {
            dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
            dashboard.button("n", "  New File", ":ene <BAR> startinsert <CR>"),
            dashboard.button("q", "  Quit", ":qa<CR>"),
        }

        -- 4. Layout
        dashboard.config.layout = {
            { type = "padding", val = 4 },
            dashboard.section.header,
            { type = "padding", val = 2 },
            
            -- Title
            { type = "text", val = "Recent Files", opts = { hl = "SpecialComment", position = "center" } },
            { type = "padding", val = 1 },
            
            -- Call the function
            get_recent_files(),
            
            { type = "padding", val = 2 },
            dashboard.section.buttons,
            { type = "padding", val = 1 },
            dashboard.section.footer,
        }

        -- 5. Auto-Open Explorer
        vim.api.nvim_create_autocmd("User", {
            pattern = "AlphaReady",
            callback = function()
                vim.defer_fn(function() 
                    local key = vim.api.nvim_replace_termcodes("<leader>es", true, false, true)
                    vim.api.nvim_feedkeys(key, 'm', false)
                end, 50)
            end,
        })

        alpha.setup(dashboard.config)
    end
}
