
require "UIElement"

local UIDrawingHelpers = require "util.UIDrawingHelpers"
local UIEventHelpers = require "util.UIEventHelpers"

class "UIMultilineTextInput" extends "UIElement" {
	lines = {};
	fmtLines = {};

	cx = 1;
	cy = 1;

	selected = false;
	scx = 1;
	scy = 1;

	focussed = true;

	handlesKeyboard = true;
	handlesText = true;
}

function UIMultilineTextInput:init( x, y, width, height )
	self.super:init( x, y, width, height )
	self.lines = {}
end

function UIMultilineTextInput:recolourLine( i )
	if self.lines[i] then
		local f = self.colourer or function( _, line )
			local t = {}
			for i = 1, #line do
				t[i] = { colours.white, colours.grey, line:sub( i, i ) }
			end
			return t
		end
		self.fmtLines[i] = f( self, self.lines[i] )
	end
end

function UIMultilineTextInput:setCursor( x, y )
	
end

function UIMultilineTextInput:write( text )

	if self.selected then
		local y1, y2, x1, x2 = self.cy, self.scy, self.cx, self.scx
		if y1 > y1 or ( y1 == y2 and x1 > x2 ) then
			y2, y1, x2, x1 = y1, y2, x1, x2
		end

		self.lines[y1] = self.lines[y1]:sub( 1, x1 - 1 ) .. self.lines[y2]:sub( x2 )

		for i = 1, y2 - y1 do
			table.remove( self.lines, y1 + i )
			table.remove( self.fmtLines, y1 + i )
		end

		self.selected = false
		self.cy = y1
		self.cx = x1
	end

	local newlines = select( 2, text:gsub( "\n", "" ) )

	for i = 1, newlines do
		table.insert( self.lines, self.cy + 1, "" )
		table.insert( self.fmtLines, self.cy + 1, {} )
	end

	local ending = self.lines[self.cy]:sub( self.cx )
	self.lines[self.cy] = self.lines[self.cy]:sub( 1, self.cx - 1 )
	local i = self.cy

	for line in text:gmatch "[^\n]+" do
		self.lines[i] = self.lines[i] .. line
		i = i + 1
	end
	self.lines[self.cy + newlines] = self.lines[self.cy + newlines] .. ending

	for i = 0, newlines do
		self:recolourLine( self.cy + i )
	end

	self.cy = self.cy + newlines
	if newlines > 0 then self.cx = 1 end
	self.cx = self.cx + #( text:match "^.*\n(.-)$" or text )

end

function UIMultilineTextInput:onKeyboardEvent( event )
	do return end
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

function UIMultilineTextInput:onTextEvent( event )
	if not event.handled and self.focussed then
		self:write( event.text )
		self.changed = true
		event.handled = true
	end
end

function UIMultilineTextInput:onDraw()

	self.canvas:clear( colours.lightGrey )
	self.canvas:drawPreformattedText( self.ox, self.oy, self.width, self.height, {
		text = self.fmtLines;
		verticalAlignment = "top";
		selectedColour = self.selectedColour;
		selectedTextColour = self.selectedTextColour;
	} )

	-- UIDrawingHelpers.scrollbar.drawScrollbars( self )

end

function UIMultilineTextInput:setText( text )
	self.lines = {}
	self.fmtLines = {}
	for line in text:gmatch "[^\n]+" do
		self.lines[#self.lines + 1] = line
		self.fmtLines[#self.fmtLines + 1] = {}
	end

	for i = 1, #self.lines do
		self:recolourLine( i )
	end
end

function UIMultilineTextInput:setTextColourer( colourer )

end
