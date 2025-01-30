local MiracleModule = {}
MiracleModule.__index = MiracleModule

MiracleModule.modules = {}
MiracleModule.Started = false

local function tableSize(t: table): number
	local count = 0
	for _ in pairs(t) do
		count = count + 1
	end
	return count
end

function MiracleModule:AddModule(moduleName: string, moduleFile: ModuleScript): nil
	if self.Started then
		warn("[Miracle] Modules cannot be added after starting")
		return
	end

	if not moduleName then
		assert(moduleName, "Module name is required")
	end

	if not moduleFile then
		assert(moduleFile, "Module file is required")
	end

	if typeof(moduleName) ~= "string" then
		assert(typeof(moduleName) == "string", "Module name must be a string")
	end

	if game:GetService("RunService"):IsServer() ~= true then
		assert(game:GetService("RunService"):IsServer() == true, "This function can only be used on the server")
	end

	self.modules[moduleName] = {
		module = require(moduleFile),
		file = moduleFile,
	}
end

function MiracleModule:LoadModules(modulesFolder: Folder): nil
	if not modulesFolder then
		assert(modulesFolder, "Modules folder is required")
	end

	if typeof(modulesFolder) ~= "Instance" then
		assert(typeof(modulesFolder) == "Instance", "Modules folder must be an instance")
	end

	if game:GetService("RunService"):IsServer() ~= true then
		assert(game:GetService("RunService"):IsServer() == true, "This function can only be used on the server")
	end

	for _, module in ipairs(modulesFolder:GetChildren()) do
		if module:IsA("ModuleScript") then
			self:AddModule(module.Name, module)
		end
	end
end

function MiracleModule:GetModule(moduleName: string): ModuleScript
	if not moduleName then
		assert(moduleName, "Module name is required")
	end

	if typeof(moduleName) ~= "string" then
		assert(typeof(moduleName) == "string", "Module name must be a string")
	end

	if not self.modules[moduleName] then
		assert(self.modules[moduleName], "Module does not exist")
	end

	return self.modules[moduleName].module
end

function MiracleModule:Start(): nil
	local size = tableSize(self.modules)

	if size > 0 then
		for _, module in pairs(self.modules) do
			if module.module.Start then
				module.module:Start()
			end
		end
	else
		warn("[Miracle] No modules to start")
	end
end

return MiracleModule
