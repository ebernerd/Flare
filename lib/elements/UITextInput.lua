
require "UIElement"

local clipboard = require "clipboard"

class "UITextInput" extends "UIElement" {
	text = "";
	mask = nil;
	colour = colours.lightGrey;
	textColour = colours.grey;
	focussedColour = colours.white;
	focussedTextColour = colours.grey;
	selectedColour = colours.blue;
	selectedTextColour = colours.white;

	cursor = 0;
	selection = nil;
	focussed = false;

	handlesKeyboard = true;
	handlesText = true;
}

function UITextInput:init( x, y, w )
	self.super:init( x, y, w, 1 )
end

function UITextInput:write( text )

	if self.selection then
		self.raw.text = self.text:sub( 1, math.min( self.selection, self.cursor ) )
		.. text
		.. self.text:sub( math.max( self.selection, self.cursor ) + 2 )
		self.cursor = math.min( self.selection, self.cursor ) + #text
		self.selection = nil

	else
		self.raw.text = self.text:sub( 1, self.cursor ) .. text .. self.text:sub( self.cursor + 1 )
		self.cursor = self.cursor + #text
	end

end

function UITextInput:focusOn()
	if #self.text > 0 then
		self.selection = 0
	end
	self.cursor = #self.text
	self.focussed = true
	self.changed = true
end

function UITextInput:onLabelPressed()
	self:focusOn()
end

function UITextInput:setCursor( cursor )

	self.raw.cursor = math.max( math.min( cursor, #self.text ), 0 )
	if self.cursor + self.ox < 1 then
		self.ox = math.min( -self.cursor, 0 )
	elseif self.cursor + self.ox >= self.width - 1 then
		self.ox = self.width - 1 - self.cursor
	end

end

function UITextInput:onMouseEvent( event )

	if event.name == Event.MOUSEDOWN and event.handled then
		self.focussed = false
		self.changed = true
	end
	if event.handled then return end

	if event.name == Event.MOUSEDOWN then
		if event:isInArea( 0, 0, self.width, self.height ) then
			self.focussed = true
			self.cursor = event.x - self.ox
			event.handled = true
		else
			self.focussed = false
		end
		self.selection = nil
		self.changed = true
	elseif event.name == Event.MOUSEDRAG and self.focussed then
		if not self.selection then
			self.selection = self.cursor
		end
		event.handled = true
		self.cursor = math.max( 0, math.min( event.x - self.ox, #self.text ) )
		self.changed = true
	end

end

function UITextInput:onKeyboardEvent( event )
	if not event.handled and self.focussed and event.name == Event.KEYDOWN then
		if event:matchesHotkey "shift-left" then
			self.selection = self.selection or self.cursor
			self.cursor = self.cursor - 1
			self.changed = true
			event.handled = true
		elseif event:matchesHotkey "shift-right" then
			self.selection = self.selection or self.cursor
			self.cursor = self.cursor + 1
			self.changed = true
			event.handled = true
		elseif event:matchesHotkey "ctrl-a" then
			self.cursor = #self.text
			self.selection = 0
			self.changed = true
			event.handled = true
		elseif event:matchesHotkey "ctrl-c" then
			if self.selection then
				clipboard.put {
					{ "plaintext", self.text:sub( math.min( self.cursor, self.selection ) + 1, math.max( self.cursor, self.selection ) + 1 ) }
				}
			else
				clipboard.put {
					{ "plaintext", self.text }
				}
			end
			event.handled = true
		elseif event:matchesHotkey "ctrl-x" then
			if self.selection then
				clipboard.put {
					{ "plaintext", self.text:sub( math.min( self.cursor, self.selection ) + 1, math.max( self.cursor, self.selection ) + 1 ) }
				}
				self:write ""
			else
				clipboard.put {
					{ "plaintext", self.text }
				}
				self.text = ""
			end
			self.changed = true
			event.handled = true
		elseif event:matchesHotkey "ctrl-b" then
			local text = clipboard.get "plaintext"
			if text then
				self:write( text )
				self.changed = true
			end
			event.handled = true
		elseif event:matchesHotkey "left" then
			if self.selection then
				self.cursor = math.min( self.cursor, self.selection )
				self.selection = nil
			else
				self.cursor = self.cursor - 1
			end
			self.changed = true
			event.handled = true
		elseif event:matchesHotkey "right" then
			if self.selection then
				self.cursor = math.max( self.cursor, self.selection )
				self.selection = nil
			else
				self.cursor = self.cursor + 1
			end
			self.changed = true
			event.handled = true
		elseif event:matchesHotkey "backspace" then
			if self.selection then
				self:write ""
				self.changed = true
			elseif self.cursor > 0 then
				self.cursor = self.cursor - 1
				self.text = self.text:sub( 1, self.cursor ) .. self.text:sub( self.cursor + 2 )
			end
			event.handled = true
		elseif event:matchesHotkey "shift-home" then
			self.selection = self.cursor
			self.cursor = 0
			self.changed = true
			event.handled = true
		elseif event:matchesHotkey "shift-end" then
			self.selection = self.cursor
			self.cursor = #self.text
			self.changed = true
			event.handled = true
		elseif event:matchesHotkey "home" then
			self.cursor = 0
			self.selection = nil
			self.changed = true
			event.handled = true
		elseif event:matchesHotkey "end" then
			self.cursor = #self.text
			self.selection = nil
			self.changed = true
			event.handled = true
		elseif event:matchesHotkey "delete" then
			self.text = self.text:sub( 1, self.cursor) .. self.text:sub( self.cursor + 2 )
			event.handled = true
		elseif event:matchesHotkey "enter" then
			self.focussed = false
			self.changed = true
			if self.onEnter then
				self:onEnter()
			end
			event.handled = true
		elseif event:matchesHotkey "tab" then
			self.focussed = false
			self.changed = true
			if self.onTab then
				self:onTab()
			end
			event.handled = true
		end
	end
end

function UITextInput:onTextEvent( event )
	if not event.handled and self.focussed then
		self:write( event.text )
		self.changed = true
		event.handled = true
	end
end

function UITextInput:onDraw()
	self.canvas:clear( self.focussed and self.focussedColour or self.colour )
	if self.selection then
		local min, max = math.min( self.selection, self.cursor ), math.max( self.selection, self.cursor )

		self.canvas:drawHorizontalLine( self.ox + min, 0, math.abs( self.selection - self.cursor ) + 1, {
			colour = self.selectedColour;
		} )
		self.canvas:drawText( self.ox, 0, {
			text = ( self.mask and self.mask:rep( #self.text ) or self.text ):sub( 1, min );
			textColour = self.focussed and self.focussedTextColour or self.textColour
		} )
		self.canvas:drawText( self.ox + min, 0, {
			text = ( self.mask and self.mask:rep( #self.text ) or self.text ):sub( min + 1, max + 1 );
			textColour = self.selectedTextColour;
		} )
		self.canvas:drawText( self.ox + max + 1, 0, {
			text = ( self.mask and self.mask:rep( #self.text ) or self.text ):sub( max + 2 );
			textColour = self.focussed and self.focussedTextColour or self.textColour
		} )
	else
		self.canvas:drawText( self.ox, 0, {
			text = self.mask and self.mask:rep( #self.text ) or self.text;
			textColour = self.focussed and self.focussedTextColour or self.textColour
		} )
	end
	if self.focussed then
		self.canvas.cursor = {
			x = self.cursor + self.ox;
			y = 0;
			colour = self.focussedTextColour;
		}
	end
end

function UITextInput:setText( text )
	self.raw.text = tostring( text )
	if #text < self.cursor then
		self.cursor = #tostring( text )
	end
	self.changed = true
end

function UITextInput:setMask( mask )
	self.raw.mask = mask
	self.changed = true
end

function UITextInput:setFocussedColour( colour )
	self.raw.focussedColour = colour
	self.changed = true
end

function UITextInput:setFocussedTextColour( textColour )
	self.raw.focussedTextColour = textColour
	self.changed = true
end

function UITextInput:setColour( colour )
	self.raw.colour = colour
	self.changed = true
end

function UITextInput:setTextColour( textColour )
	self.raw.textColour = textColour
	self.changed = true
end

function UITextInput:setSelectedColour( colour )
	self.raw.selectedColour = colour
	self.changed = true
end

function UITextInput:setSelectedTextColour( colour )
	self.raw.selectedTextColour = colour
	self.changed = true
end

function UITextInput:setFocussed( focussed )
	self.raw.focussed = focussed
	self.changed = true
end

function UITextInput:setHeight() end
