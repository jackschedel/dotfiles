local dap = require("dap")
dap.adapters.codelldb = {
	type = "server",
	host = "127.0.0.1",
	port = 13000, -- 💀 Use the port printed out or specified with `--port`
}

dap.configurations.cpp = {
	{
		function()
			vim.cmd("silent !./.build")
		end,
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			local file = io.open("./.launch", "r")
			if file ~= nil then
				local line = file:read("*l")
				file:close()
				if line ~= nil then
					return vim.fn.getcwd() .. "/" .. line
				end
			end
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		args = function()
			local file = io.open(vim.fn.getcwd() .. "/.launch", "r")
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
		stopOnEntry = false,
	},
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
