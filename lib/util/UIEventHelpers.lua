
require "Event.Event"

local clipboard = require "clipboard"

local UIEventHelpers = {}
UIEventHelpers.clicking = {}
UIEventHelpers.scrollbar = {}
UIEventHelpers.scrollbar.mixin = {}
UIEventHelpers.textSelection = {}

function UIEventHelpers.clicking:handleMouseEvent( event )

	if event.handled then return end

	if event.name == Event.MOUSEDOWN and event:isInArea( 0, 0, self.width, self.height ) then
		self.clicking = {
			button = event.button;
			moved = false;
		}
		event.handled = true
		return "down"

	elseif event.name == Event.MOUSEDRAG and self.clicking then
		if not event.handled and event:isInArea( 0, 0, self.width, self.height ) then
			event.handled = true
		end
		self.clicking.moved = true

	elseif event.name == Event.MOUSEUP and self.clicking then
		if event.button == self.clicking.button then
			event.handled = true
			if event:isInArea( 0, 0, self.width, self.height ) and not self.clicking.moved then
				self.clicking = nil
				return "click"
			end
			self.clicking = nil
			return "up"
		end

	end

end

function UIEventHelpers.scrollbar:active()

	local cw, ch = self:getContentWidth(), self:getContentHeight()
	local dw, dh = self:getDisplayWidth(), self:getDisplayHeight()
	if cw > dw or ch > dh then
		return ch > dh - 1, cw > dw - 1
	end
	return false, false

end

function UIEventHelpers.scrollbar:getBarInfo( side, scrollright, scrollbottom ) -- pos, size
	local traysize = side == "bottom" and self.width - ( scrollright and 1 or 0 ) or self.height - ( scrollbottom and 1 or 0 )
	local contentsize = side == "bottom" and self:getContentWidth() or self:getContentHeight()
	local scale = traysize / contentsize

	local displaysize = ( side == "bottom" and self:getDisplayWidth() - ( scrollright and 1 or 0 ) or self:getDisplayHeight() - ( scrollbottom and 1 or 0 ) )
	local scroll = ( side == "bottom" and self:getHorizontalOffset() or self:getVerticalOffset() )

	return contentsize == 0 and 0 or math.floor( scroll * scale + .5 ), contentsize == 0 and 0 or math.floor( displaysize * scale + .5 )
end

function UIEventHelpers.scrollbar:updateScrollbarPosition( side, pos, scrollright, scrollbottom )
	local traysize = side == "bottom" and self.width - ( scrollright and 1 or 0 ) or self.height - ( scrollbottom and 1 or 0 )
	local contentsize = side == "bottom" and self:getContentWidth() or self:getContentHeight()
	local displaysize = ( side == "bottom" and self:getDisplayWidth() - ( scrollright and 1 or 0 ) or self:getDisplayHeight() - ( scrollbottom and 1 or 0 ) )
	local newpos = math.floor( ( pos - self.scrollbar_mounted ) / traysize * contentsize + .5 )

	if side == "right" then
		self:setVerticalOffset( math.max( 0, math.min( contentsize - displaysize, newpos ) ) )
	else
		self:setHorizontalOffset( math.max( 0, math.min( contentsize - displaysize, newpos ) ) )
	end
end

function UIEventHelpers.scrollbar:handleMouseEvent( event )
	if event.handled then return end

	local x, y = event.x, event.y
	local scrollright, scrollbottom = UIEventHelpers.scrollbar.active( self )

	if event.name == Event.MOUSEDOWN and event:isInArea( 0, 0, self.width, self.height ) then
		if scrollright and x == self.width - 1 then
			local pos, size = UIEventHelpers.scrollbar.getBarInfo( self, "right", scrollright, scrollbottom )
			if y <= pos then
				self.scrollbar_mounted = 0
				self.scrollbar_mounted_side = "right"

			elseif y >= pos + size then
				self.scrollbar_mounted = size - 1
				self.scrollbar_mounted_side = "right"

			else
				self.scrollbar_mounted = y - pos
				self.scrollbar_mounted_side = "right"

			end
			self.scrollbar_scrollright = scrollright
			self.scrollbar_scrollbottom = scrollbottom
			UIEventHelpers.scrollbar.updateScrollbarPosition( self, "right", y, scrollright, scrollbottom )
			event.handled = true

		elseif scrollbottom and y == self.height - 1 then
			local pos, size = UIEventHelpers.scrollbar.getBarInfo( self, "bottom", scrollright, scrollbottom )
			if x < pos then
				self.scrollbar_mounted = 0
				self.scrollbar_mounted_side = "bottom"

			elseif x >= pos + size then
				self.scrollbar_mounted = size - 1
				self.scrollbar_mounted_side = "bottom"

			else
				self.scrollbar_mounted = x - pos
				self.scrollbar_mounted_side = "bottom"

			end
			self.scrollbar_scrollright = scrollright
			self.scrollbar_scrollbottom = scrollbottom
			UIEventHelpers.scrollbar.updateScrollbarPosition( self, "bottom", x, scrollright, scrollbottom )
			event.handled = true

		end
	elseif event.name == Event.MOUSEDRAG and self.scrollbar_mounted then
		local side = self.scrollbar_mounted_side
		UIEventHelpers.scrollbar.updateScrollbarPosition( self, side, side == "right" and y or x, self.scrollbar_scrollright, self.scrollbar_scrollbottom )
		event.handled = true

	elseif event.name == Event.MOUSEUP and self.scrollbar_mounted then
		self.scrollbar_mounted = nil
		self.scrollbar_mounted_side = nil
		event.handled = true
		self.changed = true

	end
end

function UIEventHelpers.scrollbar:handleMouseScroll( event )

	if not event.handled and event.name == Event.MOUSESCROLL and event:isInArea( 0, 0, self.width, self.height ) then

		local right, bottom = UIEventHelpers.scrollbar.active( self )
		local max = self:getContentHeight() - self.height + ( bottom and 1 or 0 )
		if event.button == 1 and self:getVerticalOffset() < max then
			self:setVerticalOffset( math.max( 0, math.min( max, self:getVerticalOffset() + 1 ) ) )
			event.handled = true
		elseif event.button == -1 and self:getVerticalOffset() > 0 then
			self:setVerticalOffset( math.max( 0, math.min( max, self:getVerticalOffset() - 1 ) ) )
			event.handled = true
		end

	end
end

function UIEventHelpers.scrollbar.mixin:getDisplayWidth()
	return self.width
end
function UIEventHelpers.scrollbar.mixin:getDisplayHeight()
	return self.height
end

function UIEventHelpers.scrollbar.mixin:getContentWidth()
	return 0
end
function UIEventHelpers.scrollbar.mixin:getContentHeight()
	return 0
end

function UIEventHelpers.scrollbar.mixin:getHorizontalOffset()
	return -self.ox
end
function UIEventHelpers.scrollbar.mixin:getVerticalOffset()
	return -self.oy
end
function UIEventHelpers.scrollbar.mixin:setHorizontalOffset( scroll )
	self.ox = -scroll
end
function UIEventHelpers.scrollbar.mixin:setVerticalOffset( scroll )
	self.oy = -scroll
end

function UIEventHelpers.textSelection:getCharacter( x, y, lines, alignment, width, height )

	local line = math.max( 1, math.min( #lines, 1 + y - ( ( alignment == "centre" and math.floor( height / 2 - #lines / 2 + .5 ) ) or ( alignment == "bottom" and height - #lines ) or 0 ) ) )
	if not lines[line] then return nil end

	local pos = 0
	for l = 1, line - 1 do
		pos = pos + #lines[l]
	end

	local a = lines[line].alignment
	local char = math.max( 1, math.min( 1 + x - ( ( a == "centre" and math.floor( width / 2 - #lines[line] / 2 + .5 ) ) or ( a == "right" and width - #lines[line] ) or 0 ), #lines[line] ) )

	return pos + char, line, char

end

function UIEventHelpers.textSelection:deselectAll( lines )

	for l = 1, #lines do
		local line = lines[l]
		for c = 1, #line do
			line[c].pixel.selected = false
		end
	end

end

function UIEventHelpers.textSelection:selectRange( lines, line1, char1, line2, char2 )

	if line1 > line2 then
		line1, line2 = line2, line1
		char1, char2 = char2, char1
	elseif line1 == line2 and char1 > char2 then
		char1, char2 = char2, char1
	end
	for l = 1, #lines do
		local line = lines[l]
		for c = 1, #line do
			if l < line1 or l > line2 then
				line[c].pixel.selected = false
			elseif line1 == line2 then
				line[c].pixel.selected = c >= char1 and c <= char2
			elseif l == line1 then
				line[c].pixel.selected = c >= char1
			elseif l == line2 then
				line[c].pixel.selected = c <= char2
			else
				line[c].pixel.selected = true
			end
		end
	end

end

function UIEventHelpers.textSelection:getCharacterLink( x, y, lines, alignment, width, height )

	local line = math.max( 1, math.min( #lines, 1 + y - ( ( alignment == "centre" and math.floor( height / 2 - #lines / 2 + .5 ) ) or ( alignment == "bottom" and height - #lines ) or 0 ) ) )
	if not lines[line] then return nil end

	local pos = 0
	for l = 1, line - 1 do
		pos = pos + #lines[l]
	end

	local a = lines[line].alignment
	local c = 1 + x - ( ( a == "centre" and math.floor( width / 2 - #lines[line] / 2 + .5 ) ) or ( a == "right" and width - #lines[line] ) or 0 ), #lines[line]

	if lines[line][c] then
		return lines[line][c].link
	end

end

function UIEventHelpers.textSelection:handleMouseEvent( event, lines, alignment, width, height )

	-- getCharacterLink( self, event.x - self.ox, event.y - self.oy, lines, alignment, width, height )

	if event.name == Event.MOUSEDOWN then
		UIEventHelpers.textSelection.deselectAll( self, lines )
		if event.handled or not event:isInArea( 0, 0, self.width, self.height ) then
			self.selection = nil
		else
			local pos, line, char = UIEventHelpers.textSelection.getCharacter( self, event.x - self.ox, event.y - self.oy, lines, alignment, width, height )
			if pos then
				self.selection = {
					line1 = line;
					char1 = char;
					pos1 = pos;
					line2 = line;
					char2 = char;
					pos2 = pos;
					holding = true;
					button = event.button;
					initialised = false;
				}
			end
			event.handled = true
		end
		self.changed = true

	elseif not event.handled and event.name == Event.MOUSEUP and self.selection and event.button == self.selection.button then
		self.selection.holding = false
		if not self.selection.initialised then
			if self.onLinkPressed then
				local link = UIEventHelpers.textSelection.getCharacterLink( self, event.x - self.ox, event.y - self.oy, lines, alignment, width, height )
				if link then
					self:onLinkPressed( link )
				end
			end
			self.selection = nil
		end

		event.handled = true

	elseif not event.handled and event.name == Event.MOUSEDRAG and self.selection and self.selection.holding then
		local pos, line, char = UIEventHelpers.textSelection.getCharacter( self, event.x - self.ox, event.y - self.oy, lines, alignment, width, height )
		self.selection.pos2 = pos
		self.selection.char2 = char
		self.selection.line2 = line
		self.selection.initialised = true
		UIEventHelpers.textSelection.selectRange( self, lines, self.selection.line1, self.selection.char1, line, char )
		self.changed = true

	end
end

function UIEventHelpers.textSelection:handleKeyboardEvent( event, stream )
	if not event.handled and event.name == Event.KEYDOWN and self.selection and self.selection.initialised then
		if event:matchesHotkey "ctrl-c" or event:matchesHotkey "ctrl-x" then
			local text = ""
			local rtext = {}
			local pos1, pos2 = self.selection.pos1, self.selection.pos2
			for i = math.min( pos1, pos2 ), math.max( pos1, pos2 ) do
				text = text .. stream[i].pixel[3]
				rtext[#rtext + 1] = stream[i].pixel
			end
			clipboard.put {
				{ "plaintext", text };
				{ "text", rtext };
			}
			event.handled = true
		end
	end
end

return UIEventHelpers
