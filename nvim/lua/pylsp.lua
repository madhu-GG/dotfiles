local python_root = "/ws/madhg-bgl/.pyenv/versions/3.12.6"
local lspconfig = require'lspconfig'
lspconfig.pylsp.setup {
    cmd = { python_root .. "/bin/pylsp"},
    settings = {
        pylsp = {
            configurationSources = { "flake8" },
            plugins = {
                flake8 = { enabled = true },
                jedi = { enabled = true },
                mccabe = { enabled = false },
                mypy = { enabled = false }, -- mypy does not use executable
                pycodestyle = { enabled = false },
                pydocstyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                rope_autoimport = { enabled = false },
                yapf = { enabled = false },
                ruff = { enabled = false },
            },
        }
    }
}

