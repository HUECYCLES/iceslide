local Lib = {}

function Lib:init()
    Game:registerEvent("icearea", function(data)
        return IceArea(data.x, data.y, { data.width, data.height, data.polygon }, data.properties)
    end)
end

return Lib