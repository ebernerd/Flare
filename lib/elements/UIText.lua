
require "UIElement"

local markup = require "util.markup"
local UIDrawingHelpers = require "util.UIDrawingHelpers"
local UIEventHelpers = require "util.UIEventHelpers"

class "UIText" extends "UIElement" {
	colour = 1;
	textColour = colours.grey;
	text = "";
	selectedColour = colours.blue;
	selectedTextColour = colours.white;

	alignment = "top";
	wrap = true;
	selectable = true;

	internalWidth = nil;
	internalHeight = nil;

	formattedText = nil;
	formattedTextInfo = nil;
	handlesKeyboard = true;
}

UIText:mixin( UIEventHelpers.scrollbar.mixin )

function UIText:init( x, y, w, h, text )
	self.super:init( x, y, w, h )
	self.text = text
end

function UIText:onMouseEvent( event )
	
	UIEventHelpers.scrollbar.handleMouseEvent( self, event )
	UIEventHelpers.scrollbar.handleMouseScroll( self, event )

	if self.selectable then
		UIEventHelpers.textSelection.handleMouseEvent( self, event, self.formattedTextInfo, self.alignment, math.max( self:getContentWidth(), self.internalWidth or self.width ), math.max( self:getContentHeight(), self.internalHeight or self.height ) )
	end
end

function UIText:onKeyboardEvent( event )
	if self.selectable then
		UIEventHelpers.textSelection.handleKeyboardEvent( self, event, self.stream )
	end
end

function UIText:onDraw()
	self.canvas:clear( self.colour )
	self.canvas:drawPreformattedText( self.ox, self.oy, math.max( self:getContentWidth(), self.internalWidth or self.width ), math.max( self:getContentHeight(), self.internalHeight or self.height ), {
		text = self.formattedText;
		verticalAlignment = self.alignment;
		textColour = self.textColour;
		selectedColour = self.selectedColour;
		selectedTextColour = self.selectedTextColour;
	} )

	UIDrawingHelpers.scrollbar.drawScrollbars( self )
end

function UIText:updateText()
	local a, b, c = markup.parse( self.text, self.colour, self.textColour, self.wrap and ( self.internalWidth or self.width ), self.wrap and self.internalHeight, true )
	self.formattedTextInfo, self.formattedText, self.stream = a, b, c
	self.changed = true
end

function UIText:getContentWidth()
	local max = 0
	for i = 1, #self.formattedText do
		max = math.max( #self.formattedText[i] - ( self.formattedText[i][#self.formattedText[i]][3] == "\n" and 1 or 0 ), max )
	end
	return max
end

function UIText:getContentHeight()
	return #self.formattedText
end

function UIText:setText( text )
	self.raw.text = tostring( text )
	self:updateText()
end

function UIText:setColour( colour )
	self.raw.colour = colour
	self:updateText()
end

function UIText:setTextColour( textColour )
	self.raw.textColour = textColour
	self:updateText()
end

function UIText:setWrap( wrap )
	self.raw.wrap = wrap
	self:updateText()
end

function UIText:setInternalWidth( width )
	self.raw.internalWidth = width
	self:updateText()
end

function UIText:setInternalHeight( height )
	self.raw.internalHeight = height
	self:updateText()
end

function UIText:setWidth( width )
	self.super:setWidth( width )
	self:updateText()
	if self:getContentWidth() + self.ox < self.width then
		self.ox = math.min( 0, self.width - self:getContentWidth() )
	end
end

function UIText:setHeight( height )
	self.super:setHeight( height )
	self:updateText()
	if self:getContentHeight() + self.oy < self.height then
		self.oy = math.min( 0, self.height - self:getContentHeight() )
	end
end

function UIText:setAlignment( alignment )
	self.raw.alignment = alignment
	self.changed = true
end

function UIText:setSelectedColour( colour )
	self.raw.selectedColour = colour
	self.changed = true
end

function UIText:setSelectedTextColour( colour )
	self.raw.selectedTextColour = colour
	self.changed = true
end
