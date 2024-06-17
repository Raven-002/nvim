-- To use custom config, add a file: nvim/lua/user/user_config.lua and
-- have the file return a table with all the settings you want to change.
--
-- example:
-- return {
--   use_dev_icons = false,
--   smooth_scroll = false,
-- }
--
-- It is recommended to copy the default config and changing from there.

local has_user_config, user_config = pcall(require, "user/user_config")

local default_config = {
  -- The colorscheme to use. To add new ones, add them in extra plugins.
  colorscheme = 'onedark',

  -- Use extra icons. Turning this to false will not completely remove icons.
  use_dev_icons = true,

  -- Suppress directories for auto saving sessions.
  extra_auto_session_suppress_dirs = {},

  -- Show indentation marks
  show_indentations = true,

  -- Scroll smoothly.
  smooth_scroll = true,

  -- Show function doc while typing the fields.
  lsp_signiture = true,

  -- Settings for the default themes
  onedark_opts = {
    style = "warmer"
  },
  gruvbox_opts = {
    contrast = "hard"
  },
  tokyonight_opts = {},
  monokai_opts = {},

  -- Add extra plugins here in Lazy's format.
  extra_plugins = {},
}

local config = has_user_config and user_config or {}

local function set_default(t, key, default_value)
  if t[key] == nil then
    t[key] = default_value
  end
end

for key, val in pairs(default_config) do
  set_default(config, key, val)
end

return config
