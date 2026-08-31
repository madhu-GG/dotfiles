-- nvim-cmp: popup autocompletion
-- Sources: LSP → buffer text → file paths
return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',   -- lazy-load: only when entering Insert mode
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',  -- primary source: LSP completions
      'hrsh7th/cmp-buffer',    -- fallback: words from open buffers
      'hrsh7th/cmp-path',      -- fallback: filesystem paths
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        -- ── Mappings ────────────────────────────────────────────────────────
        mapping = cmp.mapping.preset.insert({
          -- open/refresh the completion menu manually
          ['<C-Space>'] = cmp.mapping.complete(),
          -- abort and close the menu
          ['<C-e>']     = cmp.mapping.abort(),
          -- confirm the selected item (select=true picks the first if none selected)
          ['<CR>']      = cmp.mapping.confirm({ select = true }),
          -- navigate the list
          ['<Tab>']     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<S-Tab>']   = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          -- scroll the documentation popup
          ['<C-d>']     = cmp.mapping.scroll_docs(4),
          ['<C-u>']     = cmp.mapping.scroll_docs(-4),
        }),

        -- ── Sources (priority order) ─────────────────────────────────────────
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer',  keyword_length = 3 },
          { name = 'path' },
        }),

        -- ── Appearance ───────────────────────────────────────────────────────
        formatting = {
          format = function(entry, vim_item)
            -- tag each completion item with its source
            local source_labels = {
              nvim_lsp = '[LSP]',
              buffer   = '[buf]',
              path     = '[path]',
            }
            vim_item.menu = source_labels[entry.source.name] or ''
            return vim_item
          end,
        },

        -- show at most 10 entries to keep the popup compact
        view = { entries = { name = 'custom', selection_order = 'near_cursor' } },
        experimental = { ghost_text = true },   -- inline ghost-text preview
      })
    end,
  },
}
