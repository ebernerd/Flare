
require "graphics.Canvas"

local col = {}
for i = 0, 15 do
	col[("%x"):format( i )] = 2 ^ i
	col[2 ^ i] = ("%x"):format( i )
end

class "Image" extends "Canvas" {
	filepath = "";
}

function Image:init( filepath )
	self.super:init( 0, 0 )
	if not fs.exists( filepath ) or fs.isDir( filepath ) then
		error( "path is not a file", 3 )
	end
	self.filepath = filepath
	if filepath:find "%.nfp$" then
		self:loadNFP()
	else
		self:load()
	end
end

function Image:loadNFP()
	local lines = {}
	local h = fs.open( self.filepath, "r" )
	local content = h.readAll()
	h.close()
	for line in content:gmatch "[^\n]+" do
		lines[#lines + 1] = line
	end

	local width, height = #( lines[1] or "" ), #lines
	self.width = width
	self.height = height

	local pixels = {}
	local i = 1
	for y = 1, #lines do
		local pos = ( y - 1 ) * width
		for x = 1, #lines[y] do
			pixels[i] = { pos + x, { col[lines[y]:sub( x, x )] or 0, 1, " " } }
			i = i + 1
		end
	end
	self:mapPixels( pixels )
end

function Image:load()

end

function Image:saveNFP()

end

function Image:save()

end
