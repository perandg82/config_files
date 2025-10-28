require("mason").setup()
local servers = {
	lua_ls = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }
			},
		},
	},
	clangd = {},
}

-- local on_attach = function(_, _)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[N]ame' })
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
	vim.keymap.set('n', '<leader>ce', vim.diagnostic.goto_next, { desc = '[C]ode [E]rrors' })
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efitintion' })
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = '[G]oto [I]mplementation' })
	vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eferences' })
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
-- end

vim.lsp.log.set_level("off")

require("mason-lspconfig").setup({
	ensure_installed = vim.tbl_keys(servers),
})

local caps = vim.lsp.protocol.make_client_capabilities()
caps = require('cmp_nvim_lsp').default_capabilities(caps)

require('mason-lspconfig').setup({
    handlers = {
        function(server_name)
			require('lspconfig')[server_name].setup {
				capabilities = caps,
				-- on_attach = on_attach,
				settings = servers[server_name],
				filetypes = (servers[server_name] or {}).filetypes,
			}
        end
    },
})

local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- Using vim.lsp.config directly
vim.lsp.config.yamlls = {
    settings = {
        yaml = {
            -- Automatically fetch common schemas from schemastore.org
            schemaStore = {
                enable = true,
            },

            -- Schemas for specific file types (crucial for Azure Pipelines)
            schemas = {
                -- Azure Pipelines Schema
                ["https://json.schemastore.org/azure-pipelines.json"] = "azure-pipelines.yml",

                -- Kubernetes Schema (common example)
                ["kubernetes"] = "*k8s*.yaml",
            },

            -- Formatting options (optional)
            format = {
                enable = true,
                useTabs = false,
                tabSize = 2,
            },
        },
    },
    -- NOTE: 'on_attach' and 'capabilities' are still valid options
    -- in this table and should be defined elsewhere in your config.
    -- on_attach = function(client, bufnr) ... end,
    -- capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

-- To enable the configuration for the relevant filetypes (yaml, yml),
-- you must now explicitly call vim.lsp.enable:
vim.lsp.enable('yamlls')
