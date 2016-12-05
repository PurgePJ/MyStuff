local MultiClient, clients = {}, {}

local Started = 0

local function getReady(gCount, discordia)
	for i =  1, gCount do
		print("Adding voice client number: ".. i)
		clients[i] = {discordia.VoiceClient(), 0,"",}
	end
end

function MultiClient:VoiceClient(discordia, gName, gCount) -- maybe guildId ?
	if Started == 0 then
		getReady(gCount, discordia)
	end
	for k, Container in pairs(clients) do
		for nCheck, vClient in pairs(Container) do
			if clients[k][3] == gName then
				MultiClient:Event(vClient)
				vClient:setBitrate(96000)
				Started = 1
				return vClient
			else
				if clients[k][2] == 0 then
					clients[k][2] = 1
					clients[k][3] = gName
					MultiClient:Event(vClient)
					vClient:setBitrate(96000)
					Started = 1
					return vClient
				end
			end
		end
	end
end

function MultiClient:Event(instance, fn)
	instance:on('connect', function()
		--instance:createFFmpegStream("DesdeQue.mp3"):play()
		if fn then
			pcall(fn)
		end
		-- TODO ? 
	end)
end


return MultiClient
