-- Simply plop this into Tiled!
-- [IMPORTANT] Remember to shrink it a bit when you put it over a tileset so that it doesn't look weird!
local IceArea, super = Class(Event, "icearea")

function IceArea:init(data)
    super.init(self, data.x, data.y, data.width, data.height)

    local properties = data.properties or {}
    
    self.sound = properties["sound"] or nil -- sound property to play when you enter the icearea. string in Tiled.
end

function IceArea:onEnter(chara)
    if chara.is_player then
        if chara.state ~= "ICESLIDE" and self.sound then
            Assets.playSound(self.sound)
        end

        chara:setState("ICESLIDE", false)

        chara.current_iceslide_area = self

        chara.iceslide_x = 0
        chara.iceslide_y = 0
        
        if Input.down("right") or chara.facing == "right" then
            chara.iceslide_x = 1
        end
        if Input.down("left") or chara.facing == "left" then
            chara.iceslide_x = -1
        end
        if Input.down("up") or chara.facing == "up" then
            chara.iceslide_y = -1
        end
        if Input.down("down") or chara.facing == "down" then
            chara.iceslide_y = 1
        end
    end
end

function IceArea:onExit(chara)
    if chara.is_player and chara.state == "ICESLIDE" then
        chara:setState("WALK")
        chara.current_iceslide_area = nil
    end
end

return IceArea