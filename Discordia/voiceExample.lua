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
			[2] = 0
		}
	end
end

local function Event(instance)
	instance:on('connect', function()
	    instance:play('fya.mp3')
	end)
end

local function Check()
	for k, Container in pairs(clients) do
		for vClient, nCheck in pairs(Container) do
			if clients[k][2] == 0 then
				clients[k][2] = 1
				Event(nCheck)
				return nCheck
			end
		end
	end
end

local function join(client, id)
	Check():joinChannel(client:getVoiceChannel(id))
end

client:on('ready', function()
	getReady()
	printf('Logged in as %s', client.user.username)
	join(client, "85482585546833920")
end)


client:on('messageCreate', function(message)
	local cmd, arg = string.match(message.content, '(%S+) (.*)')
	cmd = cmd or message.content

	if cmd == ".join" then
		local success, data = client._api:getChannel(arg)
		if succes then
			voice:joinChannel(client:getVoiceChannel(arg))
			message.channel:sendMessage("Joined "..data.name.." channel.")
		else
			message.channel:sendMessage("Channel not found.")
		end
	end

	if cmd == ".play" then
		suc, er = pcall(voice:play(arg))
		if suc then
			voice:stop()
			message.channel:sendMessage("Playing "..arg.." song.")
		else
			message.channel:sendMessage(er)
		end
	end
end)



client:run("Token")
