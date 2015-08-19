
local insert = table.insert
local remove = table.remove
local min, max = math.min, math.max
local unpack = unpack

class "Canvas" { useSetters = true,
	x = 0;
	y = 0;
	width = 0;
	height = 0;

	colour = 0;

	buffer = nil;

	cursor = nil;
}

function Canvas:init( x, y, width, height )
	self.raw.x = width and x or 0
	self.raw.y = height and y or 0
	self.raw.width = width or x or select( 1, term.getSize() )
	self.raw.height = height or y or select( 2, term.getSize() )

	local buffer = {}
	for i = 1, self.raw.width * self.raw.height do
		buffer[i] = { self.colour, 1, " " }
	end
	self.raw.buffer = buffer

	self.mt.__tostring = self.tostring
end

function Canvas:mapPixels( pixels )
	local buffer = self.buffer
	for i = 1, #pixels do
		buffer[pixels[i][1]] = pixels[i][2]
	end
end

function Canvas:mapColour( pixels, colour )
	local buffer = self.buffer
	local px = { colour or 0, 1, " " }
	for i = 1, #pixels do
		buffer[pixels[i]] = px
	end
end

function Canvas:mapStaticPixel( pixels, px )
	local buffer = self.buffer
	for i = 1, #pixels do
		buffer[pixels[i]] = px
	end
end

function Canvas:drawPixels( pixels )
	local buffer = self.buffer
	for i = 1, #pixels do
		local pos = pixels[i][1]
		if buffer[pos] then
			local bc, tc, char = unpack( pixels[i][2] )
			if bc == 0 then
				bc = buffer[pos][1]
			end
			if tc == 0 or char == "" then
				tc = buffer[pos][2]
				char = buffer[pos][3]
			end
			buffer[pos] = { bc, tc, char }
		end
	end
end

function Canvas:drawColour( pixels, colour )
	if colour == 0 then return end
	return self:mapColour( pixels, colour )
end

function Canvas:drawStaticPixel( pixels, px )
	local buffer = self.buffer
	local tbc, tchar = px.bc == 0, px.tc == 0 or px.char == ""
	if tbc or tchar and not ( tbc and tchar ) then
		local bc, tc, char = unpack( px )
		for i = 1, #pixels do
			local pos = pixels[i]
			buffer[pos] = { tbc and buffer[pos][1] or bc, tchar and buffer[pos][2] or tc, tchar and buffer[pos][3] or char }
		end
	elseif not tbc and not tchar then
		for i = 1, #pixels do
			buffer[pixels[i]] = px
		end
	end
end

function Canvas:clear( colour )
	local buffer = self.buffer
	local px = { colour or self.colour, 1, " " }
	for i = 1, self.width * self.height do
		buffer[i] = px
	end
end

function Canvas:clone()
	local new = self.class( self.width, self.height )
	local b1, b2 = new.buffer, self.buffer
	for i = 1, #b2 do
		b1[i] = b2[i]
	end
	return new
end

function Canvas:cloneAs( class )
	local new = class( self.width, self.height )
	local b1, b2 = new.buffer, self.buffer
	for i = 1, #b2 do
		b1[i] = b2[i]
	end
	return new
end

function Canvas:drawTo( canvas, x, y )
	x = ( x or 0 ) + self.x
	y = ( y or 0 ) + self.y
	local pixels = {}
	local buffer = self.buffer
	local width = self.width
	local swidth = canvas.width

	local i = 1
	local spos = 1

	for py = 0, self.height - 1 do
		local pos = ( py + y ) * swidth + x + 1
		for px = 1, width do
			if px + x > 0 and px + x <= swidth then
				pixels[i] = { pos, buffer[spos] }
				i = i + 1
			end
			pos = pos + 1
			spos = spos + 1
		end
	end

	canvas:drawPixels( pixels )
end

function Canvas:setWidth( width )
	local height, buffer, raw = self.height, self.buffer, self.raw
	local px = { self.colour, 1, " " }

	while raw.width < width do
		for i = 1, height do
			insert( buffer, ( raw.width + 1 ) * i, px )
		end
		raw.width = raw.width + 1
	end

	while raw.width > width do
		for i = height, 1, -1 do
			remove( buffer, raw.width * i )
		end
		raw.width = raw.width - 1
	end
end

function Canvas:setHeight( height )
	local width, buffer, raw = self.width, self.buffer, self.raw
	local px = { self.colour, 1, " " }
	
	while raw.height < height do
		for i = 1, width do
			buffer[#buffer + 1] = px
		end
		raw.height = raw.height + 1
	end

	while raw.height > height do
		for i = 1, width do
			buffer[#buffer] = nil
		end
		raw.height = raw.height - 1
	end
end

function Canvas:tostring()
	return "[Instance] " .. self.class.name .. " (" .. self.x .. "," .. self.y .. " " .. self.width .. "x" .. self.height .. ")"
end
