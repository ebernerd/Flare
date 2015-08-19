
local col_lookup = {}
for i = 0, 15 do
	col_lookup[("%x"):format( i )] = 2 ^ i
	col_lookup[("%X"):format( i )] = 2 ^ i
end
col_lookup[" "] = 0

local function parseStream( text, bc, tc, allowCodes )
	local stream = {}
	local n = 1
	local alignment, tag = "left", nil
	local i = 1
	while i <= #text do
		if text:sub( i, i ) == "@" and allowCodes then
			i = i + 1
			local ctrl = text:sub( i, i )
			if ctrl == "b" then
				bc = col_lookup[text:sub( i + 1, i + 1 )]
				i = i + 2

			elseif ctrl == "t" then
				tc = col_lookup[text:sub( i + 1, i + 1 )]
				i = i + 2

			elseif ctrl == "a" then
				local a = text:sub( i + 1, i + 1 )
				alignment = ( a == "c" and "centre" ) or ( a == "r" and "right" ) or "left"
				i = i + 2

			elseif ctrl == "m" then
				if text:sub( i + 1, i + 1 ) == "-" then
					tag = nil
					i = i + 2
				else
					local t = text:match( "m%((.-)%)", i )
					if t then
						tag = t
						i = i + 3 + #t
					else
						stream[n] = { pixel = { bc, tc, "m" }, tag = tag, alignment = alignment }
						n = n + 1
						i = i + 1
					end
				end

			elseif ctrl == "l" then -- link
				local display, link = text:match( "l%[(.-)%]%((.-)%)", i )
				if display then
					i = i + 5 + #display + #link
					for c = 1, #display do
						stream[n] = { pixel = { bc, tc, display:sub( c, c ) }, tag = tag, alignment = alignment, link = link }
						n = n + 1
					end
				else
					stream[n] = { pixel = { bc, tc, "l" }, tag = tag, alignment = alignment }
					n = n + 1
					i = i + 1
				end

			else
				stream[n] = { pixel = { bc, tc, text:sub( i, i ) }, tag = tag, alignment = alignment }
				n = n + 1
				i = i + 1
			end
		else
			stream[n] = { pixel = { bc, tc, text:sub( i, i ) }, tag = tag, alignment = alignment }
			n = n + 1
			i = i + 1
		end
	end
	return stream
end

local function wrapStreamLine( stream, pos, width )
	for i = pos, pos + math.min( width or #stream - pos, #stream - pos ) do
		if stream[i].pixel[3] == "\n" then
			return i
		end
	end
	if not width or #stream - pos + 1 <= width then
		return #stream
	end
	for i = pos + width, pos, -1 do
		if stream[i].pixel[3]:find "%s" then
			while stream[i + 1].pixel[3]:find "%s" do
				i = i + 1
			end
			return i
		end
	end
	return pos + width - 1
end

local function wrapStream( stream, width, height )
	local lines, pos = {}, 1
	while pos <= #stream do
		local newpos = wrapStreamLine( stream, pos, width )
		lines[#lines + 1] = { pos, newpos }
		pos = newpos + 1
	end
	local t, d = {}, {}
	if height then
		error( height )
	end
	for i = 1, math.min( height or #lines, #lines ) do
		local alignment = stream[lines[i][1]].alignment
		t[i] = { alignment = alignment }
		d[i] = { alignment = alignment }
		local p = 1
		for n = lines[i][1], lines[i][2] do
			t[i][p] = stream[n]
			d[i][p] = stream[n].pixel
			p = p + 1
		end
	end
	return t, d, stream
end

local markup = {}

function markup.parse( text, bc, tc, width, height, allowCodes )
	return wrapStream( parseStream( text, bc, tc, allowCodes ), width, height )
end

return markup
