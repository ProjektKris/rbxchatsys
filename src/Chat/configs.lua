local configs = {
    disableChatCoreGui = true,
    messageLifetime = 120,
    defaultTextBoxText = "T to start chatting",
    messageStyle = {
        TextWrapped = true,
        Font = Enum.Font.SourceSans,
        FontSize = Enum.FontSize.Size18,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Color3.new(1, 1, 1),
        TextStrokeTransparency = 0.5,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18)
    },
    contentsStyle = { -- scrolling frame style
        ScrollBarThickness = 2,
        BorderSizePixel = 0
    }
}
return configs
