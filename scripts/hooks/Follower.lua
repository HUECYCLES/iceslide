local Follower, super = HookSystem.hookScript(Follower)

function Follower:init(chara, x, y, target)
    super.init(self, chara, x, y)

    self.state_manager:addState("ICESLIDE", { enter = self.beginIceSlide, leave = self.endIceSlide })
end

function Follower:beginIceSlide()
    if Kristal.getLibConfig("iceslide", "use_custom_sprites") and self.actor:getAnimation("iceslide/" .. Game.world.player:getFacing()) then
        self.sprite:setAnimation("iceslide/" .. Game.world.player:getFacing())
    else
        self.sprite:setSprite(self.actor.default .. "/" .. Game.world.player:getFacing() .. "_" .. TableUtils.pick({ "2", "4" }))
    end
end

function Follower:endIceSlide()
    self.sprite:resetSprite()
end

return Follower