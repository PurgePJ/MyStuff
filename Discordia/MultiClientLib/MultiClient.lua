local MultiClient, clients = {}, {}

local Started = 0

local function getReady(gCount, discordia)
	for i =  1, gCount do
		print("Adding voice client number: " .. i)
		clients[i] = {discordia.VoiceClient(), 0, ""}
	end
end

function MultiClient:VoiceClient(discordia, gName, gCount, bitrate) -- maybe guildId ?
	__bitrate__ = bitrate or 96000
	_G.gName = gName
	if Started == 0 then
		getReady(gCount, discordia)
	end
	for k, Container in pairs(clients) do
		for nCheck, vClient in pairs(Container) do
			if clients[k][3] == gName then
				vClient:setBitrate(__bitrate__)
				Started = 1
				return vClient
			else
				if clients[k][2] == 0 then
					clients[k][2], clients[k][3], Started = 1, gName, 1
					vClient:setBitrate(__bitrate__)
					return vClient
				end
			end
		end
	end
end

function MultiClient:Event(instance, fn)
	instance:on('connect', function()
		if fn then
			pcall(fn)
		else
			p("Voice client succesfully used for ".. gName .. " guild.")
		end
	end)
end


return MultiClient
