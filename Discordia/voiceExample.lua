local discordia = require('discordia')

discordia.loadOpus('libopus')
discordia.loadSodium('libsodium')
discordia.loadFFmpeg('ffmpeg')

local client = discordia.Client()
local voice = discordia.VoiceClient()

local clients = {}

local function getReady()
	for i =  1, client.guildCount do
		print("Adding voice client number: ".. i)
		clients[i] = { 
			[1] = discordia.VoiceClient(),
			[2] = 0,
			[3] = "",
		}
	end
end

local function Event(instance)
	instance:on('connect', function()
	    instance:play('song.mp3')
	end)
end

local function Channel(id)
	local success, data = client._api:getChannel(id)
	return data
end

local function Check(guildName, id)
	for k, Container in pairs(clients) do
		for nCheck, vClient in pairs(Container) do
			if clients[k][3] == guildName then
				Event(vClient)
				return vClient
			else
				if clients[k][2] == 0 then
					clients[k][2] = 1
					clients[k][3] = Channel(id).name
					Event(vClient)
					return vClient
				end
			end
		end
	end
end

local function join(client, id, guildName)
	guildName = guildName or ""
	Check(guildName, id):joinChannel(client:getVoiceChannel(id))
end

client:on('ready', function()
	getReady()
	print('Logged in as %s', client.user.username)
	join(client, "85482585546833920")
end)


client:on('messageCreate', function(message)
	local cmd, arg = string.match(message.content, '(%S+) (.*)')
	cmd = cmd or message.content

	if cmd == ".join" then
		print(arg or "not found")
		local success, data = client._api:getChannel(arg)
		if success then
			join(client, arg, data.name)
			message.channel:sendMessage("Joined "..data.name.." channel.")
		else
			message.channel:sendMessage("Channel not found.")
		end
	end

	if cmd == ".play" then
		Check(message.guild.name, message.channel.name):play(arg)
		message.channel:sendMessage("Playing "..arg.." song.")
	end
end)


client:run("Token")
