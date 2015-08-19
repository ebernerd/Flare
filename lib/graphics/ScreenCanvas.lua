
require "graphics.Canvas"

local col_lookup = {}
for i = 0, 15 do
	col_lookup[2 ^ i] = ("%x"):format( i )
end
local concat = table.concat
local insert = table.insert
local remove = table.remove
local min, max = math.min, math.max
local unpack = unpack

class "ScreenCanvas" extends "Canvas" {
	colour = 1;
	last = nil;
}

function ScreenCanvas:init( ... )
	self.super:init( ... )
	self.last = {}
	for i = 1, self.width * self.height do
		self.last[i] = {}
	end
end

function ScreenCanvas:setWidth( width )
	local height, buffer, raw = self.height, self.buffer, self.raw
	local last = self.last
	local px = { 0, 1, " " }

	while raw.width < width do
		for i = 1, height do
			insert( last, ( raw.width + 1 ) * i, {} )
			insert( buffer, ( raw.width + 1 ) * i, px )
		end
		raw.width = raw.width + 1
	end

	while raw.width > width do
		for i = height, 1, -1 do
			remove( last, raw.width * i )
			remove( buffer, raw.width * i )
		end
		raw.width = raw.width - 1
	end
end

function ScreenCanvas:setHeight( height )
	local width, buffer, raw = self.width, self.buffer, self.raw
	local last = self.last
	local px = { 0, 1, " " }

	local px = { 0, 1, " " }
	while raw.height < height do
		for i = 1, width do
			last[#last + 1] = {}
			buffer[#buffer + 1] = px
		end
		raw.height = raw.height + 1
	end

	while raw.height > height do
		for i = 1, width do
			last[#last] = nil
			buffer[#buffer] = nil
		end
		raw.height = raw.height - 1
	end
end

function ScreenCanvas:drawToTerminal( term, _x, _y )
	_x = ( _x or 0 ) + self.x
	_y = ( _y or 0 ) + self.y
	local pos = 1
	local width = self.width
	local buffer = self.buffer
	local last = self.last

	local blit, setCursorPos = term.blit, term.setCursorPos

	for y = 1, self.height do
		local px
		local text, bc, tc = {}, {}, {}
		for x = 1, width do
			local pxl = buffer[pos]
			local lst = last[pos]
			if pxl[1] ~= lst[1] or pxl[2] ~= lst[2] or pxl[3] ~= lst[3] then
				if not px then
					px = x
					tx = x
					setCursorPos( _x + x, y + _y )
				end
				bc[#bc + 1] = col_lookup[pxl[1]]
				tc[#tc + 1] = col_lookup[pxl[2]]
				text[#text + 1] = #pxl[3] == 0 and " " or pxl[3]
				last[pos] = buffer[pos]
			elseif px then
				blit( concat( text ), concat( tc ), concat( bc ) )
				px = nil
				text = {}
				tc = {}
				bc = {}
			end
			pos = pos + 1
		end
		blit( concat( text ), concat( tc ), concat( bc ) )
	end
end

function ScreenCanvas:drawToScreen( x, y )
	return self:drawToTerminal( term, x, y )
end
