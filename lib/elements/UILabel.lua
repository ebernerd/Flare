
require "UIElement"
local UIEventHelpers = require "util.UIEventHelpers"

class "UILabel" extends "UIElement" {
	link = nil;
	textColour = colours.lightGrey;
	text = "";
}

function UILabel:init( x, y, text, link )
	self.super:init( x, y, #text, 1 )
	self.raw.text = text
	self.raw.link = link
end

function UILabel:onMouseEvent( event )
	local mode = UIEventHelpers.clicking.handleMouseEvent( self, event )
	if mode == "click" then
		if self.link and self.link.onLabelPressed then
			self.link:onLabelPressed()
		end
	end
end

function UILabel:onDraw()
	self.canvas:drawText( 0, 0, {
		text = self.text:sub( 1, self.width );
		textColour = self.textColour;
	} )
end

function UILabel:setText( text )
	self.width = #tostring( text )
	self.raw.text = tostring( text )
	self.changed = true
end

function UILabel:setTextColour( textColour )
	self.raw.textColour = textColour
	self.changed = true
end
