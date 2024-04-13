local M = {
  last_testname = "",
  last_testpath = "",
  test_buildflags = "",
}

local default_config = {
  delve = {
    path = "dlv",
    initialize_timeout_sec = 20,
    port = "${port}",
    args = {},
    build_flags = "",
  },
}

local function load_module(module_name)
  local ok, module = pcall(require, module_name)
  assert(ok, string.format("dap-go dependency error: %s not installed", module_name))
  return module
end

local function setup_delve_adapter(dap, config)
  local args = { "dap", "-l", "127.0.0.1:" .. config.delve.port }
  vim.list_extend(args, config.delve.args)

  dap.adapters.go = {
    type = "server",
    port = config.delve.port,
    executable = {
      command = config.delve.path,
      args = args,
    },
    options = {
      initialize_timeout_sec = config.delve.initialize_timeout_sec,
    },
  }
end

local function setup_go_configuration(dap, configs)
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug (Arguments)",
      request = "launch",
      program = "${file}",
      args = function()
        local file = io.open(vim.fn.getcwd() .. "/.launch", "r")
        if file ~= nil then
          local lines = {}
          for line in file:lines() do
            table.insert(lines, line)
          end
          file:close()
          if #lines > 0 then
            return vim.split(lines[1], " ")
          end
        end
        return {}
      end,
      buildFlags = configs.delve.build_flags,
    },
  }

  if configs == nil or configs.dap_configurations == nil then
    return
  end

  for _, config in ipairs(configs.dap_configurations) do
    if config.type == "go" then
      table.insert(dap.configurations.go, config)
    end
  end
end

local config = vim.tbl_deep_extend("force", default_config, {})
M.test_buildflags = config.delve.build_flags
local dap = load_module "dap"
setup_delve_adapter(dap, config)
setup_go_configuration(dap, config)

return M
