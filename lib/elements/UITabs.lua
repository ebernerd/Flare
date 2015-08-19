
require "Timer"
require "UIElement"

local function optionWidth( option )
	return #option + 2
end
local function formatOptions( options )
	local t, x = {}, 0
	for i = 1, #options do
		local width = optionWidth( options[i] )
		t[i] = { x = x, width = width, text = options[i] }
		x = x + width + 1
	end
	return t
end
local function getOptionTID( t, x )
	for i = 1, #t do
		if x >= t[i].x and x < t[i].x + t[i].width then
			return t[i], i, x - t[i].x
		end
	end
end

class "UITabs" extends "UIElement" {
	options = {};
	showButtons = false;

	selected = nil;
	selectedOffset = 0;
	selectedWidth = 0;

	colour = 1;
	textColour = colours.grey;
	selectedColour = colours.cyan;
	selectedTextColour = colours.white;
	buttonColour = colours.lightGrey;
	buttonTextColour = colours.white;
	separator = "|";
	seperatorTextColour = colours.lightGrey;

	scrolling = nil;
	scrollingTimer = nil;
}

function UITabs:init( x, y, width, options )
	self.super:init( x, y, width, 1 )
	self.options = options
	self.width = width
end

function UITabs:startScrollingTimer()
	if self.scrolling then
		self.ox = math.min( math.max( self.width - self:getContentWidth() - ( self.showButtons and 2 or 0 ), self.ox + self.scrolling ), 0 )
		self.scrollingTimer = self.scrollingTimer or Timer.queue( .05, function()
			self.scrollingTimer = nil
			self:startScrollingTimer()
		end )
	else
		self.scrollingTimer = nil
	end
end

function UITabs:changeSelection( x, width )
	self.animationHandler:createRoundedTween( "selectedOffset", self, { selectedOffset = x }, self.transitionTime )
	self.animationHandler:createRoundedTween( "selectedWidth", self, { selectedWidth = width }, self.transitionTime )
	if x < -self.ox then
		self.animatedOX = -x
	elseif x + width > self.width - self.ox - ( self.showButtons and 2 or 0 ) then
		self.animatedOX = -( x + width + ( self.showButtons and 2 or 0 ) - self.width )
	end
end

function UITabs:select( index )
	local t = formatOptions( self.options )[index]
	if t then
		self:changeSelection( t.x, t.width )
		if self.selected ~= index and self.onSelect then
			self.raw.selected = index
			self:onSelect( index )
		else
			self.raw.selected = index
		end
	end
end

function UITabs:onDraw()
	self.canvas:clear( self.colour )
	local x = 0
	if self.showButtons then
		self.canvas:drawPoint( 0, 0, {
			colour = self.buttonColour;
			textColour = self.buttonTextColour;
			character = "<";
		} )
		self.canvas:drawPoint( self.width - 1, 0, {
			colour = self.buttonColour;
			textColour = self.buttonTextColour;
			character = ">";
		} )
		x = 1
	end
	local options = formatOptions( self.options )
	for i = 0, self.width - ( self.showButtons and 3 or 1 ) do
		local t, _, d = getOptionTID( options, i - self.ox )
		if t then
			local selected = i - self.ox >= self.selectedOffset and i - self.ox < self.selectedOffset + self.selectedWidth
			self.canvas:drawPoint( x + i, 0, {
				colour = selected and self.selectedColour or self.colour;
				textColour = selected and self.selectedTextColour or self.textColour;
				character = ( d == 0 or d == t.width - 1 ) and " " or t.text:sub( d, d );
			} )
		elseif i - self.ox < self:getContentWidth() then
			local selected = i - self.ox >= self.selectedOffset and i - self.ox < self.selectedOffset + self.selectedWidth
			self.canvas:drawPoint( x + i, 0, {
				colour = selected and self.selectedColour or self.colour;
				textColour = selected and self.selectedTextColour or self.seperatorTextColour;
				character = selected and " " or self.separator;
			} )
		end
	end
end

function UITabs:onMouseEvent( event )
	if event.handled then return end

	if event.name == Event.MOUSEDOWN and event:isInArea( 0, 0, self.width, 1 ) then
		if event.x == 0 then
			self.scrolling = 1
			self:startScrollingTimer()
			event.handled = true
		elseif event.x == self.width - 1 then
			self.scrolling = -1
			self:startScrollingTimer()
			event.handled = true
		else
			self.holding = {
				button = event.button;
				moved = false;
				x = event.x - self.ox;
			}
			event.handled = true
		end
	elseif event.name == Event.MOUSEDRAG and self.holding then
		self.holding.moved = true
		self.ox = math.min( math.max( self.width - self:getContentWidth() - ( self.showButtons and 2 or 0 ), event.x - self.holding.x ), 0 )
		event.handled = true
	elseif event.name == Event.MOUSEUP and self.scrolling then
		self.scrolling = nil
	elseif event.name == Event.MOUSEUP and self.holding then
		if not self.holding.moved then
			local _, i = getOptionTID( formatOptions( self.options ), event.x - self.ox - ( self.showButtons and 1 or 0 ) )
			if i then
				self:select( i )
			end
		end
		self.holding = nil
		event.handled = true
	end
end

function UITabs:getContentWidth()
	local w = 0
	for i = 1, #self.options do
		w = w + 2 + #self.options[i]
	end
	return w + #self.options - 1
end

function UITabs:setHeight() end

function UITabs:setWidth( width )
	self.super:setWidth( width )
	local w = self:getContentWidth()
	if w > width then
		self.showButtons = true
	else
		self.showButtons = false
	end
	if w + self.ox < self.width then
		self.ox = math.min( 0, self.width - w )
	end
end


function UITabs:setSelectedOffset( offset )
	self.raw.selectedOffset = offset
	self.changed = true
end

function UITabs:setSelectedWidth( width )
	self.raw.selectedWidth = width
	self.changed = true
end

function UITabs:setShowButtons( show )
	self.raw.showButtons = show
	self.changed = true
end

function UITabs:setSelected( option )
	return self:select( option )
end

function UITabs:setColour( colour )
	self.raw.colour = colour
	self.changed = true
end

function UITabs:setTextColour( colour )
	self.raw.textColour = colour
	self.changed = true
end

function UITabs:setSelectedColour( colour )
	self.raw.selectedColour = colour
	self.changed = true
end

function UITabs:setSelectedTextColour( colour )
	self.raw.selectedTextColour = colour
	self.changed = true
end

function UITabs:setButtonColour( colour )
	self.raw.buttonColour = colour
	self.changed = true
end

function UITabs:setButtonTextColour( colour )
	self.raw.buttonTextColour = colour
	self.changed = true
end

function UITabs:setSeperator( separator )
	self.raw.separator = separator
	self.changed = true
end

function UITabs:setSeperatorTextColour( colour )
	self.raw.seperatorTextColour = colour
	self.changed = true
end
