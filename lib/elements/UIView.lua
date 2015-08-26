
require "UIElement"

class "UIView" extends "UIElement" {
	shortcuts = {};
}

function UIView:init( ... )
	self.shortcuts = {}
	return self.super:init( ... )
end

function UIView:createShortcut( identifier, shortcut, action )
	if self:shortcutExists( identifier ) then
		self:setShortcut( identifier, shortcut )
		self:setShortcutAction( identifier, action )
	else
		self.shortcuts[#self.shortcuts + 1] = { identifier, shortcut, action }
	end
end

function UIView:shortcutExists( identifier )
	for i = 1, #self.shortcuts do
		if self.shortcuts[i][1] == identifier then
			return true
		end
	end
	return false
end

function UIView:deleteShortcut( identifier )
	for i = 1, #self.shortcuts do
		if self.shortcuts[i][1] == identifier then
			table.remove( self.shortcuts, i )
			return true
		end
	end
end

function UIView:getShortcuts()
	local t = {}
	for i = 1, #self.shortcuts do
		t[i] = self.shortcuts[i][1]
	end
	return t
end

function UIView:setShortcut( identifier, shortut )
	for i = 1, #self.shortcuts do
		if self.shortcuts[i][1] == identifier then
			self.shortcuts[i][2] = shortcut
			return true
		end
	end
	return false
end

function UIView:getShortcut( identifier )
	for i = 1, #self.shortcuts do
		if self.shortcuts[i][1] == identifier then
			return self.shortcuts[i][2]
		end
	end
end

function UIView:setShortcutAction( identifier, action )
	for i = 1, #self.shortcuts do
		if self.shortcuts[i][1] == identifier then
			self.shortcuts[i][3] = action
			return true
		end
	end
	return false
end

function UIView:getShortcutAction( identifier )
	for i = 1, #self.shortcuts do
		if self.shortcuts[i][1] == identifier then
			return self.shortcuts[i][3]
		end
	end
end

function UIView:handle( event )

	if event.name == Event.KEYDOWN then
		local a, l = nil, -1
		for i = 1, #self.shortcuts do
			if #self.shortcuts[i][2] > l and event:matchesHotkey( self.shortcuts[i][2] ) then
				a, l = self.shortcuts[i][3], #self.shortcuts[i][2]
			end
		end
		if a then
			event.handled = true
			a()
		end
	end

	return UIElement.handle( self, event )

end
