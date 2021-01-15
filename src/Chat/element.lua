-- !nonstrict
-- Author: @ProjektKris
local react = {};
react.__index = react;

-- .createElement(instanceType string, attributes Object<any>)
function react.createElement(instanceType, attributes)
    local components = {}
    local temp_instance = Instance.new(instanceType);

    -- locate styles
    if (attributes._Styles) then
        for _, style in pairs(attributes._Styles) do
            for attributeName, value in pairs(style) do -- load styles first, attributes will overwrite this
                temp_instance[attributeName] = value
            end
        end
    end

    for attributeName, value in pairs(attributes) do
        if (attributeName == '_Components') then
            -- index components
            components = value

            -- set the parent of components
            for _, component in pairs(components) do
                component.instance.Parent = temp_instance;
            end
        elseif (attributeName ~= '_Styles') then
            temp_instance[attributeName] = value
        end
    end

    -- create new 'Element' object
    local newElement = {instance = temp_instance, components = components};
    setmetatable(newElement, react);
    return newElement;
end

-- :getProperty(attribute string)
function react:getProperty(attribute) return self.instance[attribute]; end

-- :getComponent(path string)
function react:getComponent(path)
    local points = string.split(path, '/');
    local desiredItem = self;
    for _, point in pairs(points) do
        desiredItem = desiredItem.components[point];
    end
    return desiredItem;
end

-- :mount(parent Instance)
function react:mount(parent) self.instance.Parent = parent; end

-- :unmount()
function react:unmount()
    self.instance:Destroy()
    self = nil
end

-- :bind(event string, func function)
function react:bind(event, func) return self.instance[event]:Connect(func) end

return react;
