-- copilot
vim.cmd[[highlight CopilotSuggestions ctermfg=8]]

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

---Common perf related flags for all the LSP servers
local lsp = require('lspconfig')
local configs = require('lspconfig.configs')
local flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 200,
}

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '-',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'nvim_lsp', keyword_length = 1 },  -- need keyword length to request
    { name = 'buffer', keyword_length = 2 },
    { name = 'luasnip', keyword_length = 2 }, -- For luasnip users.
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Disable completion in certain contets, such as comments
cmp.setup({
    enabled = function()
      -- disable completion in comments
      local context = require 'cmp.config.context'
      -- keep command mode completion enabled when cursor is in a comment
      if vim.api.nvim_get_mode().mode == 'c' then
        return true
      else
        return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
      end
    end
})
-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

-- Lua
-- lsp.sumneko_lua.setup({
--     flags = flags,
--     capabilities = capabilities,
--     on_attach = on_attach,
--     settings = {
--         Lua = {
--             completion = {
--                 enable = true,
--                 showWord = 'Disable',
--                 -- keywordSnippet = 'Disable',
--             },
--             runtime = {
--                 -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--                 version = 'LuaJIT',
--             },
--             diagnostics = {
--                 globals = { 'vim' },
--             },
--             workspace = {
--                 -- Make the server aware of Neovim runtime files
--                 library = { os.getenv('VIMRUNTIME') },
--             },
--             -- Do not send telemetry data containing a randomized but unique identifier
--             telemetry = {
--                 enable = false,
--             },
--         },
--     },
-- })


-- C, CPP
lsp.clangd.setup(
    {
      flags = flags,
      on_attach = on_attach,
      root_dir = lsp.util.root_pattern(
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac',
        '.git'
      )
    }
)

-- Python
lsp.pylsp.setup(
  {
    flags = flags,
    on_attach = on_attach,
    settings = {
      pylsp = {
        plugins = {
          -- flake8? hmm...
          pycodestyle = {
            ignore = {'E402', 'E501', 'E731', 'E741'},
            maxLineLength = 120
          },
          pylsp_mypy = {
            live_mode = true,
            strict = false
          }
        }
      }
    }
  }
)

-- Rust
lsp.rust_analyzer.setup(
    {
      flags = flags,
      on_attach = on_attach,
      root_dir = lsp.util.root_pattern(
        'Cargo.toml',
        'rust-project.json'
      ),
      tools = {
          runnables = {
              use_telescope = true,
          },
          inlay_hints = {
              auto = true,
              show_parameter_hints = false,
              parameter_hints_prefix = "",
              other_hints_prefix = "",
          }
      },
      settings = {
          ['rust-analyzer'] = {
              cargo = {
                  allFeatures = true,
              },
              checkOnSave = {
                  allFeatures = true,
                  command = 'clippy',
              },
              procMacro = {
                  ignored = {
                      ['async-trait'] = { 'async_trait' },
                      ['napi-derive'] = { 'napi' },
                      ['async-recursion'] = { 'async_recursion' },
                  },
              },
          },
      },
    }
)

-- Bash
lsp.bashls.setup(
    {
      flags = flags,
      on_attach = on_attach,
      root_dir = lsp.util.find_git_ancestor
    }
)

-- Helm
if not configs.helm_ls then
  configs.helm_ls = {
    default_config = {
      cmd = {"helm_ls", "serve"},
      filetypes = {'helm'},
      root_dir = function(fname)
        return lsp.util.root_pattern('Chart.yaml')(fname)
      end,
    },
  }
end

-- Solidity
lsp.solidity.setup(
    {
      cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
      filetypes = { 'solidity' },
      root_dir = lsp.util.root_pattern(".git", "hardhat.config.*"),
      capabilities = capabilities,
      single_file_support = true,
      flags = flags,
      on_attach = on_attach,
    }
)

lsp.helm_ls.setup {
  filetypes = {"helm"},
  cmd = {"helm_ls", "serve"},
}

---List of the LSP server that don't need special configuration
local servers = {
    'zls', -- Zig
    'gopls', -- Golang
    'tsserver', -- Typescript
    'html', -- HTML
    'cssls', -- CSS
    'jsonls', -- Json
    -- 'yamlls', -- YAML  << temporarily disabled since crash with helm
    -- 'terraformls', -- Terraform
}

for _, server in ipairs(servers) do
    lsp[server].setup(
      {
        flags = flags,
        on_attach = on_attach,
      }
    )
end
