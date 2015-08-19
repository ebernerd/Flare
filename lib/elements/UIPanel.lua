
require "UIElement"

class "UIPanel" extends "UIElement" {
	colour = 1;
}

function UIPanel:init( x, y, w, h, col )
	self.super:init( x, y, w, h )
	self.colour = col
end

function UIPanel:onDraw()
	self.canvas:clear( self.colour )
end

function UIPanel:onMouseEvent( event )
	if not event.handled and event:isInArea( 0, 0, self.width, self.height ) and event.name == Event.MOUSEDOWN then
		event.handled = true
	end
end

function UIPanel:setColour( colour )
	self.raw.colour = colour
	self.changed = true
end
