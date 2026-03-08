local Player, super = HookSystem.hookScript(Player)

function Player:init(chara, x, y)
    super.init(self, chara, x, y)

    if Kristal.getLibConfig("iceslide", "trail") and Kristal.getLibConfig("iceslide", "use_trailsound") then
        self.icetrail_sound = Assets.newSound(Kristal.getLibConfig("iceslide", "trailsound"))
        self.icetrail_sound:setLooping(true)
    end

    self.state_manager:addState("ICESLIDE",
        { update = self.updateIceSlide, enter = self.beginIceSlide, leave = self.endIceSlide })

    self.current_ice_area = nil
    self.iceslide_in_place = false

    if Kristal.getLibConfig("iceslide", "trail") then
        self.icetrail_timer = 0
    end

    self.iceslide_stop_timer = 0
    self.iceslide_x = 1
    self.iceslide_y = 1
end

function Player:onRemove(parent)
    super.onRemove(self, parent)

    if Kristal.getLibConfig("iceslide", "trail") and Kristal.getLibConfig("iceslide", "use_trailsound") then
        self.icetrail_sound:stop()
    end
end

function Player:onRemoveFromStage(stage)
    super.onRemoveFromStage(self, stage)

    if Kristal.getLibConfig("iceslide", "trail") and Kristal.getLibConfig("iceslide", "use_trailsound") then
        self.icetrail_sound:stop()
    end
end

function Player:isCameraAttachable()
    super.isCameraAttachable(self)
    return not (self.state_manager.state == "SLIDE" and self.slide_in_place) or
        not (self.state_manager.state == "ICESLIDE" and self.iceslide_in_place)
end

function Player:beginIceSlide(last_state, in_place)
    if Kristal.getLibConfig("iceslide", "trail") and Kristal.getLibConfig("iceslide", "use_trailsound") then
        self.icetrail_sound:play()
    end
    self.auto_moving = true
    self.iceslide_in_place = in_place or false
    self.iceslide_stop_timer = 0

    if Kristal.getLibConfig("iceslide", "use_custom_sprites") and self.actor:getAnimation("iceslide/" .. self:getFacing()) then
        self.sprite:setAnimation("iceslide/" .. self:getFacing())
    else
        self.sprite:setSprite(self.actor.default .. "/" .. self:getFacing() .. "_" .. TableUtils.pick({ "2", "4" }))
    end
end

function Player:updateIceTrail()
    self.icetrail_timer = MathUtils.approach(self.icetrail_timer, 0, DTMULT)

    if self.icetrail_timer == 0 then
        if self:getFacing() == "left" or self:getFacing() == "right" then
            self.icetrail_timer = 3
        else
            self.icetrail_timer = 2
        end

        local trail = Sprite(Kristal.getLibConfig("iceslide", "trailsprite"), love.math.random(14), love.math.random(5))
        trail:setOrigin(0.5, 0.5)
        if Kristal.getLibConfig("iceslide", "trailsprite_color") then
            trail:setColor(Kristal.getLibConfig("iceslide", "trailsprite_color"))
        end
        if Kristal.getLibConfig("iceslide", "trailsprite_initial_scale") then
            trail:setScale(Kristal.getLibConfig("iceslide", "trailsprite_initial_scale") - MathUtils.random(0.3))
        else
            trail:setScale(1.2 - MathUtils.random(0.3))
        end
        trail:setLayer(self.layer - 0.01)
        trail:move(self.x, (self.y - self.height / 4))

        trail.physics.direction = math.rad(math.random(360))

        trail.graphics.spin = 0.02 + MathUtils.random(0.05)
        trail.physics.speed = 0.8

        self.world:addChild(trail)
        self.world.timer:after(0.2 / 10, function()
            trail.graphics.grow = 0.008
            trail:fadeOutAndRemove(0.8)
        end)
    end
end

function Player:updateIceSlide()
    local iceslide_x = self.iceslide_x or 1
    local iceslide_y = self.iceslide_y or 0

    self.run_timer = 200
    local speed = self:getBaseWalkSpeed() * 2

    self:move(iceslide_x, iceslide_y, speed * DTMULT)
    if Kristal.getLibConfig("iceslide", "trail") then
        self:updateIceTrail()
    end
end

function Player:endIceSlide(next_state)
    if Kristal.getLibConfig("iceslide", "trail") and Kristal.getLibConfig("iceslide", "use_trailsound") then
        self.icetrail_sound:stop()
    end
    self.sprite:resetSprite()
    self.auto_moving = false
end

function Player:update()
    super.update(self)

    if self.iceslide_stop_timer > 0 and self.state_manager.state ~= "ICESLIDE" then
        self.iceslide_stop_timer = MathUtils.approach(self.iceslide_stop_timer, 0, DTMULT)
        if self.iceslide_stop_timer == 0 then
            if Kristal.getLibConfig("iceslide", "trail") and Kristal.getLibConfig("iceslide", "use_trailsound") then
                self.icetrail_sound:stop()
            end
            self.sprite:resetSprite()
        end
    end
end

return Player