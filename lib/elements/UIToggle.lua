
require "UIElement"
local shader = require "graphics.shader"
local UIEventHelpers = require "util.UIEventHelpers"

class "UIToggle" extends "UIElement" {
	colour = colours.grey;
	activeColour = colours.green;
	inactiveColour = colours.red;
	holding = false;
	toggled = false;
}

function UIToggle:init( x, y, w, h )
	self.super:init( x, y, w, h )
end

function UIToggle:onLabelPressed()
	self.toggled = not self.toggled
	if self.onToggle then
		self:onToggle()
	end
end

function UIToggle:onMouseEvent( event )

	local mode = UIEventHelpers.clicking.handleMouseEvent( self, event )
	if mode == "down" or mode == "up" then
		self.holding = mode == "down"

	elseif mode == "click" then
		self.holding = false
		self.toggled = not self.toggled
		if self.onToggle then
			self:onToggle()
		end
	end

end

function UIToggle:onDraw()

	self.canvas:clear( self.colour )
	local size = math.floor( self.width * 1 / 3 )
	local x = ( self.holding and math.floor( self.width / 2 - size / 2 ) ) or ( not self.toggled and 0 ) or self.width - size
	local colour = self.toggled and self.activeColour or self.inactiveColour

	self.canvas:drawRectangle( x, 0, size, self.height, {
		colour = colour;
		filled = true;
	} )

end

function UIToggle:setWidth( width )
	self.width = math.min( width, 4 )
end

function UIToggle:setHolding( state )
	self.raw.holding = state
	self.changed = true
end

function UIToggle:setColour( colour )
	self.raw.colour = colour
	self.changed = true
end

function UIToggle:setActiveColour( colour )
	self.raw.activeColour = colour
	self.changed = true
end

function UIToggle:setInactiveColour( colour )
	self.raw.inactiveColour = colour
	self.changed = true
end

function UIToggle:setToggled( bool )
	self.raw.toggled = bool
	self.changed = true
end
