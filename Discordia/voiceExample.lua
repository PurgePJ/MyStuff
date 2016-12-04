local discordia = require('discordia')

discordia.loadOpus('libopus')
discordia.loadSodium('libsodium')
discordia.loadFFmpeg('ffmpeg')

local client = discordia.Client()
local voice = discordia.VoiceClient()

client:on('ready', function()
    printf('Logged in as %s', client.user.username)
    voice:joinChannel(client:getVoiceChannel('85482585546833920'))
end)

voice:on('connect', function()
    voice:play('song.mp3')
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



client:run("YourToken")
