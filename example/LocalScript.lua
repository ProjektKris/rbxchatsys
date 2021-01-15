--/LocalScript
--game.StarterPlayer.StarterPlayerScripts
local chatUI = require(game.ReplicatedStorage.Source.Chat.ui)

local UserInputService = game:GetService("UserInputService")

local newChat = chatUI.render()

local focused = false

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent == false then
		--print(input.KeyCode)
		if input.KeyCode == Enum.KeyCode.T then
			newChat:focusTextBox()
			focused = true
		--elseif input.KeyCode == Enum.KeyCode.Return then
		--	newChat:confirm()
		end
	end
end)

newChat:onFocusLost(function()
	focused = false
end)