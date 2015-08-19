
require "UIElement"
local shader = require "graphics.shader"
local UIEventHelpers = require "util.UIEventHelpers"

class "UIButton" extends "UIElement" {
	colour = 1;
	textColour = colours.grey;
	text = "";
	holding = false;
	noAlign = false;
}

function UIButton:init( x, y, w, h, text )
	self.super:init( x, y, w, h )
	self.text = text
end

function UIButton:onMouseEvent( event )
	local mode = UIEventHelpers.clicking.handleMouseEvent( self, event )
	if mode == "down" or mode == "up" then
		self.holding = mode == "down"
	elseif mode == "click" then
		self.holding = false
		if self.onClick then
			self:onClick()
		end
	end
end

function UIButton:onDraw()
	if self.holding then
		local colour = shader.lighten[self.colour]
		self.canvas:clear( colour == self.colour and shader.darken[colour] or colour )
	else
		self.canvas:clear( self.colour )
	end
	self.canvas:drawWrappedText( 0, 0, self.width, self.height, {
		text = self.text;
		alignment = self.noAlign and "left" or "centre";
		verticalAlignment = self.noAlign and "top" or "centre";
		textColour = self.textColour;
	} )
end

function UIButton:setHolding( state )
	self.raw.holding = state
	self.changed = true
end

function UIButton:setText( text )
	self.raw.text = text == nil and "" or tostring( text )
	self.changed = true
end

function UIButton:setColour( colour )
	self.raw.colour = colour
	self.changed = true
end

function UIButton:setTextColour( textColour )
	self.raw.textColour = textColour
	self.changed = true
end
