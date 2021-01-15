-- author: @ProjektKris
-- clientside only
local chat = {}
chat.__index = chat

-- chat.new(name string)
function chat.new(name)
    local newChat = {
        Messages = {},
        OnMessageReceiveFunctions = {},
        RemoteEvent = game.ReplicatedStorage:WaitForChild("Remotes")
            :WaitForChild(name):WaitForChild("RemoteEvent"),
        Recipient = "everyone"
    }
    setmetatable(newChat, chat)

    -- events
    newChat.RemoteEvent.OnClientEvent:Connect(
        function(sender, message, styles) -- client Player, message string, styles Object<any>
            -- run :onMessageReceive functions
            for _, func in pairs(newChat.OnMessageReceiveFunctions) do
                local thread = coroutine.wrap(function()
                        func(sender, message, styles)
                    end)
                thread()
            end
        end)

    return newChat
end

-- chat:message(message string, styles Object<any>)
function chat:message(message, styles)
    self.RemoteEvent:FireServer(message, self.Recipient, styles)
end

-- chat:onMessageReceive(func function)
function chat:onMessageReceive(func)
    self.OnMessageReceiveFunctions[#self.OnMessageReceiveFunctions + 1] = func
end

-- chat:changeRecipient(recipient string)
function chat:changeRecipient(recipient) self.Recipient = recipient end

return chat
