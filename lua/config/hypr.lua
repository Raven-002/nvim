-- Hyprlang LSP (once per buffer; hyprls must be on $PATH)
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = { '*.hl', 'hypr*.conf' },
  callback = function(args)
    local bufnr = args.buf
    if vim.bo[bufnr].buftype ~= '' then
      return
    end
    if next(vim.lsp.get_clients({ bufnr = bufnr, name = 'hyprlang' })) then
      return
    end
    vim.lsp.start({
      name = 'hyprlang',
      cmd = { 'hyprls' },
      root_dir = vim.fn.getcwd(),
    })
  end,
})

-- Hyprlang TreeSitter
vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
