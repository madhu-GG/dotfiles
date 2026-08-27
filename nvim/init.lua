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

vim.cmd([[ colorscheme peachpuff ]])
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.background = "light"

local spacing = 4
vim.opt.tabstop = spacing
vim.opt.softtabstop = spacing
vim.opt.shiftwidth = spacing

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.expandtab = true

vim.opt.listchars = { space = '.', tab = '| ', trail = '_', extends = '>', precedes = '<', nbsp = '~', eol = '$' }
-- osc stuff

function copy()
  if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
    require('osc52').copy_register('+')
  end
end

vim.cmd([[ colorscheme peachpuff ]])
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.background = "light"

local spacing = 4
vim.opt.tabstop = spacing
vim.opt.softtabstop = spacing
vim.opt.shiftwidth = spacing

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.expandtab = true

vim.opt.listchars = { space = '.', tab = '| ', trail = '_', extends = '>', precedes = '<', nbsp = '~', eol = '$' }
-- osc stuff

function copy()
  if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
    require('osc52').copy_register('+')
  end
end

vim.keymap.set("n", "<leader>ht", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })
