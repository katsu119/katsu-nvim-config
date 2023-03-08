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
vim.keymap.set('n', '<space>D',  "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)

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
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

  if client.name == "svlangserver" then
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
  end

  -- Outline
  vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts)

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

require("lspconfig").clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

-- require("lspconfig").verible.setup {
--   on_attach = on_attach,
--   -- capabilities = capabilities,
--   flags = lsp_flags,
--   root_dir = function() return vim.loop.cwd() end,
-- }

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
