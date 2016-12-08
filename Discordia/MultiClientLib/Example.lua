local discordia = require("discordia")
_G.timer = require("timer")
local MultiClient = require("MultiClient")

local client = discordia:Client()
local voice = discordia:VoiceClient()


client:on("ready", function() 
	printf('Logged in as %s', client.user.username)
	voice:loadOpus("libopus")
	voice:loadSodium("libsodium")
end)

client:on('messageCreate', function(message)
	if message.channel.id == "81402706320699392" and message.author.id == "191442101135867906" then

		local voiceClient, connection = MultiClient:VoiceClient(discordia, message.guild.name, client.guildCount)
		local cmd, arg = string.match(message.content, '(%S+) (.*)')
		cmd = cmd or message.content

		if cmd == ".bitrate" then
			connection:setBitrate(arg) -- We use current connection to change it's bitrate
			message.channel:sendMessage("Bitrate changed to "..arg..".")
		end

		if cmd == ".join" then
			local success, data = client._api:getChannel(arg)

			if success then
				voiceClient:joinChannel(client:getVoiceChannel(arg)) -- But we use our VoiceClient to connect to a channel.
				message.channel:sendMessage("Joined "..data.name.." channel.")
			else
				message.channel:sendMessage("Channel not found.")
			end
		end


		if cmd == ".play" then
			message.channel:sendMessage("Playing "..arg.." song.")
			client:setGameName("Playing "..arg.." song.")
			connection:playFile("songs/"..arg) -- On the other hand, we use connection to send our music.
		end

	end

end)


client:run('Token')
