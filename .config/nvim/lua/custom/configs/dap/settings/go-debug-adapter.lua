local dap = require("dap")
dap.adapters.go = function(callback, config)
	-- Wait for delve to start
	vim.defer_fn(function()
		callback({ type = "server", host = "127.0.0.1", port = "port" })
	end, 100)
end
dap.configurations.go = {
	{
		type = "go",
		name = "Debug",
		request = "launch",
		program = "${file}",
	},
}
