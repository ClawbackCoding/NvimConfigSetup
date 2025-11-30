return {
  "mfussenegger/nvim-dap",
  dependencies = { "mfussenegger/nvim-dap-python" },

  config = function()
    local dap = require("dap")
    local dap_python = require("dap-python")

    dap_python.setup("python")

    -- F2 to start debugger
    vim.keymap.set("n", "<F2>", function()
      dap.continue()
    end, {})

    -- Optional: breakpoints
    vim.keymap.set("n", "<F3>", dap.toggle_breakpoint)
    vim.keymap.set("n", "<F4>", dap.step_over)
    vim.keymap.set("n", "<F5>", dap.step_into)
  end,
}

