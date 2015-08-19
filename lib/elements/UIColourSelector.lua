
require "UIElement"
local UIEventHelpers = require "util.UIEventHelpers"

local log4 = math.log( 4 )

class "UIColourSelector" extends "UIElement" {
	ratio = 4/4; -- 1/16, 2/8, 8/2, 16/1
}

function UIColourSelector:init( x, y, w, h, ratio )
	self.super:init( x, y, w, h )

	self.raw.ratio = ratio
	self.width = w or 8
	self.height = h or 4
end

function UIColourSelector:onMouseEvent( event )
	if UIEventHelpers.clicking.handleMouseEvent( self, event ) == "click" then
		local columns = 2 ^ ( 2 + math.log( self.ratio ) / log4 )
		local rows = 2 ^ ( 2 - math.log( self.ratio ) / log4 )
		local pixelwidth = self.width / columns
		local pixelheight = self.height / rows
		local x = math.floor( event.x / pixelwidth )
		local y = math.floor( event.y / pixelheight )
		local index = x + y * columns
		if self.onSelect then
			self:onSelect( 2 ^ index, index )
		end
	end
end

function UIColourSelector:onDraw()
	local columns = 2 ^ ( 2 + math.log( self.ratio ) / log4 )
	local rows = 2 ^ ( 2 - math.log( self.ratio ) / log4 )
	local pixelwidth = self.width / columns
	local pixelheight = self.height / rows
	local x, y = 0, 0
	for i = 0, 15 do
		self.canvas:drawRectangle( x, y, pixelwidth, pixelheight, {
			colour = 2 ^ i;
			filled = true;
		} )
		x = x + pixelwidth
		if x == self.width then
			x = 0
			y = y + pixelheight
		end
	end
end

function UIColourSelector:setWidth( width )
	local columns = 2 ^ ( 2 + math.log( self.ratio ) / log4 )
	self.super:setWidth( math.max( columns, math.floor( width / columns ) * columns ) )
end
function UIColourSelector:setHeight( height )
	local rows = 2 ^ ( 2 - math.log( self.ratio ) / log4 )
	self.super:setHeight( math.max( rows, math.floor( height / rows ) * rows ) )
end

function UIColourSelector:setRatio( ratio )
	if ratio == 1/16 or ratio == 2/8 or ratio == 4/4 or ratio == 8/2 or ratio == 16/1 then
		self.raw.ratio = ratio
		self.width = self.width
		self.height = self.height
	else
		error( "unsupported ratio", 3 )
	end
end
