
require "graphics.Canvas"

local col_lookup = {}
for i = 0, 15 do
	col_lookup[("%x"):format( i ):byte()] = 2 ^ i
end

local isColour = term.isColour()

class "TermCanvas" extends "Canvas" {
	colour = 32768;
	term_bc = 32768;
	term_tc = 1;
	term_x = 1;
	term_y = 1;
	term_cb = false;
}

function TermCanvas:getTermRedirect()
	local term = {}

	function term.write( s )
		s = tostring( s )
		local pos = ( self.term_y - 1 ) * self.width + self.term_x
		local pixels = {}
		local bc, tc = self.term_bc, self.term_tc
		for i = 1, math.min( #s, self.width - self.term_x + 1 ) do
			pixels[#pixels + 1] = { pos, { bc, tc, s:sub( i, i ) } }
			pos = pos + 1
		end
		self.term_x = self.term_x + #s
		self:mapPixels( pixels )
	end
	function term.blit( s, t, b )
		if #s ~= #b or #s ~= #t then
			return error "arguments must be the same length"
		end
		local pixels = {}
		local pos = ( self.term_y - 1 ) * self.width + self.term_x
		for i = 1, math.min( #s, self.width - self.term_x + 1 ) do
			pixels[#pixels + 1] = { pos, { col_lookup[b:byte( i )], col_lookup[t:byte( i )], s:sub( i, i ) } }
			pos = pos + 1
		end
		self.term_x = self.term_x + #s
		self:mapPixels( pixels )
	end

	function term.clear()
		self:clear( self.term_bc )
	end
	function term.clearLine()
		local px = { self.term_bc, 1, " " }
		local pixels = {}
		local offset = self.width * ( self.term_y - 1 )
		for i = 1, self.width do
			pixels[#pixels + 1] = { i + offset, px }
		end
		self:mapPixels( pixels )
	end

	function term.getCursorPos()
		return self.term_x, self.term_y
	end
	function term.setCursorPos( x, y )
		self.term_x = math.floor( x )
		self.term_y = math.floor( y )
	end

	function term.setCursorBlink( state )
		self.term_cb = state
	end

	function term.getSize()
		return self.width, self.height
	end

	function term.scroll( n )
		local buffer = self.buffer
		local offset = n * self.width
		local n, f, s = n < 0 and self.width * self.height or 1, n < 0 and 1 or self.width * self.height, n < 0 and -1 or 1
		local pixels = {}
		local px = { self.term_bc, self.term_tc, " " }
		for i = n, f, s do
			pixels[#pixels + 1] = { i, buffer[i + offset] or px }
		end
		self:mapPixels( pixels )
	end

	function term.isColour()
		return isColour
	end

	function term.setBackgroundColour( colour )
		self.term_bc = colour
	end
	function term.setTextColour( colour )
		self.term_tc = colour
	end
	function term.getBackgroundColour()
		return self.term_bc
	end
	function term.getTextColour()
		return self.term_tc
	end

	term.isColor = term.isColour
	term.setBackgroundColor = term.setBackgroundColour
	term.setTextColor = term.setTextColour
	term.getBackgroundColor = term.getBackgroundColour
	term.getTextColor = term.getTextColour

	return term
end

function TermCanvas:drawTo( other, x, y )
	self.super:drawTo( other, x, y )
	if self.term_cb then
		other.term_cb = true
		other.term_x = self.term_x + ( x or 1 ) - 1
		other.term_y = self.term_y + ( y or 1 ) - 1
	end
end

function TermCanvas:redirect()
	return term.redirect( self:getTermRedirect() )
end

function TermCanvas:wrap( f )
	local old = self:redirect()
	f()
	term.redirect( old )
end
