local http1 = require('coro-http')

local UpdateLib = {}

local function WriteFile(file, text)
		local file = io.open(file, "w")
		file:write(text)
		file:close()
	end
end

local function Get(webVersion, dwload, fileLink)
	coroutine.wrap(function()
		if dwload == false then
			local head, version = http1.request("GET", webVersion)
			return version
		else
			assert(type(fileLink) == "string", "CompareVersionAsync <fileLink>: string expected.")
			local _, bot = http1.request("GET", fileLink)
			return bot
		end
	end)()
end

local function UpdateLib.CompareVersionAsync(localVersion, webVersion, fileLink)
	if localVersion and webVersion then
		if localVersion ~= Get(webVersion, false) then
			print("Name of the file that will be downloaded as an update (dont write .lua).")
			local name = io.read()
			WriteFile(name..".lua", Get(nil, true, fileLink))
		end
	end
end

return UpdateLib
