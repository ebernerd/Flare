
-- TODO:
	-- add colour support

local UIEventHelpers = require "util.UIEventHelpers"

local UIDrawingHelpers = {}
UIDrawingHelpers.scrollbar = {}

function UIDrawingHelpers.scrollbar:drawScrollbars()

	local scrollright, scrollbottom = UIEventHelpers.scrollbar.active( self )
	local rpos, rsize = UIEventHelpers.scrollbar.getBarInfo( self,  "right", scrollright, scrollbottom, x, y )
	local bpos, bsize = UIEventHelpers.scrollbar.getBarInfo( self, "bottom", scrollright, scrollbottom, x, y )

	if scrollright then
		self.canvas:drawVerticalLine( self.width - 1, 0, scrollbottom and self.height - 1 or self.height, {
			colour = colours.grey;
		} )
		self.canvas:drawVerticalLine( self.width - 1, rpos, rsize, {
			colour = self.scrollbar_mounted_side == "right" and colours.lightBlue or colours.lightGrey
		} )
	end
	if scrollbottom then
		self.canvas:drawHorizontalLine( 0, self.height - 1, scrollright and self.width - 1 or self.width, {
			colour = colours.grey;
		} )
		self.canvas:drawHorizontalLine( bpos, self.height - 1, bsize, {
			colour = self.scrollbar_mounted_side == "bottom" and colours.lightBlue or colours.lightGrey
		} )
	end
	if scrollright and scrollbottom then
		self.canvas:drawPoint( self.width - 1, self.height - 1, {
			colour = colours.grey;
		} )
	end

end

return UIDrawingHelpers
