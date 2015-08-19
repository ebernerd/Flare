
require "Event.Event"

class "TextEvent" extends "Event" {
	text = "";
}

function TextEvent:init( name, text, parameters )
	self.text = text
	self.super:init( name, parameters )
end
