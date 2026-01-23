require('mason-lspconfig').setup({
  ensure_installed = { "lua_ls", "clangd", "cmake" }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup servers manually
require('lspconfig').lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'},
      },
    },
    workspace = {
      library = {
        [vim.fn.expand "$VIMRUNTIME/lua"] = true,
        [vim.fn.stdpath "config" .. "/lua"] = true,
      },
    },
  },
}

require('lspconfig').clangd.setup{
  capabilities = capabilities,
  on_new_config = function(new_config, _)
    local status, cmake = pcall(require, "cmake-tools")
    if status then
      cmake.clangd_on_new_config(new_config)
    end
  end,
}

require('lspconfig').cmake.setup{
  capabilities = capabilities,
}
