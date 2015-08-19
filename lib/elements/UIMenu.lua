
require "UIElement"
require "UIContainer"
require "UIPanel"
require "UILabel"
require "UIButton"
require "Event.Event"
local shader = require "graphics.shader"
local UIEventHelpers = require "util.UIEventHelpers"

local function checkContent( options )
	for i = 1, #options do
		if options[i].type == "button" or options[i].type == "menu" or options[i].type == "label" then
			if type( options[i].text ) ~= "string" then
				error( "expected string text for option " .. i .. ", got " .. type( options[i].text ), 4 )
			end
		end
	end
end

local function constructContent( menu, options, parent )
	local width, height = 2, #options
	for i = 1, #options do
		if options[i].type == "button" or options[i].type == "menu" then
			width = math.max( width, #options[i].text + 2 )
		elseif options[i].type == "label" then
			width = math.max( width, #options[i].text + 3 )
		elseif options[i].type == "custom" then
			width = math.max( width, 2 + options[i].element.width )
			height = height + options[i].element.height - 1
		end
	end

	local container = UIContainer( 0, 0, width + 1, math.min( 10, height ) + 1 )
	local shadow = container:addChild( UIPanel( 1, 1, width, math.min( 10, height ), colours.grey ) )
	local content = container:addChild( UIContainer( 0, 0, width, math.min( 10, height ) ) )
	content.id = "content"

	local children = {}

	function content:clickRegistered( sx, sy )
		if not ( sx >= 0 and sy >= 0 and sx < self.width and sy < self.height ) then -- not within self
			for i = 1, #children do
				if children[i].parent == self.parent.parent and children[i]:getElementById "content" :clickRegistered( self.parent.x + sx - children[i].x, self.parent.y + sy - children[i].y ) then
					return true
				end
			end
			return false
		end
		return true
	end

	function content:onMouseEvent( event )

		UIContainer.onMouseEvent( self, event )
	
		if event.name == Event.MOUSEUP and not self:clickRegistered( event.x, event.y ) then
			if parent then
				menu:closeSubframe( self.parent )
			else
				menu:close()
			end
		end

	end

	local y = 0

	for i = 1, #options do
		local element
		if options[i].type == "button" then
			element = content:addChild( UIButton( 1, y, width - 2, 1, options[i].text ) )
			element.noAlign = true
			element.onClick = options[i].onClick
			y = y + 1
		elseif options[i].type == "menu" then
			local _y = y
			element = content:addChild( UIButton( 1, y, width - 2, 1, options[i].text ) )
			element.noAlign = true
			local content = constructContent( menu, options[i].content, true )

			function element:onClick()
				menu:openSubframe( content )
				content.x = self.parent.x + self.parent.width
				content.y = self.parent.y + _y
			end

			children[#children + 1] = content

			y = y + 1
		elseif options[i].type == "label" then
			element = content:addChild( UILabel( 2, y, options[i].text ) )
			y = y + 1
		elseif options[i].type == "rule" then
			element = content:addChild( UILabel( 1, y, ("-"):rep( width - 2 ) ) )
			y = y + 1
		elseif options[i].type == "space" then
			y = y + 1
		elseif options[i].type == "custom" then
			element = content:addChild( options[i].element )
			element.x = 1
			element.y = y
			element.width = width - 2
			y = y + element.height
		end


		if element then
			container:addChild( element )
		end
	end

	return container
end

class "UIMenu" extends "UIElement" {
	colour = 1;
	textColour = colours.grey;
	text = "";
	holding = false;
	content = nil;
	contentFrame = nil;
	isOpen = false;
	subframes = {};
}

function UIMenu:init( x, y, w, h, text, options, contentFrame )
	self.super:init( x, y, w, h )
	self.text = text
	checkContent( options )
	self.raw.content = constructContent( self, options )
	self.raw.contentFrame = contentFrame
	self.raw.subframes = {}
end

function UIMenu:open()
	if self.closed ~= os.clock() then
		if not self.isOpen then
			( self.contentFrame or self.parent ):addChild( self.content )
			if self.onOpened then
				self:onOpened()
			end
			self.isOpen = true
		end
	end
end

function UIMenu:openSubframe( frame )
	if frame.closed ~= os.clock() then
		frame.parent = self.contentFrame or self.parent
		self.subframes[#self.subframes + 1] = frame
	end
end

function UIMenu:closeSubframe( frame )
	frame:remove()
	frame.closed = os.clock()
	for i = #self.subframes, 1, -1 do
		if self.subframes[i] == frame then
			table.remove( self.subframes, i )
		end
	end
end

function UIMenu:close()
	self.closed = os.clock()
	if self.isOpen then
		self.content:remove()
		for i = #self.subframes, 1, -1 do
			self.subframes[i]:remove()
			self.subframes[i] = nil
		end
		if self.onClosed then
			self:onClosed()
		end
		self.isOpen = false
	end
end

function UIMenu:onMouseEvent( event )
	local mode = UIEventHelpers.clicking.handleMouseEvent( self, event )
	if mode == "down" or mode == "up" then
		self.holding = mode == "down"
	elseif mode == "click" then
		self.holding = false
		if self.isOpen then
			self:close()
		else
			self:open()
		end
	end
end

function UIMenu:onDraw()
	if self.holding then
		local colour = shader.lighten[self.colour]
		self.canvas:clear( colour == self.colour and shader.darken[colour] or colour )
	else
		self.canvas:clear( self.colour )
	end
	self.canvas:drawWrappedText( 0, 0, self.width, self.height, {
		text = self.text;
		alignment = "centre";
		verticalAlignment = "centre";
		textColour = self.textColour;
	} )
end

function UIMenu:setHolding( state )
	self.raw.holding = state
	self.changed = true
end

function UIMenu:setText( text )
	self.raw.text = text == nil and "" or tostring( text )
	self.changed = true
end

function UIMenu:setColour( colour )
	self.raw.colour = colour
	self.changed = true
end

function UIMenu:setTextColour( textColour )
	self.raw.textColour = textColour
	self.changed = true
end

function UIMenu:setContentFrame( frame )
	self.contentFrame = frame
	if self.isOpen and frame then
		self.content.parent = frame
		for i = #self.subframes, 1, -1 do
			self.subframes[i].parent = frame
		end
	end
end
