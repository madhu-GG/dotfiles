-- plugins

-- lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- clangd: standalone config with ctags-style keymaps, cmp capabilities, and
-- server flags. Must come AFTER lazy.setup so that cmp_nvim_lsp is installed.
require('clangd')
require('pylsp')

-- vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
-- vim.lsp.inline_completion.enable(not vim.lsp.inline_completion.is_enabled())

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- end of lazy package manager

-- disable language provider support (lua and vimscript plugins only)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- end of plugin defs

-- functionality
-- Harpoon
vim.keymap.set("n", "<leader>ht", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })


-- osc stuff
local function osc52_copy(text)
  local text_b64 = encode_base64(text)
  local osc = string.format('%s]52;c;%s%s', string.char(0x1b), text_b64, string.char(0x07))
  io.stderr:write(osc)
end

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    osc52_copy(vim.fn.getreg(vim.v.event.regname))
  end
})
--function copy()
--  if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
--    require('osc52').copy_register('+')
--  end
--end
--
--local osc52 = require('osc52')
--
--vim.keymap.set('n', '<leader>c', osc52.copy_operator, {expr = true})
--vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
--vim.keymap.set('v', '<leader>c', osc52.copy_visual)
--
-- vim functionality
local spacing = 4
vim.opt.tabstop = spacing
vim.opt.softtabstop = spacing
vim.opt.shiftwidth = spacing
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.expandtab = false
vim.opt.listchars = { space = '.', tab = '| ', trail = '_', extends = '>', precedes = '<', nbsp = '~', eol = '$' }

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.number = true
vim.opt.relativenumber = false

-- vim appearance
-- colorscheme
vim.opt.termguicolors=true
vim.opt.background="dark"
vim.g.gruvbox_contrast_dark="hard"
vim.g.gruvbox_contrast_light="soft"
vim.cmd [[ colorscheme unokai ]]

