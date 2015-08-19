
require "UIElement"
local UIEventHelpers = require "util.UIEventHelpers"

local groups = { [0] = {} }

class "UIRadioButton" extends "UIElement" {
	colour = colours.lightGrey;
	checkColour = colours.black;
	check = "@"; --set to " " for a whole pixel
	group = 0;
	toggled = false;
}

function UIRadioButton:init( x, y )
	self.super:init( x, y, 1, 1 )
	groups[0][#groups[0] + 1] = self
end

function UIRadioButton:onLabelPressed()
	self.toggled = not self.toggled
end

function UIRadioButton:onMouseEvent( event )

	if UIEventHelpers.clicking.handleMouseEvent( self, event ) == "click" then
		self.holding = false
		self.toggled = not self.toggled
	end

end

function UIRadioButton:onDraw()

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

function UIRadioButton:setWidth() end
function UIRadioButton:setHeight() end

function UIRadioButton:setHolding( state )
	self.raw.holding = state
	self.changed = true
end

function UIRadioButton:setColour( colour )
	self.raw.colour = colour
	self.changed = true
end

function UIRadioButton:setCheckColour( colour )
	self.raw.checkColour = colour
	self.changed = trur
end

function UIRadioButton:setCheck( check )
	self.raw.check = check
	self.changed = true
end

function UIRadioButton:setToggled( toggled )
	if toggled then
		for i = 1, #groups[self.group] do
			groups[self.group][i].toggled = false
		end
	end
	local t = self.toggled
	self.raw.toggled = toggled
	if toggled ~= t and self.onToggle then
		self:onToggle()
	end
	self.changed = true
end

function UIRadioButton:setGroup( group )
	for i = #groups[self.group], 1, -1 do
		if groups[self.group][i] == self then
			table.remove( groups[self.group], i )
		end
	end
	if #groups[self.group] == 0 then
		groups[self.group] = nil
	end
	groups[group] = groups[group] or {}
	groups[group][#groups[group] + 1] = self
	self.raw.group = group
end
