
require "Event.Event"

class "KeyboardEvent" extends "Event" {
	key = 0;
	modifiers = {};
}

function KeyboardEvent:init( name, key, modifiers, parameters )
	self.key = keys.getName( key )
	self.modifiers = modifiers
	self.super:init( name, parameters )
end

function KeyboardEvent:matchesHotkey( hotkey )
	for segment in ( hotkey:match "^(.+)%-" or "" ):gmatch "[^%-]+" do
		if segment == "ctrl" and not self.modifiers.leftCtrl and not self.modifiers.rightCtrl then
			return false
		elseif segment == "shift" and not self.modifiers.leftShift and not self.modifiers.rightShift then
			return false
		elseif segment ~= "ctrl" and segment ~= "shift" and not self.modifiers[segment] then
			return false
		end
	end
	return self.key == hotkey:gsub( ".+%-", "" )
end
