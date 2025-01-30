local MiracleSignal = {}
MiracleSignal.__index = MiracleSignal

function MiracleSignal.new()
	return setmetatable({
		_connections = {},
		_onceConnections = {},
	}, MiracleSignal)
end

function MiracleSignal:Connect(callback)
	local connection = {
		Callback = callback,
		Connected = true,
	}

	table.insert(self._connections, connection)

	return {
		Disconnect = function()
			connection.Connected = false
		end,
	}
end

function MiracleSignal:Once(callback)
	local connection = {
		Callback = callback,
		Connected = true,
	}

	table.insert(self._onceConnections, connection)

	return {
		Disconnect = function()
			connection.Connected = false
		end,
	}
end

function MiracleSignal:Fire(...)
	for _, connection in ipairs(self._connections) do
		if connection.Connected then
			connection.Callback(...)
		end
	end

	for _, connection in ipairs(self._onceConnections) do
		if connection.Connected then
			connection.Callback(...)
			connection.Connected = false
		end
	end

	self._onceConnections = {}
end

function MiracleSignal:Destroy()
	self._connections = {}
	self._onceConnections = {}
end

return MiracleSignal
