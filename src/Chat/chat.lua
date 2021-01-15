-- author: @ProjektKris
-- serverside only
local std = require(script.Parent.std)
local TextService = game:GetService("TextService")

local chat = {}
chat.__index = chat

-- chat.new(name string)
function chat.new(name)
    local newChat = {
        Messages = {},
        OnMessageFunctions = {},
        RemoteEvent = std.Path("ReplicatedStorage/Remotes/" .. name ..
                                   "/RemoteEvent", "RemoteEvent")
    }
    setmetatable(newChat, chat)

    newChat.RemoteEvent.OnServerEvent:Connect(function(client, message, recipient, styles)
        newChat:message(client, recipient, message, styles)
    end)

    return newChat
end

-- chat:message(client Player, recipient string, message string, styles Object<any>)
function chat:message(client, recipient, message, styles)
    -- print(client, recipient, message, styles)
    local textFilterResult = TextService:FilterStringAsync(message, client.UserId)
    local filteredMessage = textFilterResult:GetNonChatStringForBroadcastAsync()
    
    if recipient == "everyone" then
        self.RemoteEvent:FireAllClients(client, filteredMessage, styles)
    elseif recipient == "team" then
        local targetRecipients = game.Players[client].Team:GetPlayers()
        for _, player in pairs(targetRecipients) do
            self.RemoteEvent:FireClient(player, client, filteredMessage, styles)
        end
    else
        local targetRecipient = game.Players[recipient]
        self.RemoteEvent:FireClient(targetRecipient, client, filteredMessage, styles)
    end

    -- run :onMessage functions
    for _, func in pairs(self.OnMessageFunctions) do
        local thread = coroutine.wrap(function()
            func(client, recipient, message, styles)
        end)
        thread()
    end
end

-- chat:onMessage(func function)
function chat:onMessage(func)
    self.OnMessageFunctions[#self.OnMessageFunctions + 1] = func
end

return chat
