
require "UIElement"
local UIEventHelpers = require "util.UIEventHelpers"

class "UICheckbox" extends "UIElement" {
	colour = colours.lightGrey;
	checkColour = colours.black;
	check = "x";
	toggled = false;
}

function UICheckbox:init( x, y )
	self.super:init( x, y, 1, 1 )
end

function UICheckbox:onLabelPressed()
	self.toggled = not self.toggled
	if self.onToggle then
		self:onToggle()
	end
end

function UICheckbox:onMouseEvent( event )

	if UIEventHelpers.clicking.handleMouseEvent( self, event ) == "click" then
		self.toggled = not self.toggled
		if self.onToggle then
			self:onToggle()
		end
	end

end

function UICheckbox:onDraw()

	self.canvas:clear( self.colour )
	self.canvas:drawPoint( 0, 0, {
		colour = self.colour
	} )
	if self.toggled then
		self.canvas:drawText( 0, 0, {
			textColour = self.checkColour;
			text = self.check;
		} )
	end

end

function UICheckbox:setWidth() end
function UICheckbox:setHeight() end

function UICheckbox:setHolding( state )
	self.raw.holding = state
	self.changed = true
end

function UICheckbox:setColour( colour )
	self.raw.colour = colour
	self.changed = true
end

function UICheckbox:setCheckColour( colour )
	self.raw.checkColour = colour
	self.changed = trur
end

function UICheckbox:setCheck( check )
	self.raw.check = tostring( check )
	self.changed = true
end

function UICheckbox:setToggled( bool )
	self.raw.toggled = bool
	self.changed = true
end
