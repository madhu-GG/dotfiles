# Neovim Config Changes — 31 March 2026

## Overview

Three capabilities were added on top of the existing config:

1. **clangd LSP** — split into its own file with ctags-style navigation keymaps
2. **Autocompletion** — `nvim-cmp` popup with LSP, buffer, and path sources
3. **which-key** — popup showing available keybindings after a short pause

---

## Files Created

### `lua/clangd.lua`

Standalone clangd configuration. Replaces the bare `{'clangd'}` entry that was
in the `lsps` table in `init.lua`.

**Responsibilities:**
- Builds LSP `capabilities`, broadened by `cmp_nvim_lsp` if available
- Registers an `LspAttach` autocmd that sets buffer-local keymaps only for clangd
- Calls `vim.lsp.config('clangd', {...})` with server flags
- Calls `vim.lsp.enable('clangd')`

**clangd server flags enabled:**

| Flag | Purpose |
|---|---|
| `--background-index` | Index the project in the background |
| `--clang-tidy` | Surface clang-tidy diagnostics inline |
| `--header-insertion=iwyu` | IWYU-style header suggestions |
| `--completion-style=detailed` | Return signature detail in completions |
| `--function-arg-placeholders` | Insert placeholders for function arguments |

**Keymaps (active only in C/C++ buffers when clangd is attached):**

| Key | Action |
|---|---|
| `<C-]>` | Jump to definition (Telescope picker, falls back to `vim.lsp.buf.definition`) |
| `<C-t>` | Jump back — remapped to `<C-o>` to mirror ctags Ctrl+T / tag stack pop |
| `<leader>ld` | List all definitions (Telescope) |
| `<leader>lr` | List all references (Telescope) |
| `<leader>li` | List all implementations (Telescope) |
| `<leader>ls` | All symbols in current file (Telescope) |
| `<leader>lS` | All symbols in workspace (Telescope) |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `<leader>e` | Show diagnostic float |

---

### `lua/plugins/cmp.lua`

Lazy plugin spec for autocompletion.

**Plugins installed:**

| Plugin | Role |
|---|---|
| `hrsh7th/nvim-cmp` | Completion engine |
| `hrsh7th/cmp-nvim-lsp` | LSP completion source (highest priority) |
| `hrsh7th/cmp-buffer` | Words from open buffers (fallback) |
| `hrsh7th/cmp-path` | Filesystem path completion (fallback) |

**Completion keymaps:**

| Key | Action |
|---|---|
| `<C-Space>` | Trigger / refresh completion menu |
| `<C-e>` | Abort and close menu |
| `<CR>` | Confirm selected item |
| `<Tab>` | Select next item |
| `<S-Tab>` | Select previous item |
| `<C-d>` | Scroll docs down |
| `<C-u>` | Scroll docs up |

Completion items are tagged with their source: `[LSP]`, `[buf]`, `[path]`.
Ghost-text (inline preview of the top suggestion) is enabled.

---

### `lua/plugins/which-key.lua`

Lazy plugin spec for `folke/which-key.nvim`.

- Pops up a keybinding guide after **300 ms** of inactivity following a prefix key
- Registers group labels for `<leader>` prefixes:

| Prefix | Label shown in popup |
|---|---|
| `<leader>f` | `find (telescope)` |
| `<leader>l` | `lsp` |
| `<leader>r` | `refactor/rename` |
| `<leader>c` | `code action` |

Icons are disabled by default (`icons = { mappings = false }`); remove that line
if a Nerd Font is configured in the terminal.

---

## Files Modified

### `init.lua`

Two changes:

1. **Commented out `{'clangd'}` in the `lsps` table** — clangd is now owned
   entirely by `lua/clangd.lua` which calls `vim.lsp.enable` itself.

   ```lua
   local lsps = {
       -- {'clangd'},  -- clangd is now configured in lua/clangd.lua
       --              (keymaps, cmp capabilities, server flags)
       {'rust-analyzer'}
   };
   ```

2. **Added `require('clangd')` after `lazy.setup`** — the require must come
   after lazy so that `cmp_nvim_lsp` (installed by lazy) is available when
   clangd builds its capabilities table.

   ```lua
   require("lazy").setup("plugins")

   -- clangd: separate config with ctags-style keymaps and autocomplete.
   -- Must come AFTER lazy.setup so that cmp_nvim_lsp is already installed.
   require('clangd')
   ```

---

## Plugin Install Summary

On first launch after these changes, lazy.nvim will install:

```
hrsh7th/nvim-cmp
hrsh7th/cmp-nvim-lsp
hrsh7th/cmp-buffer
hrsh7th/cmp-path
folke/which-key.nvim
```
