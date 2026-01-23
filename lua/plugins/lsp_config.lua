require('mason-lspconfig').setup({
  ensure_installed = { "lua_ls", "clangd", "cmake" },
  handlers = {
    function (server_name)
      vim.lsp.config(server_name, {})
    end,
    lua_ls = function ()
      vim.lsp.config('lua_ls', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
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
      })
    end,
    clangd = function ()
      vim.lsp.config('clangd', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_new_config = function(new_config, _)
          local status, cmake = pcall(require, "cmake-tools")
          if status then
            cmake.clangd_on_new_config(new_config)
          end
        end,
      })
    end,
    cmake = function ()
      vim.lsp.config('cmake', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })
    end,
  }
})
