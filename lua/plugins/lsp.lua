require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local lsp_server_need_installed = { "lua_ls", "rust_analyzer", "clangd", "svlangserver", "verible" }

require("mason-lspconfig").setup({
  ensure_installed = lsp_server_need_installed,
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<space>sl',  "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
vim.keymap.set('n', '<space>sc',  "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
vim.keymap.set('n', '<space>ca',  "<cmd>Lspsaga code_action<CR>", opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<space>d', "<cmd>Lspsaga peek_definition<CR>", bufopts)
  vim.keymap.set('n', 'K',  "<cmd>Lspsaga hover_doc<CR>", bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

  -- workspace related keymap
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)

  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

  if client.name == "svlangserver" then
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
  end

  -- Outline
  vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts)
  -- Call hierarchy
  vim.keymap.set("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
  vim.keymap.set("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
end


local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- custom the sign of diagnostic
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end



local capabilities = require('cmp_nvim_lsp').default_capabilities()


-------------------- metals config begin -----------------------------------------
local metals_config = require("metals").bare_config()
metals_config.on_attach = on_attach;
-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- *READ THIS*
-- I *highly* recommend setting statusBarProvider to true, however if you do,
-- you *have* to have a setting to display this in your statusline or else
-- you'll not see any messages from metals. There is more info in the help
-- docs about this
metals_config.init_options.statusBarProvider = "on"

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
metals_config.capabilities = capabilities

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
-------------------- metals config end -----------------------------------------
require("lspconfig").clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

require("lspconfig").verible.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
  -- root_dir = function() return vim.loop.cwd() end,
}

require("lspconfig").svlangserver.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
  filetypes = {"verilog", "systemverilog"},
})

require("lspconfig").svls.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
})

-- if not require'lspconfig.configs'.hdl_checker then
--   require'lspconfig.configs'.hdl_checker = {
--     default_config = {
--     cmd = {"hdl_checker", "--lsp", };
--     filetypes = {"vhdl", "verilog", "systemverilog"};
--       root_dir = function(fname)
--         -- will look for the .hdl_checker.config file in parent directory, a
--         -- .git directory, or else use the current directory, in that order.
--         local util = require'lspconfig'.util
--         return util.root_pattern('.hdl_checker.config')(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
--       end;
--       settings = {};
--     };
--   }
-- end
--
-- require'lspconfig'.hdl_checker.setup{}

require("lspconfig").lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
}
