
local c = { { "empty" } }

local clipboard = {}

function clipboard.put( t )
	c = t
end

function clipboard.clear()
	c = { { "empty" } }
end

function clipboard.get( type )
	for i = 1, #c do
		if c[i][1] == type then
			return c[i][2]
		end
	end
end

return clipboard
