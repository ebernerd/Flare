
require "UIElement"
require "graphics.Image"
local shader = require "graphics.shader"
local UIEventHelpers = require "util.UIEventHelpers"
local UIDrawingHelpers = require "util.UIDrawingHelpers"

class "UIImage" extends "UIElement" {
	image = nil;
}

UIImage:mixin( UIEventHelpers.scrollbar.mixin )

function UIImage:init( x, y, image )
	self.image = image
	self.super:init( x, y, self.image.width, self.image.height )
end

function UIImage:onMouseEvent( event )
	UIEventHelpers.scrollbar.handleMouseEvent( self, event )
	UIEventHelpers.scrollbar.handleMouseScroll( self, event )
	if UIEventHelpers.clicking.handleMouseEvent( self, event ) == "click" then
		if self.onClick then
			self:onClick()
		end
	end
end

function UIImage:onDraw()
	self.canvas:clear()
	self.image:drawTo( self.canvas, self.ox, self.oy )
	UIDrawingHelpers.scrollbar.drawScrollbars( self )
end

function UIImage:setImage( image )
	if type( image ) == "string" then
		self.raw.image = Image( image )
	else
		self.raw.image = image
	end
	self.changed = true
end

function UIImage:setWidth( width )
	self.super:setWidth( width )
	if self:getContentWidth() + self.ox < self.width then
		self.ox = math.min( 0, self.width - self:getContentWidth() )
	end
end

function UIImage:setHeight( height )
	self.super:setHeight( height )
	if self:getContentHeight() + self.oy < self.height then
		self.oy = math.min( 0, self.height - self:getContentHeight() )
	end
end

function UIImage:getContentWidth()
	return self.image.width
end

function UIImage:getContentHeight()
	return self.image.height
end
