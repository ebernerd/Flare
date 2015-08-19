
require "UIElement"
require "UIContainer"
require "Event.MouseEvent"

local UIDrawingHelpers = require "util.UIDrawingHelpers"
local UIEventHelpers = require "util.UIEventHelpers"

class "UIWindow" extends "UIElement" {
	minWidth = 15;
	minHeight = 6;
	maxWidth = term.getSize();
	maxHeight = select( 2, term.getSize() );

	title = "Window";
	titleColour = colours.cyan;
	titleTextColour = colours.white;

	shadowColour = colours.grey;

	closeable = true;
	resizeable = true;
	moveable = true;

	content = nil;
}

UIWindow:mixin( UIEventHelpers.scrollbar.mixin )

function UIWindow:init( x, y, w, h )
	self.super:init( x, y, w, h )
	self.content = self:addChild( UIContainer( 0, 1, w - 1, h - 2 ) )
end

function UIWindow:onMouseEvent( event )
	if event.handled then return end

	if event.name == Event.MOUSEDOWN and event:isInArea( 0, 0, self.width, self.height ) then

		if event.y == 0 and event.x == self.width - 2 and self.closeable then
			if self.onClose then
				self:onClose()
			end
			self:remove()
		elseif event.x == self.width - 1 and event.y == self.height - 1 and self.resizeable then
			self.dragging = {
				button = event.button;
				mode = "resize";
			}

		elseif event.y == 0 and event.x < self.width - 1 and self.moveable then
			self.dragging = {
				x = event.x;
				y = event.y;
				button = event.button;
				mode = "move";
			}

		end
		event.handled = true

	elseif event.name == Event.MOUSEDRAG and self.dragging and self.dragging.mode == "move" then
		self.x = self.x + event.x - self.dragging.x
		self.y = self.y + event.y - self.dragging.y
		if self.onMove then
			self:onMove()
		end

	elseif event.name == Event.MOUSEDRAG and self.dragging and self.dragging.mode == "resize" then
		self.width = event.x + 1
		self.height = event.y + 1
		if self.onResize then
			self:onResize()
		end

	elseif event.name == Event.MOUSEUP and self.dragging then
		if event.button == self.dragging.button then
			event.handled = true
			self.dragging = nil
		end

	end
end

function UIWindow:onDraw()

	self.canvas:clear()
	self.canvas:drawVerticalLine( self.width - 1, 1, self.height - 1, {
		colour = self.shadowColour;
	} )
	self.canvas:drawHorizontalLine( 1, self.height - 1, self.width - 1, {
		colour = self.shadowColour;
	} )
	self.canvas:drawHorizontalLine( 0, 0, self.width - 1, {
		colour = self.titleColour
	} )
	self.canvas:drawText( 0, 0, {
		text = self.title;
		textColour = self.titleTextColour;
	} )
	if self.closeable then
		self.canvas:drawPoint( self.width - 2, 0, {
			character = "x";
			colour = colours.red;
			textColour = colours.white;
		} )
	end

end

function UIWindow:handle( event )

	if not event.handled and event:typeOf( MouseEvent ) and event.name == Event.MOUSEDOWN and event:isInArea( 0, 0, self.width, self.height ) then
		local parent = self.parent
		if parent and parent.children[#parent.children] ~= self then
			parent:addChild( self )
		end
	end
	return UIElement.handle( self, event )

end

function UIWindow:setWidth( width )
	self.super:setWidth( math.max( math.min( width, self.maxWidth ), self.minWidth ) )
	self.content.width = self.width - 1
end

function UIWindow:setHeight( height )
	self.super:setHeight( math.max( math.min( height, self.maxHeight ), self.minHeight ) )
	self.content.height = self.height - 2
end

function UIWindow:setTitle( title )
	self.raw.title = tostring( title )
	self.changed = true
end

function UIWindow:setTitleColour( colour )
	self.raw.titleColour = colour
	self.changed = true
end

function UIWindow:setTitleTextColour( colour )
	self.raw.titleTextColour = colour
	self.changed = true
end

function UIWindow:setCloseable( closeable )
	self.raw.closeable = closeable
	self.changed = true
end

function UIWindow:setShadowColour( colour )
	self.raw.shadowColour = colour
	self.changed = true
end

function UIWindow:setMinWidth( width )
	if width > self.width then
		self.width = width
	end
	self.raw.minWidth = width
end

function UIWindow:setMaxWidth( width )
	if width < self.width then
		self.width = width
	end
	self.raw.maxWidth = width
end

function UIWindow:setMinHeight( height )
	if height > self.height then
		self.height = height
	end
	self.raw.minHeight = height
end

function UIWindow:setMaxHeight( height )
	if height < self.height then
		self.height = height
	end
	self.raw.maxHeight = height
end
