
require "graphics.TermCanvas"

require "Event.Event"

require "UIElement"

class "UITerminal" extends "UIElement" {
	handlesKeyboard = true;
	handlesText = true;
	
	holding = false;
}

function UITerminal:init( x, y, w, h )
	self.super:init( x, y, w, h )

	self.canvas = TermCanvas( w, h )
	self.term = self.canvas:getTermRedirect()
end

function UITerminal:wrap()
	return term.redirect( self.term )
end

function UITerminal:onMouseEvent( event )
	if event.handled or not self.onEvent then return end

	if event.name == Event.MOUSEDOWN and event:isInArea( 0, 0, self.width, self.height ) then
		self.holding = true
		self:onEvent( "mouse_click", event.button, event.x + 1, event.y + 1 )
		event.handled = true
		self.changed = true
	elseif event.name == Event.MOUSESCROLL and event:isInArea( 0, 0, self.width, self.height ) then
		self:onEvent( "mouse_scroll", event.button, event.x + 1, event.y + 1 )
		event.handled = true
		self.changed = true
	elseif event.name == Event.MOUSEUP and self.holding then
		self.holding = false
		self:onEvent( "mouse_up", event.button, event.x + 1, event.y + 1 )
		event.handled = true
		self.changed = true
	elseif event.name == Event.MOUSEDRAG and self.holding then
		self:onEvent( "mouse_drag", event.button, event.x + 1, event.y + 1 )
		event.handled = true
		self.changed = true
	end
end

function UITerminal:onKeyboardEvent( event )
	if event.handled or not self.onEvent then return end

	if event.name == Event.KEYUP then
		self:onEvent( "key_up", keys[event.key] )
		event.handled = true
		self.changed = true
	elseif event.name == Event.KEYDOWN then
		self:onEvent( "key", keys[event.key], event.parameters.isRepeat )
		event.handled = true
		self.changed = true
	end
end

function UITerminal:onTextEvent( event )
	if event.handled or not self.onEvent then return end

	if event.name == Event.TEXT then
		self:onEvent( "char", event.text )
		event.handled = true
		self.changed = true
	elseif event.name == Event.PASTE then
		self:onEvent( "paste", event.text )
		event.handled = true
		self.changed = true
	end
end

function UITerminal:setWidth( width )
	self.super:setWidth( width )
	if self.onEvent then
		self:onEvent "term_resize"
	end
end

function UITerminal:setHeight( height )
	self.super:setHeight( height )
	if self.onEvent then
		self:onEvent "term_resize"
	end
end

function UITerminal:handle( event )

	if event.class == Event and self.onEvent then
		self:onEvent( event.name, unpack( event.parameters ) )
		self.changed = true
	end
	UIElement.handle( self, event )

end

function UITerminal:onDraw()
	if self.canvas.term_cb then
		self.canvas.cursor = {
			x = self.canvas.term_x - 1;
			y = self.canvas.term_y - 1;
			colour = self.canvas.term_tc;
		}
	end
end
