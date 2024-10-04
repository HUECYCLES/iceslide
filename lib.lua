local Lib = {}

function Lib:init()
    local custom = Kristal.getLibConfig("iceslide", "use_custom_sprites")
    local use_icetrail_and_sound = Kristal.getLibConfig("iceslide", "use_icetrail_and_sound")
    local trailsound = Kristal.getLibConfig("iceslide", "trailsound")

    -- Player hooks
    Utils.hook(Player, "init", function(orig, self, chara, x, y)
        orig(self, chara, x, y)

        if use_icetrail_and_sound then
            self.iceslide_sound = Assets.newSound(trailsound)
            self.iceslide_sound:setLooping(true)
        end

        self.state_manager:addState("ICESLIDE", { update = self.updateIceSlide, enter = self.beginIceSlide, leave = self.endIceSlide })

        self.current_ice_area = nil
        self.iceslide_in_place = false

        if use_icetrail_and_sound then
            self.icetrail_timer = 0
        end
        self.iceslide_stop_timer = 0

		self.iceslide_x = 1
		self.iceslide_y = 1
    end)

    Utils.hook(Player, "onRemove", function(orig, self, parent)
        orig(self, parent)

        if use_icetrail_and_sound then
            self.iceslide_sound:stop()
        end
    end)

    Utils.hook(Player, "onRemoveFromStage", function(orig, self, stage)
        orig(self, stage)

        if use_icetrail_and_sound then
            self.iceslide_sound:stop()
        end
    end)
    
    Utils.hook(Player, "isCameraAttachable", function(orig, self)
        orig(self)

        return not (self.state_manager.state == "SLIDE" and self.slide_in_place) or not (self.state_manager.state == "ICESLIDE" and self.iceslide_in_place)
    end)

    Utils.hook(Player, "beginIceSlide", function(orig, self)
        if use_icetrail_and_sound then
            self.iceslide_sound:play()
        end
        self.auto_moving = true
        self.iceslide_in_place = in_place or false
        self.iceslide_stop_timer = 0
        if self.facing == "right" then
            if custom then
                self.sprite:setAnimation("iceslide/right")
            else
                self.sprite:setSprite(self.actor.default.. "/right_2")
            end
        elseif self.facing == "left" then
            if custom then
                self.sprite:setAnimation("iceslide/left")
            else
                self.sprite:setSprite(self.actor.default.. "/left_2")
            end
        elseif self.facing == "up" then
            if custom then
                self.sprite:setAnimation("iceslide/up")
            else
                self.sprite:setSprite(self.actor.default.. "/up_2")
            end
        elseif self.facing == "down" then
            if custom then
                self.sprite:setAnimation("iceslide/down")
            else
                self.sprite:setSprite(self.actor.default.. "/down_2")
            end
        end
    end)

    Utils.hook(Player, "updateIceTrail", function(orig, self)
        self.icetrail_timer = Utils.approach(self.icetrail_timer, 0, DTMULT)

        if self.icetrail_timer == 0 then
            if self.facing == "left" or self.facing == "right" then
                self.icetrail_timer = 3
            else
                self.icetrail_timer = 2
            end

            local trail

            if self.facing == "left" or self.facing == "right" then
                trail = Sprite("effects/icetrail_b")
            else
                trail = Sprite("effects/icetrail")
            end
            trail:play(3/30, true)
            trail:setOrigin(0.5, 0.5)
            trail:setScale(2, 2)
            trail:move(self.x, self.y - self.height/2.5)
            trail.layer = self.layer - 0.01
            if self.facing == "left" then
                trail.flip_x = true
            end
            self.world:addChild(trail)
            Game.world.timer:after(0.5/10, function ()
                trail:fadeOutAndRemove()
            end)
        end
    end)

    Utils.hook(Player, "updateIceSlide", function(orig, self)
        local iceslide_x = self.iceslide_x or 1
        local iceslide_y = self.iceslide_y or 0

        self.run_timer = 200
        local speed = self.walk_speed * 2
            
        self:move(iceslide_x, iceslide_y, speed * DTMULT)
        if use_icetrail_and_sound then
            self:updateIceTrail()
        end
    end)

    Utils.hook(Player, "endIceSlide", function(orig, self, next_state)
        if use_icetrail_and_sound then
            self.iceslide_sound:stop()
        end
        self.sprite:resetSprite()
        self.auto_moving = false
    end)

    Utils.hook(Player, "update", function(orig, self)
        orig(self)

        if self.iceslide_stop_timer > 0 and self.state_manager.state ~= "ICESLIDE" then
            self.iceslide_stop_timer = Utils.approach(self.iceslide_stop_timer, 0, DTMULT)
            if self.iceslide_stop_timer == 0 then
                if use_icetrail_and_sound then
                    self.iceslide_sound:stop()
                end
                self.sprite:resetSprite()
            end
        end
    end)

    -- Follower hooks
    Utils.hook(Follower, "init", function(orig, self, chara, x, y, target)
        orig(self, chara, x, y, target)

        self.state_manager:addState("ICESLIDE", { enter = self.beginIceSlide, leave = self.endIceSlide })
    end)

    Utils.hook(Follower, "beginIceSlide", function(orig, self)
        if Game.world.player.facing == "right" then
            if custom then
                self.sprite:setAnimation("iceslide/right")
            else
                self.sprite:setSprite(self.actor.default.. "/right_2")
            end
        elseif Game.world.player.facing == "left" then
            if custom then
                self.sprite:setAnimation("iceslide/left")
            else
                self.sprite:setSprite(self.actor.default.. "/left_2")
            end
        elseif Game.world.player.facing == "up" then
            if custom then
                self.sprite:setAnimation("iceslide/up")
            else
                self.sprite:setSprite(self.actor.default.. "/up_2")
            end
        elseif Game.world.player.facing == "down" then
            if custom then
                self.sprite:setAnimation("iceslide/down")
            else
                self.sprite:setSprite(self.actor.default.. "/down_2")
            end
        end
    end)

    Utils.hook(Follower, "endIceSlide", function(orig, self)
        self.sprite:resetSprite()
    end)
end

return Lib