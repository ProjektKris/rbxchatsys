-- author: @ProjektKris
-- clientside only
local chat = require(game.ReplicatedStorage.Source.Chat.clientChat)
local element = require(game.ReplicatedStorage.Source.Chat.element)
local configs = require(script.Parent.configs)

local TextService = game:GetService("TextService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")

local ui = {}
ui.__index = ui

-- ui.render(size UDim2)
function ui.render(position, size)
    local newUI = {
        Client = game.Players.LocalPlayer,
        Chat = chat.new("Chat"),
        OnFocusLostFunctions = {},
        MessageCount = 0,
        ScreenGui = element.createElement("ScreenGui", {
            Name = "Chat",
            _Components = {
                Frame = element.createElement("Frame", {
                    Position = position or UDim2.new(0, 0, 0, 0),
                    Size = size or UDim2.new(0, 500, 0, 300),
                    BackgroundTransparency = 1,
                    _Components = {
                        UIListLayout = element.createElement("UIListLayout", {
                            FillDirection = Enum.FillDirection.Vertical
                        }),
                        Contents = element.createElement("ScrollingFrame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, .8),
                            _Styles = {configs.contentsStyle},
                            _Components = {
                                UIListLayout = element.createElement(
                                    "UIListLayout", {
                                        FillDirection = Enum.FillDirection.Vertical,
                                        VerticalAlignment = Enum.VerticalAlignment.Bottom,
                                        SortOrder = Enum.SortOrder.LayoutOrder
                                    })
                            }
                        }),
                        TextBox = element.createElement("TextBox", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, .2),
                            ClearTextOnFocus = true,
                            Text = "",
                            _Styles = {configs.messageStyle}
                        })
                    }
                })
            }
        })
    }
    setmetatable(newUI, ui)

    -- assign parent of chat ui
    newUI.ScreenGui:mount(newUI.Client.PlayerGui)

    -- when textbox focus is lost, functions binded with :onFocusLost() will run
    newUI.ScreenGui:getComponent("Frame/TextBox"):bind("FocusLost", function(enterPressed, inputThatCausedFocusLost)
        if enterPressed then newUI:confirm() end

        -- run all binded functions
        for _, func in pairs(newUI.OnFocusLostFunctions) do
            local thread = coroutine.wrap(function() -- we dont want a random binded function to clog this
                    func()
                end)
            thread()
        end

        -- reset text
        newUI.ScreenGui:getComponent("Frame/TextBox").instance.Text = configs.defaultTextBoxText
    end)

    -- message received from server
    newUI.Chat:onMessageReceive(function(sender, message, styles)
        local function createWhitespaces(n)
            local str = ""
            for _ = 1, n do str = str .. " " end
            return str
        end
        local function color3ToRGB(color3)
            return color3.r * 255, color3.g * 255, color3.b * 255
        end

        local absoluteParentSize =
            newUI.ScreenGui:getComponent("Frame/Contents"):getProperty(
                "AbsoluteSize")
        local senderTxtLen = string.len(sender.Name) + 3
        local txtLen = TextService:GetTextSize(
                           createWhitespaces(senderTxtLen) .. message, 18,
                           Enum.Font.SourceSans,
                           Vector2.new(absoluteParentSize.X, 500))

        local r, g, b = color3ToRGB(sender.TeamColor.Color)
        local rgbString = tostring(math.ceil(r)) .. "," ..
                              tostring(math.ceil(g)) .. "," ..
                              tostring(math.ceil(b))

        local newText = element.createElement("TextLabel", {
            Text = "<font color=\"rgb(" .. rgbString .. ")\">[" .. sender.Name ..
                "]</font>: " .. message, -- createWhitespaces(senderTxtLen) .. message,
            Size = UDim2.new(1, 0, 0, txtLen.Y),
            RichText = true,
            LayoutOrder = newUI.MessageCount,
            _Styles = {configs.messageStyle, styles}
        })

        local contents = newUI.ScreenGui:getComponent("Frame/Contents").instance

        -- set new gui element's parent
        newText:mount(contents)

        -- increase LayoutOrder num
        newUI.MessageCount += 1

        -- scroll down
        contents.CanvasPosition = Vector2.new(0, contents.AbsoluteWindowSize.Y * contents.CanvasSize.Y.Scale)
        
        -- garbage collection
        Debris:AddItem(newText.instance, configs.messageLifetime)
    end)

    -- Set CoreGui
    if configs.disableChatCoreGui then
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
    end

    return newUI
end

function ui:focusTextBox()
    self.ScreenGui:getComponent("Frame/TextBox").instance:CaptureFocus()
    wait()
    self.ScreenGui:getComponent("Frame/TextBox").instance.Text = ""
end

function ui:confirm()
    if self.ScreenGui:getComponent("Frame/TextBox").instance.Text ~= "" then
        self.Chat:message(self.ScreenGui:getComponent("Frame/TextBox").instance
                              .Text, {})
        self.ScreenGui:getComponent("Frame/TextBox").instance:ReleaseFocus()
    end
end

function ui:onFocusLost(func)
    self.OnFocusLostFunctions[#self.OnFocusLostFunctions + 1] = func
end

return ui
