local dap = require("dap")
dap.adapters.go = {
	type = "executable",
	command = "node",
	args = { "go-debug-adapter" },
}
dap.configurations.go = {
	{
		type = "go",
		name = "Debug",
		request = "launch",
		showLog = false,
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
		dlvToolPath = vim.fn.exepath("dlv"),
	},
}
