-- author: @ProjektKris
local std = {}

function std.Path(path, instanceName)
    local subs = string.split(path, "/")
    local instance
    for i, p in pairs(subs) do
        if i == 1 then -- first path
            -- if p == "." then -- access the current env
            --     instance = script.Parent
            -- elseif p == ".." then -- access the parent of the current env
            --     instance = script.Parent.Parent
            -- else -- access game[p]
            --     instance = game[p]
            -- end
            instance = game[p]
        else
            if instance:FindFirstChild(p) then
                instance = instance[p]
            else
                if i == #subs then
                    instance = Instance.new(p, instance)
                else
                    instance = Instance.new("Folder", instance)
                    instance.Name = p
                end
            end
        end
    end
    return instance
end

return std
