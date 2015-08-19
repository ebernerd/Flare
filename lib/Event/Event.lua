
class "Event" {
	handled = false;
	name = "";
	parameters = {};

	MOUSEDOWN = 0;
	MOUSEUP = 1;
	MOUSEDRAG = 2;
	MOUSESCROLL = 3;
	MOUSEPING = 4;
	KEYDOWN = 5;
	KEYUP = 6;
	TEXT = 7;
	PASTE = 8;
}

function Event:init( name, parameters )
	self.name = name
	self.parameters = parameters or {}
end
