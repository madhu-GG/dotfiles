return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    -- show the popup after this many ms of inactivity
    delay = 300,
    icons = { mappings = false },   -- disable icons if a Nerd Font isn't set up
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)

    -- Register group labels so the popup shows tidy section headers
    wk.add({
      { '<leader>f', group = 'find (telescope)' },
      { '<leader>l', group = 'lsp' },
      { '<leader>r', group = 'refactor/rename' },
      { '<leader>c', group = 'code action' },
    })
  end,
}
