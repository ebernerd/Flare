
require "Tween"
require "Timer"

local function kickTimer( self )
	local time = os.clock()
	self.updateTimer = self.updateTimer or Timer.queue( .05, function()
		self:update( os.clock() - time )
	end )
end

class "UIAnimationHandler" {
	tweens = {};
}

function UIAnimationHandler:init()
	self.tweens = {}
end

function UIAnimationHandler:killTween( label )
	local tweens = self.tweens
	for i = 1, #tweens do
		if tweens[i].label == label then
			table.remove( tweens, i )
			break
		end
	end
end

function UIAnimationHandler:createTween( label, object, target, duration, easing )
	self:killTween( label )
	kickTimer( self )

	local tween = Tween( object, target, duration, easing )
	tween.label = label
	self.tweens[#self.tweens + 1] = tween
	return tween
end

function UIAnimationHandler:createRoundedTween( label, object, target, duration, easing )
	self:killTween( label )
	kickTimer( self )

	local tween = Tween( object, target, duration, easing )
	tween.round = true
	tween.label = label
	self.tweens[#self.tweens + 1] = tween

	return tween
end

function UIAnimationHandler:update( dt )
	self.updateTimer = nil
	local tweens = self.tweens
	for i = #tweens, 1, -1 do
		if tweens[i]:update( dt ) then
			if tweens[i].onFinish then
				tweens[i]:onFinish()
			end
			table.remove( tweens, i )
		end
	end
	if #tweens > 0 then
		kickTimer( self )
	end
end
