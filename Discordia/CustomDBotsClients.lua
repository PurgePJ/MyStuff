local MultiClient, clients = {}, {}
local Started, botNumber = 0, 1
local json, fs = require("json"), require("fs")

local function getReady(discordia)
	for i =  1, 200 do
		clients[i] = {discordia.Client(), 0}
	end
end

local function Ready(discordia)
	if Started == 0 then
		getReady( discordia)
		Started = 1
	end
end

local function AddToFile(text)
	local cSaved = io.open("Clients.txt", "a")
	cSaved:write(json.encode(text).."\n")
	cSaved:close()
end

local function GenerateNew(discordia, token)
	Ready(discordia)
	if clients[botNumber][2] == 1 then 
		botNumber = botNumber + 1
	end
	if not fs.existsSync("accounts.txt") then return end
	for line in io.lines("Clients.txt") do
		if line:find(token) then
			return clients[botNumber][1]
		else
			clients[botNumber][2] = 1
			AddToFile(token)
			return clients[botNumber][1]
		end
	end
	botNumber = botNumber + 1
end

function MultiClient:Client(discordia, token)
	local client = GenerateNew(discordia, token)
	return client or "Invalid instance."
end

return MultiClient
