local lualine = require("lualine")
local cmake = require("cmake-tools")
-- you can find the icons from https://github.com/Civitasv/runvim/blob/master/lua/config/icons.lua
local icons = require("config.icons")

cmake.setup({
  cmake_command = "cmake", -- this is used to specify cmake command path
  cmake_regenerate_on_save = false, -- auto generate when save CMakeLists.txt
  cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
  cmake_build_options = {}, -- this will be passed when invoke `CMakeBuild`
  cmake_build_directory = "", -- this is used to specify generate directory for cmake
  cmake_build_directory_prefix = "cmake-builds/cmake-build-", -- when cmake_build_directory is set to "", this option will be activated
  cmake_soft_link_compile_commands = false, -- this will automatically make a soft link from compile commands file to project root dir
  cmake_compile_commands_from_lsp = true, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
  cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
  cmake_variants_message = {
    short = { show = true }, -- whether to show short message
    long = { show = true, max_length = 40 }, -- whether to show long message
  },
  cmake_dap_configuration = { -- debug settings for cmake
    name = "cpp",
    type = "cppdbg",
    -- type = "codelldb",
    request = "launch",
    stopOnEntry = false,
    runInTerminal = true,
    console = "integratedTerminal",
  },
  cmake_executor = { -- executor to use
    name = "quickfix", -- name of the executor
    opts = {}, -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
    default_opts = { -- a list of default and possible values for executors
      quickfix = {
        show = "always", -- "always", "only_on_error"
        position = "belowright", -- "bottom", "top"
        size = 10,
      },
      overseer = {
        new_task_opts = {}, -- options to pass into the `overseer.new_task` command
        on_new_task = function(task) end, -- a function that gets overseer.Task when it is created, before calling `task:start`
      },
      terminal = {}, -- terminal executor uses the values in cmake_terminal
    },
  },
  cmake_terminal = {
    name = "terminal",
    opts = {
      name = "Main Terminal",
      prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
      split_direction = "horizontal", -- "horizontal", "vertical"
      split_size = 11,

      -- Window handling
      single_terminal_per_instance = true, -- Single viewport, multiple windows
      single_terminal_per_tab = true, -- Single viewport per tab
      keep_terminal_static_location = true, -- Static location of the viewport if avialable

      -- Running Tasks
      start_insert_in_launch_task = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
      start_insert_in_other_tasks = false, -- If you want to enter terminal with :startinsert upon launching all other cmake tasks in the terminal. Generally set as false
      focus_on_main_terminal = true, -- Focus on cmake terminal when cmake task is launched. Only used if executor is terminal.
      focus_on_launch_terminal = true, -- Focus on cmake launch terminal when executable target in launched.
    },
  },
  cmake_notifications = {
    enabled = true, -- show cmake execution progress in nvim-notify
    spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
    refresh_rate_ms = 100, -- how often to iterate icons
  },
})


-- --- Add buttons to lualine -------------------------------------------------
local colors = {
  yellow   = "#ECBE7B",
  cyan     = "#008080",
  darkblue = "#081633",
  green    = "#98be65",
  orange   = "#FF8800",
  violet   = "#a9a1e1",
  magenta  = "#c678dd",
  blue     = "#51afef",
  red      = "#ec5f67",
}

local config = require('lualine').get_config()

-- Inserts a component in lualine_c at left section
local function insert_component(component)
  table.insert(config.sections.lualine_c, component)
end

insert_component {
  function()
    local c_preset = cmake.get_configure_preset()
    return "CMake: [" .. (c_preset and c_preset or "X") .. "]"
  end,
  color = { fg = colors.magenta },
  icon = icons.ui.Search,
  cond = function()
    return cmake.is_cmake_project() and cmake.has_cmake_preset()
  end,
  on_click = function(n, mouse)
    if (n == 1) then
      if (mouse == "l") then
        vim.cmd("CMakeSelectConfigurePreset")
      end
    end
  end
}

insert_component {
  function()
    local type = cmake.get_build_type()
    return "CMake: [" .. (type and type or "") .. "]"
  end,
  color = { fg = colors.magenta },
  icon = icons.ui.Search,
  cond = function()
    return cmake.is_cmake_project() and not cmake.has_cmake_preset()
  end,
  on_click = function(n, mouse)
    if (n == 1) then
      if (mouse == "l") then
        vim.cmd("CMakeSelectBuildType")
      end
    end
  end
}

insert_component {
  function()
    local kit = cmake.get_kit()
    return "[" .. (kit and kit or "X") .. "]"
  end,
  icon = icons.ui.Pencil,
  color = { fg = colors.red },
  cond = function()
    return cmake.is_cmake_project() and not cmake.has_cmake_preset()
  end,
  on_click = function(n, mouse)
    if (n == 1) then
      if (mouse == "l") then
        vim.cmd("CMakeSelectKit")
      end
    end
  end
}

insert_component {
  function()
    return "Build"
  end,
  icon = icons.ui.Gear,
  color = { fg = colors.blue },
  cond = cmake.is_cmake_project,
  on_click = function(n, mouse)
    if (n == 1) then
      if (mouse == "l") then
        vim.cmd("CMakeBuild")
      end
    end
  end
}

insert_component {
  function()
    local b_preset = cmake.get_build_preset()
    return "[" .. (b_preset and b_preset or "X") .. "]"
  end,
  icon = icons.ui.Search,
  cond = function()
    return cmake.is_cmake_project() and cmake.has_cmake_preset()
  end,
  on_click = function(n, mouse)
    if (n == 1) then
      if (mouse == "l") then
        vim.cmd("CMakeSelectBuildPreset")
      end
    end
  end
}

insert_component {
  function()
    local b_target = cmake.get_build_target()
    return "[" .. (b_target and b_target or "X") .. "]"
  end,
  color = { fg = colors.violet },
  cond = cmake.is_cmake_project,
  on_click = function(n, mouse)
    if (n == 1) then
      if (mouse == "l") then
        vim.cmd("CMakeSelectBuildTarget")
      end
    end
  end
}

insert_component {
  function()
    return icons.ui.Debug
  end,
  color = { fg = colors.orange },
  cond = cmake.is_cmake_project,
  on_click = function(n, mouse)
    if (n == 1) then
      if (mouse == "l") then
        vim.cmd("CMakeDebug")
      end
    end
  end
}

insert_component {
  function()
    return icons.ui.Run
  end,
  color = { fg = colors.green },
  cond = cmake.is_cmake_project,
  on_click = function(n, mouse)
    if (n == 1) then
      if (mouse == "l") then
        vim.cmd("CMakeRun")
      end
    end
  end
}

insert_component {
  function()
    local l_target = cmake.get_launch_target()
    return "[" .. (l_target and l_target or "X") .. "]"
  end,
  color = { fg = colors.cyan },
  cond = cmake.is_cmake_project,
  on_click = function(n, mouse)
    if (n == 1) then
      if (mouse == "l") then
        vim.cmd("CMakeSelectLaunchTarget")
      end
    end
  end
}

lualine.setup(config)
