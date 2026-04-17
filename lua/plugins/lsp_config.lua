-- Neovim 0.11+: use |vim.lsp.config()|; mason-lspconfig v2 only needs
-- ensure_installed — it calls |vim.lsp.enable()| for Mason-installed servers.
-- See :help lspconfig-vs-vim.lsp.config (on_new_config is unavailable; cmake
-- integration uses a |cmd| function that applies cmake-tools before |rpc.start|).

local cmp_caps = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('lua_ls', {
  capabilities = cmp_caps,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.stdpath('config') .. '/lua'] = true,
        },
      },
    },
  },
})

-- CMake script LSP: prefer `neocmake` (Mason: neocmakelsp, GitHub release binary).
-- The `cmake` server maps to PyPI `cmake-language-server`, which often fails to install.
vim.lsp.config('neocmake', {
  capabilities = cmp_caps,
})

local default_clangd_cmd = { 'clangd' }

vim.lsp.config('clangd', {
  capabilities = cmp_caps,
  cmd = function(dispatchers, config)
    local cfg = vim.deepcopy(config)
    cfg.cmd = default_clangd_cmd
    local ok, cmake = pcall(require, 'cmake-tools')
    if ok then
      cmake.clangd_on_new_config(cfg)
    end
    return vim.lsp.rpc.start(cfg.cmd, dispatchers, {
      cwd = cfg.cmd_cwd,
      env = cfg.cmd_env,
      detached = cfg.detached,
    })
  end,
})

require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'clangd', 'neocmake' },
})
