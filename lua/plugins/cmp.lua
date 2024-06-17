local present, cmp = pcall(require, "cmp")
if not present then
  return
end
local has_lspkind, lspkind = pcall(require, "lspkind")

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup {
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

    -- <Tab> and <S-Tab> for selecting next/prev item
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
         cmp.select_next_item()
      -- elseif require("luasnip").expand_or_jumpable() then
      --    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
         fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
         cmp.select_prev_item()
      -- elseif require("luasnip").jumpable(-1) then
      --    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
         fallback()
      end
    end,
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = {
    format = has_lspkind and lspkind.cmp_format({ with_text = false, maxwidth = 50 }) or nil
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
    { name = "nvim_lua" }
  },
}
