
require "UIElement"
require "Event.MouseEvent"

local UIDrawingHelpers = require "util.UIDrawingHelpers"
local UIEventHelpers = require "util.UIEventHelpers"

class "UIContainer" extends "UIElement" {
	colour = 1;

	scrollbars = true;
}

UIContainer:mixin( UIEventHelpers.scrollbar.mixin )

function UIContainer:draw()

	if not self.changed then return end

	local canvas = self.canvas
	canvas:clear( self.colour )

	self.super:draw()

	if self.scrollbars then
		UIDrawingHelpers.scrollbar.drawScrollbars( self )
	end

end

function UIContainer:onMouseEvent( event )
	if event:isInArea( 0, 0, self.width, self.height ) then
		UIEventHelpers.scrollbar.handleMouseScroll( self, event )
	end
end

function UIContainer:handle( event )

	if event:typeOf( MouseEvent ) and self.scrollbars then
		UIEventHelpers.scrollbar.handleMouseEvent( self, event )
	end
	return UIElement.handle( self, event )

end

function UIContainer:getContentWidth()
	local max = 0
	for i = 1, #self.children do
		max = math.max( max, self.children[i].x + self.children[i].width )
	end
	return max
end

function UIContainer:getContentHeight()
	local max = 0
	for i = 1, #self.children do
		max = math.max( max, self.children[i].y + self.children[i].height )
	end
	return max
end

function UIContainer:setWidth( width )
	self.super:setWidth( width )
	if self:getContentWidth() + self.ox < self.width then
		self.ox = math.min( 0, self.width - self:getContentWidth() )
	end
end

function UIContainer:setHeight( height )
	self.super:setHeight( height )
	if self:getContentHeight() + self.oy < self.height then
		self.oy = math.min( 0, self.height - self:getContentHeight() )
	end
end

function UIContainer:setColour( colour )
	self.raw.colour = colour
	self.changed = true
end

function UIContainer:setScrollbars( scrollbars )
	self.raw.scrollbars = scrollbars
	self.changed = true
end
