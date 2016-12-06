local discordia = require('discordia')
local MultiClient = require("MultiClient")

discordia.loadOpus('libopus')
discordia.loadSodium('libsodium')
discordia.loadFFmpeg('ffmpeg')

local client = discordia.Client()
local voice = discordia.VoiceClient()


client:on('ready', function()
	printf('Logged in as %s', client.user.username)
end)


client:on('messageCreate', function(message)
	if message.channel.id == "81402706320699392" and message.author.id == "191442101135867906" then

		local cmd, arg = string.match(message.content, '(%S+) (.*)')
		cmd = cmd or message.content

		local MultiClientGiver = MultiClient:VoiceClient(discordia, message.guild.name, client.guildCount)

		if cmd == ".join" then

			local success, data = client._api:getChannel(arg)

			if success then
				MultiClientGiver:joinChannel(client:getVoiceChannel(arg))
				message.channel:sendMessage("Joined "..data.name.." channel.")
			else
				message.channel:sendMessage("Channel not found.")
			end
		end

		if cmd == ".play" then
			message.channel:sendMessage("Playing "..arg.." song.")
			client:setGameName("Playing "..arg.." song.")
			local stream = MultiClientGiver:createFFmpegStream(arg)
			stream:play()
		end
	end

end)


client:run("Token")
