require('base_settings')
require('plugins')
require('maps')
pcall(require, 'user/user_settings')
pcall(require, 'user/user_maps')
local config = require('user.get_config')
vim.cmd("colorscheme " .. config.colorscheme)