return {
  'numToStr/Comment.nvim',
  config = function()
    local comment = require('Comment')
    comment.setup()

    -- Custom keymaps for separate comment/uncomment
    local api = require('Comment.api')

    -- Comment selected lines (gc)
    vim.keymap.set('n', 'gc', function()
      api.comment.linewise.current()
    end, { desc = 'Comment line' })

    vim.keymap.set('v', 'gc', function()
      api.comment.linewise(vim.fn.visualmode())
    end, { desc = 'Comment selection' })

    -- Uncomment selected lines (cg)
    vim.keymap.set('n', 'cg', function()
      api.uncomment.linewise.current()
    end, { desc = 'Uncomment line' })

    vim.keymap.set('v', 'cg', function()
      api.uncomment.linewise(vim.fn.visualmode())
    end, { desc = 'Uncomment selection' })
  end
}

