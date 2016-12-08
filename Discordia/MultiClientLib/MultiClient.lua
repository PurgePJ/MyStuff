local MultiClient, clients = {}, {}
local Started, con = 0, nil

local function getReady(gCount, discordia)
	for i =  1, gCount do
		print("Adding voice client number: ".. i)
		clients[i] = {discordia.VoiceClient(), 0, ""}
	end
end

local function Ready(gCount, discordia)
	if Started == 0 then
		getReady(gCount, discordia)
		Started = 1
	end
end

local function EmulateEvent(client)
	client:on("connect", function(connection)
		print(connection)
		con = connection
	end)
	return con
end

function MultiClient:VoiceClient(discordia, gName, gCount, bitrate) -- maybe guildId ?
	Ready(gCount, discordia)
	for k, Container in pairs(clients) do
		for nCheck, vClient in pairs(Container) do
			if clients[k][3] == gName then
				return vClient, EmulateEvent(vClient)
			elseif clients[k][2] == 0 then
				clients[k][2], clients[k][3] = 1, gName
				local connection = EmulateEvent(vClient)
				timer.sleep(1000)
				return vClient, connection
			end
		end
	end
end


return MultiClient
