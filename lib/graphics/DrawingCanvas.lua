
--[[

function DrawingCanvas:drawLine( x1, y1, x2, y2, options )
	local dx, dy = x2 - x1, y2 - y1
	if dx == 0 then
		return self:drawVerticalLine( x1, min( y1, y2 ), abs( y2 - y1 ) + 1, options )
	elseif dy == 0 then
		return self:drawHorizontalLine( min( x1, x2 ), y1, abs( x2 - x1 ) + 1, options )
	end

	local m = dy / dx
	local c = y1 - m * x1 + .5
	local step = min( 1, 1 / abs( m ) )

	local drawPoint = self.drawPoint

	drawPoint( self, x1, y1, options )
	drawPoint( self, x2, y2, options )

	for x = min( x1, x2 ), max( x1, x2 ), step do
		drawPoint( self, floor( x + .5 ), floor( m * x + c ), options )
	end
end

function DrawingCanvas:drawWeightlessLine( x1, y1, x2, y2, options )
	local width = self.width
	local px = { options.colour or 1, options.textColour or 1, options.text or " " }
	local pixels = { { floor( y1 + .5 ) * width + x1 + 1, px }, { floor( y2 + .5 ) * width + x2 + 1, px } }
	local dx, dy = x2 - x1, y2 - y1
	if abs( dx ) < .0001 then
		local pos = floor( ( min( y1, y2 ) ) * width + x1 + 1.5 )
		for i = 0, abs( y2 - y1 ) do
			pixels[#pixels + 1] = { pos, px }
			pos = pos + width
		end
	elseif abs( dy ) < .0001 then
		local pos = floor( y1 + .5 ) * width + floor( min( x1, x2 ) + 1.5 )
		for i = 0, abs( x2 - x1 ) do
			pixels[#pixels + 1] = { pos, px }
			pos = pos + 1
		end
	else
		local m = dy / dx
		local c = y1 - m * x1 + .5
		local step = min( 1, 1 / abs( m ) )

		for x = min( x1, x2 ), max( x1, x2 ), step do
			pixels[#pixels + 1] = { floor( m * x + c ) * width + floor( x + 1.5 ), px }
		end
	end

	self:mapPixels( pixels )
end

function DrawingCanvas:drawTriangle( x1, y1, x2, y2, x3, y3, options )
	if options.filled then
		self:drawWeightlessLine( x1, y1, x2, y2, options )
		self:drawWeightlessLine( x1, y1, x3, y3, options )
		self:drawWeightlessLine( x2, y2, x3, y3, options )

		local dx1, dy1 = x2 - x1, y2 - y1
		local m1 = dy1 / dx1
		local c1 = y1 - m1 * x1
		local dx2, dy2 = x3 - x1, y3 - y1
		local m2 = dy2 / dx2
		local c2 = y3 - m2 * x3
		local dx3, dy3 = x3 - x2, y3 - y2
		local m3 = dy3 / dx3
		local c3 = y2 - m3 * x2

		local inf = 1/0
		local nan = inf / inf

		local pixels = {}
		local px = { options.colour or 1, options.textColour or 1, options.text or " " }
		local width = self.width

		for y = floor( min( y1, y2, y3 ) ), ceil( max( y1, y2, y3 ) ) do
			local yo = ( y ) * width
			local a = ( y - c1 ) / m1
			if x1 == x2 then
				a = y >= min( y1, y2 ) and y <= max( y1, y2 ) and x1
			elseif a < min( x1, x2 ) or a > max( x1, x2 ) then
				a = nil
			end
			local b = ( y - c2 ) / m2
			if x1 == x3 then
				b = y >= min( y1, y3 ) and y <= max( y1, y3 ) and x1
			elseif b < min( x1, x3 ) or b > max( x1, x3 ) then
				b = nil
			end
			local c = ( y - c3 ) / m3
			if x2 == x3 then
				c = y >= min( y2, y3 ) and y <= max( y2, y3 ) and x2
			elseif c < min( x2, x3 ) or c > max( x2, x3 ) then
				c = nil
			end
			local v1, v2 = a or b or c, c or b or a
			if v1 and v2 and abs( v1 - v2 ) < .00001 then v2 = b or a or c end
			if v1 then
				for i = floor( min( v1, v2 ) + .5 ), ceil( max( v1, v2 ) - .5 ) do
					pixels[#pixels + 1] = { yo + i, px }
				end
			end
		end

		self:mapPixels( pixels )
	else
		if not options.weight or options.weight == 1 then
			self:drawWeightlessLine( x1, y1, x2, y2, options )
			self:drawWeightlessLine( x1, y1, x3, y3, options )
			self:drawWeightlessLine( x2, y2, x3, y3, options )
		else
			self:drawLine( x1, y1, x2, y2, options )
			self:drawLine( x1, y1, x3, y3, options )
			self:drawLine( x2, y2, x3, y3, options )
		end
	end
end

function DrawingCanvas:drawPolygon( x, y, options )
	if options.filled then
		return error "not yet supported"
	else
		local points = options.points
		x = ( x or 1 ) - 1
		y = ( y or 1 ) - 1
		if #points % 2 == 1 then
			points[#points] = nil
		end
		for i = 1, #points / 2 do
			local p1x, p1y = points[i * 2 - 1], points[i * 2]
			local p2x, p2y = points[i * 2 + 1] or points[1], points[i * 2 + 2] or points[2]
			self:drawLine( p1x + x, p1y + y, p2x + x, p2y + y, options )
		end
	end
end

]]

require "graphics.Canvas"

local max, min, floor, abs = math.max, math.min, math.floor, math.abs

local function getpixel( options )
	return { options.colour or 0, options.textColour or 0, options.character or "" }
end
local function isColourOnly( options )
	return options.textColour == nil and options.character == nil
end

local function pointInPolygon( polyCorners, polyX, polyY, x, y, d )
	local oddNodes = false
	local j = polyCorners

	for i = 1, polyCorners do
		local polyYi = polyY[i]
		if ( ( polyYi < y and polyY[j] >= y ) or ( polyY[j] < y and polyYi >= y ) ) then
			if polyX[i] + d[i] * ( y - polyYi ) < x then
				oddNodes = not oddNodes
			end
		end
		j = i
	end

	return oddNodes
end

local function linewrap( str, w )
	if w <= 0 then
		return "", #str > 1 and str:sub( 2 )
	end
	for i = 1, w + 1 do
		if str:sub( i, i ) == "\n" then
			return str:sub( 1, i - 1 ), str:sub( i + 1 )
		end
	end
	if #str <= w then
		return str
	end
	for i = w + 1, 1, -1 do
		if str:sub( i, i ):find "%s" then
			return str:sub( 1, i - 1 ) .. str:match( "%s+", i ), str:match( "%S.+$", i + 1 )
		end
	end
	return str:sub( 1, w )
end

local function wordwrap( str, w, h )
	local lines, line = {}
	while str do
		line, str = linewrap( str, w )
		lines[#lines + 1] = line
	end
	while h and #lines > math.max( h, 1 ) do
		lines[#lines] = nil
	end
	return lines
end

local function drawPixels( self, pixels, options )
	if isColourOnly( options ) then
		self:mapColour( pixels, options.colour or 1 )
	else
		self:mapStaticPixel( pixels, getpixel( options ) )
	end
end

local function drawRectOutline( self, x, y, width, height, options )
	local pixels = {}
	local swidth, sheight = self.width, self.height
	local weight = options.weight or 1
	local i = 1

	-- horizontal lines
	for n = 0, weight - 1 do
		local pos1 = ( y + n ) * swidth + x + 1
		local pos2 = ( y + height - n - 1 ) * swidth + x + 1
		for m = 1, width do
			if x + m <= swidth and x + m > 0 then
				pixels[i] = pos1
				pixels[i + 1] = pos2
				i = i + 2
			end
			pos1 = pos1 + 1
			pos2 = pos2 + 1
		end
	end
	-- vertical lines
	for n = weight, height - weight - 1 do
		local pos = ( y + n ) * swidth + x
		for m = 0, weight - 1 do
			if x + m < swidth and x + m > 0 then
				pixels[i] = pos + m + 1
				i = i + 1
			end
			if x + width - m < swidth and x + width - m > 0 then
				pixels[i] = pos + width - m
				i = i + 1
			end
		end
	end

	drawPixels( self, pixels, options )
end
local function drawRectFilled( self, x, y, width, height, options )
	local pixels = {}
	local swidth, sheight = self.width, self.height
	local i = 1

	if x < 0 then
		width = width + x
		x = 0
	end
	if x + width >= swidth then
		width = swidth - x
	end

	for _ = 1, height do
		local pos = y * swidth + x + 1
		y = y + 1
		for _ = 1, width do
			pixels[i] = pos
			i = i + 1
			pos = pos + 1
		end
	end
	drawPixels( self, pixels, options )
end

local function drawCircOutline( self, x, y, radius, options )
	local pixels = {}
	local swidth = self.width
	local weight = options.weight or 1
	local i = 1

	local r2 = radius * radius

	for py = 0, radius do
		local ix = floor( ( r2 - py ^ 2 ) ^ .5 * self.correction + .5 )
		local pos11 = ( y - py ) * swidth + x - ix + 1
		local pos21 = ( y + py ) * swidth + x - ix + 1
		local pos12 = ( y - py ) * swidth + x + ix + 1
		local pos22 = ( y + py ) * swidth + x + ix + 1
		for _ = 0, weight do
			pixels[i] = pos11
			pixels[i + 1] = pos21
			pixels[i + 2] = pos12
			pixels[i + 3] = pos22
			pos11 = pos11 + 1
			pos21 = pos21 + 1
			pos12 = pos12 - 1
			pos22 = pos22 - 1
			i = i + 4
		end
	end

	drawPixels( self, pixels, options )
end
local function drawCircFilled( self, x, y, radius, options )
	local pixels = {}
	local swidth = self.width
	local i = 1

	local r2 = radius * radius

	for py = 1, radius do
		local ix = floor( ( r2 - py ^ 2 ) ^ .5 * self.correction + .5 )
		local pos1 = ( y - py ) * swidth + max( 0, x - ix ) + 1
		local pos2 = ( y + py ) * swidth + max( 0, x - ix ) + 1
		for _ = max( 0, x - ix ), min( swidth - 1, x + ix ) do
			pixels[i] = pos1
			pixels[i + 1] = pos2
			pos1 = pos1 + 1
			pos2 = pos2 + 1
			i = i + 2
		end
	end

	local rc = floor( radius * self.correction + .5 )
	local pos = y * swidth + max( 0, x - rc ) + 1
	for _ = max( 0, x - rc ), min( swidth - 1, x + rc ) do
		pixels[i] = pos
		pos = pos + 1
		i = i + 1
	end

	drawPixels( self, pixels, options )
end

class "DrawingCanvas" extends "Canvas" {
	correction = cclite and 1.5 or 1.67;
}

function DrawingCanvas:drawPoint( x, y, options )

	local weight = options.weight or 1
	if weight == 1 then
		self.buffer[y * self.width + x + 1] = getpixel( options )
	else
		self:drawCircle( x, y, weight - 1, {
			colour = colour;
			textColour = textColour;
			character = character;
			filled = true;
		} )
	end

end

function DrawingCanvas:drawRectangle( x, y, width, height, options )

	if options.filled or options.outline == false then
		drawRectFilled( self, x, y, width, height, options )
	else
		drawRectOutline( self, x, y, width, height, options )
	end

end

function DrawingCanvas:drawCircle( x, y, radius, options )

	if options.filled or options.outline == false then
		drawCircFilled( self, x, y, radius, options )
	else
		drawCircOutline( self, x, y, radius, options )
	end

end

function DrawingCanvas:drawLine( x1, y1, x2, y2, options )

	local dx, dy = x2 - x1, y2 - y1
	if abs( dx ) < .0001 then
		return self:drawVerticalLine( x1, min( y1, y2 ), abs( y2 - y1 ) + 1, options )
	elseif abs( dy ) < .0001 then
		return self:drawHorizontalLine( min( x1, x2 ), y1, abs( x2 - x1 ) + 1, options )
	end

	local m = dy / dx
	local c = y1 - m * x1 + .5
	local step = min( 1, 1 / abs( m ) )

	-- draw 2 circles at ends
	-- semicircles, actually

	for x = min( x1, x2 ), max( x1, x2 ), step do
		local y = floor( m * x + c )
		
		-- draw line between x-r and x+r at this y
	end

end

function DrawingCanvas:drawHorizontalLine( x, y, width, options )

	local weight = options.weight or 1
	local swidth = self.width
	local pixels = {}
	local radius = math.floor( weight / 2 - .5 )
	local r2 = radius * radius
	local i = 1

	for r = 0, radius do
		local ix = radius - floor( ( r2 - r ^ 2 ) ^ .5 * self.correction + .5 )
		local pos1 = ( y + r ) * swidth + x + ix + 1
		local pos2 = ( y - r ) * swidth + x + ix + 1
		for _ = x + ix, x + width - ix - 1 do
			pixels[i] = pos1
			pixels[i + 1] = pos2
			pos1 = pos1 + 1
			pos2 = pos2 + 1
			i = i + 2
		end
	end

	drawPixels( self, pixels, options )

end

function DrawingCanvas:drawVerticalLine( x, y, size, options )

	local weight = options.weight or 1
	local swidth = self.width
	local pixels = {}
	local radius = math.floor( weight / 2 - .5 )
	local r2 = radius * radius
	local i = 1

	for _y = 0, size - 1 do
		if _y < radius then

		elseif _y >= size - radius then

		else
			local pos = ( y + _y ) * swidth + x - radius + 1
			for _ = 1, weight do
				pixels[i] = pos
				pos = pos + 1
				i = i + 1
			end
		end
	end

	drawPixels( self, pixels, options )

end

function DrawingCanvas:drawTriangle()

end

function DrawingCanvas:drawTopLeftTriangle()

end

function DrawingCanvas:drawTopRightTriangle()

end

function DrawingCanvas:drawBottomLeftTriangle()

end

function DrawingCanvas:drawBottomRightTriangle()

end

function DrawingCanvas:drawText( x, y, options )

	local bc = options.colour or 0
	local tc = options.textColour or 0
	local pixels = {}
	local width = self.width
	local pos = y * width + x

	for i = math.max( 1, 1 - x ), #options.text do
		if x + i > width then
			break
		end
		pixels[#pixels + 1] = { pos + i, { bc, tc, options.text:sub( i, i ) } }
	end

	self:drawPixels( pixels )
end

function DrawingCanvas:drawWrappedText( x, y, width, height, options )

	local bc = options.colour or 0
	local tc = options.textColour or 0
	local pixels = {}
	local alignment = options.alignment
	local verticalAlignment = options.verticalAlignment
	local lines = wordwrap( options.text, width, height )
	local cwidth = self.width
	local pos = ( ( verticalAlignment == "centre" and math.floor( height / 2 - #lines / 2 + .5 ) or ( verticalAlignment == "bottom" and height - #lines ) or 0 ) + y ) * cwidth + x
	local i = 1

	for line = 1, #lines do
		local offset = ( alignment == "centre" and math.floor( width / 2 - #lines[line] / 2 + .5 ) ) or ( alignment == "right" and width - #lines[line] ) or 0
		for c = 1, #lines[line] do
			pixels[i] = { pos + c + offset, { bc, tc, lines[line]:sub( c, c ) } }
			i = i + 1
		end
		pos = pos + cwidth
	end

	self:drawPixels( pixels )

end

function DrawingCanvas:drawPreformattedText( x, y, width, height, options )

	local pixels = {}
	local verticalAlignment = options.verticalAlignment
	local selectedBC = options.selectedColour or colours.blue
	local selectedTC = options.selectedTextColour or 1
	local lines = options.text
	local cwidth = self.width
	local pos = ( ( ( verticalAlignment == "centre" and math.floor( height / 2 - #lines / 2 + .5 ) ) or ( verticalAlignment == "bottom" and height - #lines ) or 0 ) + y ) * cwidth + x
	local i = 1

	for l = 1, #lines do
		local line = lines[l]
		local offset = ( line.alignment == "centre" and math.floor( width / 2 - #line / 2 + .5 ) ) or ( line.alignment == "right" and width - #line ) or 0
		for c = 1, #line do
			if c + x + offset >= 0 and c + x + offset <= cwidth then
				if line[c][3] ~= "\n" then
					if line[c].selected then
						pixels[i] = { pos + c + offset, { selectedBC, selectedTC, line[c][3] } }
					else
						pixels[i] = { pos + c + offset, line[c] }
					end
					i = i + 1
				end
			end
		end
		pos = pos + cwidth
	end

	self:drawPixels( pixels )

end
