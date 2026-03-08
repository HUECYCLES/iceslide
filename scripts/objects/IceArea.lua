-- Simply plop this into Tiled!
-- [IMPORTANT] Remember to shrink it a bit when you put it over a tileset so that it doesn't look weird!
---@class IceArea : Event
---
---@field sound    string?
---
---@overload fun(...) : IceArea
local IceArea, super = Class(Event)

function IceArea:init(x, y, shape, properties)
    super.init(self, x, y, shape)

    properties = properties or {}
    
    self.sound = properties["sound"] or nil -- Sound property to play when you enter the IceArea. String in Tiled.
end

function IceArea:onEnter(chara)
    if chara.is_player and chara.state ~= "ICESLIDE" then
        if self.sound then
            Assets.stopAndPlaySound(self.sound)
        end

        chara:setState("ICESLIDE", false)

        chara.current_iceslide_area = self

        chara.iceslide_x = 0
        chara.iceslide_y = 0
        
        if Input.down("right") or chara:getFacing() == "right" then
            chara.iceslide_x = 1
        end
        if Input.down("left") or chara:getFacing() == "left" then
            chara.iceslide_x = -1
        end
        if Input.down("up") or chara:getFacing() == "up" then
            chara.iceslide_y = -1
        end
        if Input.down("down") or chara:getFacing() == "down" then
            chara.iceslide_y = 1
        end
    end
end

function IceArea:onExit(chara)
    if chara.is_player and chara.state == "ICESLIDE" then
        local should_stop = true

        -- Are we touching any others?
        Object.startCache()
        for _, area in ipairs(Game.stage:getObjects(IceArea)) do
            if chara:collidesWith(area) then
                should_stop = false
                break
            end
        end
        Object.endCache()

        if should_stop then
            chara:setState("WALK")
            chara.current_iceslide_area = nil
        end
    end
end

return IceArea