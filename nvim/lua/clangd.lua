-- clangd LSP configuration
-- Loaded from init.lua via: require('clangd')
--
-- Keybinding semantics:
--   <C-]>        jump to definition           (mirrors ctags Ctrl+])
--   <C-t>        jump back (pop jump stack)   (mirrors ctags Ctrl+T)
--   <leader>ld   list definitions via Telescope
--   <leader>lr   list all references via Telescope
--   <leader>ls   list symbols in current file
--   <leader>lS   list symbols in the workspace
--
--   K            hover docs
--   <leader>rn   rename symbol
--   <leader>ca   code action
--   ]d / [d      next/prev diagnostic
--   <leader>e    show diagnostic float

-- ─── Capabilities (enhanced by nvim-cmp if available) ───────────────────────

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- cmp_nvim_lsp broadens the set of completion capabilities advertised to the
-- server so it returns richer completions (snippets, labelDetails, etc.).
local ok_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- ─── Per-buffer keymaps (attached when clangd connects) ─────────────────────

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('clangd_keymaps', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or client.name ~= 'clangd' then return end

    local opts = { buffer = ev.buf, noremap = true, silent = true }

    -- ── ctags-style navigation ──────────────────────────────────────────────

    -- <C-]>  Jump to definition (replaces ctags tagstack jump)
    --        Uses LSP definition; Telescope picker when multiple results exist
    local ok_tel, builtin = pcall(require, 'telescope.builtin')
    if ok_tel then
      vim.keymap.set('n', '<C-]>', builtin.lsp_definitions,
        vim.tbl_extend('force', opts, { desc = 'LSP: go to definition' }))
    else
      vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition,
        vim.tbl_extend('force', opts, { desc = 'LSP: go to definition' }))
    end

    -- <C-t>  Jump back – mirrors ctags Ctrl+T (pop tag stack).
    --        In neovim the jumplist (<C-o>) is the LSP equivalent of the tag
    --        stack; we remap <C-t> to it so muscle-memory is preserved.
    vim.keymap.set('n', '<C-t>', '<C-o>',
      vim.tbl_extend('force', opts, { desc = 'LSP: jump back (jump stack)' }))

    -- ── List / browse ───────────────────────────────────────────────────────

    if ok_tel then
      -- <leader>ld  All definitions for the symbol under cursor
      vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions,
        vim.tbl_extend('force', opts, { desc = 'LSP: list definitions' }))

      -- <leader>lr  All references for the symbol under cursor
      vim.keymap.set('n', '<leader>lr', builtin.lsp_references,
        vim.tbl_extend('force', opts, { desc = 'LSP: list references' }))

      -- <leader>li  All implementations
      vim.keymap.set('n', '<leader>li', builtin.lsp_implementations,
        vim.tbl_extend('force', opts, { desc = 'LSP: list implementations' }))

      -- <leader>ls  All symbols/definitions in the current file
      vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols,
        vim.tbl_extend('force', opts, { desc = 'LSP: file symbols' }))

      -- <leader>lS  All symbols across the workspace
      vim.keymap.set('n', '<leader>lS', builtin.lsp_workspace_symbols,
        vim.tbl_extend('force', opts, { desc = 'LSP: workspace symbols' }))
    end

    -- ── Other useful LSP bindings ───────────────────────────────────────────

    vim.keymap.set('n', 'K',           vim.lsp.buf.hover,
      vim.tbl_extend('force', opts, { desc = 'LSP: hover docs' }))

    vim.keymap.set('n', '<leader>rn',  vim.lsp.buf.rename,
      vim.tbl_extend('force', opts, { desc = 'LSP: rename symbol' }))

    vim.keymap.set('n', '<leader>ca',  vim.lsp.buf.code_action,
      vim.tbl_extend('force', opts, { desc = 'LSP: code action' }))

    vim.keymap.set('n', ']d',          vim.diagnostic.goto_next,
      vim.tbl_extend('force', opts, { desc = 'LSP: next diagnostic' }))

    vim.keymap.set('n', '[d',          vim.diagnostic.goto_prev,
      vim.tbl_extend('force', opts, { desc = 'LSP: prev diagnostic' }))

    vim.keymap.set('n', '<leader>e',   vim.diagnostic.open_float,
      vim.tbl_extend('force', opts, { desc = 'LSP: show diagnostic' }))
  end,
})

-- ─── clangd server configuration ────────────────────────────────────────────

vim.lsp.config('clangd', {
  capabilities = capabilities,
  cmd = {
    'clangd',
    '--background-index',       -- index project in background
    '--clang-tidy',             -- enable clang-tidy diagnostics
    '--header-insertion=iwyu',  -- include-what-you-use style headers
    '--completion-style=detailed',
    '--function-arg-placeholders', -- insert placeholders for args on completion
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
})

vim.lsp.enable('clangd')
