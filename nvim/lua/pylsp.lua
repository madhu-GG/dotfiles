--local python_root = "/ws/madhg-bgl/.pyenv/versions/3.12.6"
--local lspconfig = require'lspconfig'
--lspconfig.pylsp.setup {
--    cmd = { python_root .. "/bin/pylsp"},
--    settings = {
--        pylsp = {
--            configurationSources = { "flake8" },
--            plugins = {
--                flake8 = { enabled = true },
--                jedi = { enabled = true },
--                mccabe = { enabled = false },
--                mypy = { enabled = false }, -- mypy does not use executable
--                pycodestyle = { enabled = false },
--                pydocstyle = { enabled = false },
--                pyflakes = { enabled = false },
--                pylint = { enabled = false },
--                rope_autoimport = { enabled = false },
--                yapf = { enabled = false },
--                ruff = { enabled = false },
--            },
--        }
--    }
--}
--

vim.lsp.config('pylsp', {
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = false }, -- Example: disable pycodestyle if using ruff
        flake8 = { enabled = true },
      },
    },
  },
})

-- Enable the server for python files
vim.lsp.enable('pylsp')
