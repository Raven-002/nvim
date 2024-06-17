require ('mason-nvim-dap').setup({
    ensure_installed = { "python", "delve", "codelldb", "cppdbg" },
    handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
    },
})

