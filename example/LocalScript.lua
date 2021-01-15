--/LocalScript
--game.StarterPlayer.StarterPlayerScripts
local chatUI = require(game.ReplicatedStorage.Source.Chat.ui)

local UserInputService = game:GetService("UserInputService")

local newChat = chatUI.render()

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent == false then
		if input.KeyCode == Enum.KeyCode.T then
			newChat:focusTextBox()
		end
	end
end)