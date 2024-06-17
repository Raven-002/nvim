require('mason-lspconfig').setup({
  ensure_installed = { "lua_ls", "clangd", "cmake" }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason-lspconfig").setup_handlers {
  function (server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {}
  end,
  ["clangd"] = function ()
    require('lspconfig').clangd.setup{
      on_new_config = function(new_config, _)
        local status, cmake = pcall(require, "cmake-tools")
        if status then
          cmake.clangd_on_new_config(new_config)
        end
      end,
    }
  end,
  ["lua_ls"] = function ()
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
  end,
}
