local dap = require("dap")

dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = "OpenDebugAD7",
	options = {
		detached = false,
	},
}

dap.configurations.cpp = {
	{
		function()
			vim.cmd("silent !./.build")
		end,
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = function()
			local file = io.open("./.launch", "r")
			if file ~= nil then
				local line = file:read("*l")
				file:close()
				if line ~= nil then
					return line
				end
			end
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		args = function()
			local file = io.open("./.launch", "r")
			if file ~= nil then
				local lines = {}
				for line in file:lines() do
					table.insert(lines, line)
				end
				file:close()
				if #lines > 1 then
					return vim.split(lines[2], " ")
				end
			end
			return {}
		end,
		cwd = "${workspaceFolder}",
		stopAtEntry = true,
	},
}

-- If you want to use this for Rust and C, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
