
require "Event.Event"

class "MouseEvent" extends "Event" { useSetters = true;
	x = 0;
	y = 0;
	button = 1;

	parent = nil;

	within = true;

	BUTTONLEFT = 1;
	BUTTONRIGHT = 2;
	BUTTONMIDDLE = 3;
}

function MouseEvent:init( name, x, y, button, within, parameters )
	self.x = x
	self.y = y
	self.button = button
	self.within = within
	self.super:init( name, parameters )
	self.mt.__tostring = self.tostring
end

function MouseEvent:clone( x, y, within )
	local new = MouseEvent( self.name, self.x - x, self.y - y, self.button, self.within and within, self.parameters )
	new.parent = self
	new.handled = self.handled
	return new
end

function MouseEvent:isInArea( x, y, width, height )
	local sx, sy = self.x, self.y
	return self.within and sx >= x and sy >= y and sx < x + width and sy < y + height
end

function MouseEvent:setHandled( handled )
	self.handled = handled
	if handled and self.parent then
		self.parent.handled = true
	end
end

function MouseEvent:tostring()
	return "[Instance] MouseEvent[" .. self.button .. "] @" .. self.x .. "," .. self.y
end
