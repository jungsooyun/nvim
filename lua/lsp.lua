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
local flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 200,
}

-- Setup coq autocomplete
vim.g.coq_settings = {
    auto_start = 'shut-up',  -- shup up means quite mode...
    clients = {
        lsp = {
            resolve_timeout = 1  -- how much time to wait for LSP
        }
    },
    limits = {
        completion_auto_timeout = 0.66
    },
    match = {
        max_results = 10
    },
    display = {
        ghost_text = {
            context = {"", ""}
        }
    }
}
local coq = require "coq"


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
    coq.lsp_ensure_capabilities({
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
    })
)

-- Python
lsp.pylsp.setup(
  coq.lsp_ensure_capabilities({
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
  })
)

-- Rust
lsp.rust_analyzer.setup(
    coq.lsp_ensure_capabilities({
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
    })
)

-- Bash
lsp.bashls.setup(
    coq.lsp_ensure_capabilities({
        flags = flags,
        on_attach = on_attach,
        root_dir = lsp.util.find_git_ancestor
    })
)
---List of the LSP server that don't need special configuration
local servers = {
    'zls', -- Zig
    'gopls', -- Golang
    'tsserver', -- Typescript
    'html', -- HTML
    'cssls', -- CSS
    'jsonls', -- Json
    'yamlls', -- YAML
    -- 'terraformls', -- Terraform
}

for _, server in ipairs(servers) do
    lsp[server].setup(
        coq.lsp_ensure_capabilities({
            flags = flags,
            on_attach = on_attach,
        })
    )
end
