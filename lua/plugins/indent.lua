return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        -- 1. The character to use for the line
        indent = { char = "│" },

        -- 2. Scope: Highlight the current code block context
        scope = {
            enabled = true,
            show_start = false, -- Don't underline the start of the block
            show_end = false,   -- Don't underline the end of the block
        },

        -- 3. Exclude these filetypes (so you don't see lines in dashboard/help)
        exclude = {
            filetypes = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "Trouble",
                "lazy",
                "mason",
                "notify",
            },
        },
    },
}
