local term = require("config.terminal")

vim.keymap.set({ "n", "t" }, "<leader>t", function()
  if vim.fn.mode() == "t" then vim.api.nvim_input("<C-\\><C-n>") end
  term.open_main()
end, { desc = "Open main terminal" })

vim.keymap.set({ "n", "t" }, "<leader>tc", function()
  if vim.fn.mode() == "t" then vim.api.nvim_input("<C-\\><C-n>") end
  term.close_main()
end, { desc = "Close main terminal" })

vim.keymap.set({ "n", "t" }, "<leader>ta", function()
  if vim.fn.mode() == "t" then vim.api.nvim_input("<C-\\><C-n>") end
  term.add_term()
end, { desc = "Add terminal" })

vim.keymap.set({ "n", "t" }, "<leader>tr", function()
  if vim.fn.mode() == "t" then vim.api.nvim_input("<C-\\><C-n>") end
  term.close_current_term()
end, { desc = "Close current terminal" })

-- Terminal ergonomics: jj to exit, i/a to re enter

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    -- In terminal input mode, type jj to go to terminal normal mode
    vim.keymap.set("t", "jj", [[<C-\><C-n>]], opts)

    -- Optional, keep this too if you like
    vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], opts)

    -- When you are in terminal normal mode, make i and a go back to terminal input mode
    vim.keymap.set("n", "i", function()
      if vim.bo.buftype == "terminal" then
        vim.cmd("startinsert")
      else
        vim.api.nvim_feedkeys("i", "n", false)
      end
    end, opts)

    vim.keymap.set("n", "a", function()
      if vim.bo.buftype == "terminal" then
        vim.cmd("startinsert")
      else
        vim.api.nvim_feedkeys("a", "n", false)
      end
    end, opts)
  end,
})
