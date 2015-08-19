
require "UIAnimationHandler"
require "Event.MouseEvent"
require "Event.KeyboardEvent"
require "Event.TextEvent"
require "graphics.DrawingCanvas"

local function copytable( t )
	return { unpack( t ) }
end

class "UIElement" { useSetters = true,
	id = "NOID";
	tags = {};

	x = 0;
	y = 0;
	width = 0;
	height = 0;

	ox = 0;
	oy = 0;

	children = {};
	parent = nil;

	handlesMouse = true;
	handlesKeyboard = false;
	handlesText = false;

	canvas = nil;
	animationHandler = nil;
	changed = true;

	transitionTime = .3;
}

function UIElement:init( x, y, width, height )
	self.tags = {}
	self.children = {}
	self.raw.x = x
	self.raw.y = y
	self.raw.width = width
	self.raw.height = height
	self.animationHandler = UIAnimationHandler()
	self.canvas = DrawingCanvas( 0, 0, width, height )

	self.mt.__tostring = self.tostring
end

function UIElement:getChildById( id, recursive )

	for i = #self.children, 1, -1 do
		local child = self.children[i]
		if child.id == id then
			return child
		elseif recursive then
			child = child:getChildById( id, true )
			if child then
				return child
			end
		end
	end

end

UIElement.getElementById = UIElement.getChildById

function UIElement:getChildrenByTag( tag, recursive )

	local children = {}
	for i = 1, #self.children do
		local child = self.children[i]
		for t = 1, #child.tags do
			if child.tags[t] == tag then
				children[#children + 1] = child
				break
			end
		end
		if recursive then
			local e = child:getChildrenByTag( tag, true )
			for c = 1, #e do
				children[#children + 1] = e[c]
			end
		end
	end

	return children

end

function UIElement:childrenWithTag( tag, recursive )

	local children = self:getChildrenByTag( tag, recursive )
	local i = 0
	return function()
		i = i + 1
		return children[i]
	end

end

function UIElement:getChildrenAt( x, y )

	local ping = MouseEvent( Event.MOUSEPING, x + self.ox, y + self.oy )
	ping.elements = {}

	for i = #self.children, 1, -1 do
		self.children[i]:handle( ping )
	end
	return unpack( ping.elements )

end

function UIElement:childrenAt( x, y )

	local children = self:getChildrenAt( tag, recursive )
	local i = 0
	return function()
		i = i + 1
		return children[i]
	end

end

function UIElement:addTag( tag )
	self.tags[#self.tags + 1] = tag
end

function UIElement:removeTag( tag )

	for i = #self.tags, 1, -1 do
		if self.tags[i] == tag then
			table.remove( self.tags, i )
		end
	end

end

function UIElement:hasTag( tag )

	for i = #self.tags, 1, -1 do
		if self.tags[i] == tag then
			return true
		end
	end
	return false

end

function UIElement:addChild( child )

	if child.parent then
		child.parent:removeChild( child )
	end

	self.children[#self.children + 1] = child
	child.raw.parent = self
	child:onParentChanged()

	self.changed = true

	return child

end

function UIElement:removeChild( child )

	for i = #self.children, 1, -1 do
		if self.children[i] == child then
			table.remove( self.children, i )
			child.raw.parent = nil
			child:onParentChanged()
			self.changed = true
			break
		end
	end
	return child

end

function UIElement:setParent( parent )

	if parent then
		parent:addChild( self )
	elseif self.parent then
		self.parent:removeChild( self )
	end

end

function UIElement:remove()
	if self.parent then
		self.parent:removeChild( self )
	end
end

function UIElement:transitionInLeft( easing )
	self.x = -self.width
	return self.animationHandler:createRoundedTween( "x", self, { x = 0 }, self.transitionTime, easing )
end

function UIElement:transitionInLeftFrom( x, easing )
	self.x = x
	return self.animationHandler:createRoundedTween( "x", self, { x = 0 }, self.transitionTime, easing )
end

function UIElement:transitionInRight( easing )
	self.x = self.parent.width
	return self.animationHandler:createRoundedTween( "x", self, { x = self.parent.width - self.width }, self.transitionTime, easing )
end

function UIElement:transitionInRightFrom( x, easing )
	self.x = x
	return self.animationHandler:createRoundedTween( "x", self, { x = self.parent.width - self.width }, self.transitionTime, easing )
end

function UIElement:transitionInTop( easing )
	self.y = -self.height
	return self.animationHandler:createRoundedTween( "y", self, { y = 0 }, self.transitionTime, easing )
end

function UIElement:transitionInTopFrom( y, easing )
	self.y = y
	return self.animationHandler:createRoundedTween( "y", self, { y = 0 }, self.transitionTime, easing )
end

function UIElement:transitionInBottom( easing )
	self.y = self.parent.height
	return self.animationHandler:createRoundedTween( "y", self, { y = self.parent.height - self.height }, self.transitionTime, easing )
end

function UIElement:transitionInBottomFrom( y, easing )
	self.y = y
	return self.animationHandler:createRoundedTween( "y", self, { y = self.parent.height - self.height }, self.transitionTime, easing )
end

function UIElement:transitionOutLeft( easing )
	local tween = self.animationHandler:createRoundedTween( "x", self, { x = -self.width }, self.transitionTime, easing )
	function tween.onFinish() self:remove() end
end

function UIElement:transitionOutLeftTo( x, easing )
	local tween = self.animationHandler:createRoundedTween( "x", self, { x = x }, self.transitionTime, easing )
	function tween.onFinish() self:remove() end
end

function UIElement:transitionOutRight( easing )
	local tween = self.animationHandler:createRoundedTween( "x", self, { x = self.parent.width }, self.transitionTime, easing )
	function tween.onFinish() self:remove() end
end

function UIElement:transitionOutRightTo( x, easing )
	local tween = self.animationHandler:createRoundedTween( "x", self, { x = x }, self.transitionTime, easing )
	function tween.onFinish() self:remove() end
end

function UIElement:transitionOutTop( easing )
	local tween = self.animationHandler:createRoundedTween( "y", self, { y = -self.height }, self.transitionTime, easing )
	function tween.onFinish() self:remove() end
end

function UIElement:transitionOutTopTo( y, easing )
	local tween = self.animationHandler:createRoundedTween( "y", self, { y = y }, self.transitionTime, easing )
	function tween.onFinish() self:remove() end
end

function UIElement:transitionOutBottom( easing )
	local tween = self.animationHandler:createRoundedTween( "y", self, { y = self.parent.height }, self.transitionTime, easing )
	function tween.onFinish() self:remove() end
end

function UIElement:transitionOutBottomTo( y, easing )
	local tween = self.animationHandler:createRoundedTween( "y", self, { y = y }, self.transitionTime, easing )
	function tween.onFinish() self:remove() end
end

function UIElement:bringToFront()
	if self.parent and self.parent.children[#self.parent.children] ~= self then
		for i = #self.parent.children, 1, -1 do
			if self.parent.children[i] == self then
				table.remove( self.parent.children, i )
			end
		end
		self.parent.children[#self.parent.children + 1] = self
		self.parent.changed = true
	end
end

function UIElement:setChanged( changed )
	self.changed = changed
	if changed and self.parent then self.parent.changed = true end
end

function UIElement:setX( x )
	self.raw.x = x
	if self.parent then self.parent.changed = true end
end

function UIElement:setAnimatedX( x )
	return self.animationHandler:createRoundedTween( "x", self, { x = x }, self.transitionTime )
end

function UIElement:setY( y )
	self.raw.y = y
	if self.parent then self.parent.changed = true end
end

function UIElement:setAnimatedY( y )
	return self.animationHandler:createRoundedTween( "y", self, { y = y }, self.transitionTime )
end

function UIElement:setOx( ox )
	self.raw.ox = ox
	self.changed = true
end

function UIElement:setAnimatedOX( ox )
	return self.animationHandler:createRoundedTween( "ox", self, { ox = ox }, self.transitionTime )
end

function UIElement:setOy( oy )
	self.raw.oy = oy
	self.changed = true
end

function UIElement:setAnimatedOY( oy )
	return self.animationHandler:createRoundedTween( "oy", self, { oy = oy }, self.transitionTime )
end

function UIElement:setWidth( width )
	self.raw.width = width
	for i = 1, #self.children do
		self.children[i]:onParentResized()
	end
	self.canvas.width = width
	self.changed = true
end

function UIElement:setAnimatedWidth( width )
	return self.animationHandler:createRoundedTween( "width", self, { width = width }, self.transitionTime )
end

function UIElement:setHeight( height )
	self.raw.height = height
	for i = 1, #self.children do
		self.children[i]:onParentResized()
	end
	self.canvas.height = height
	self.changed = true
end

function UIElement:setAnimatedHeight( height )
	return self.animationHandler:createRoundedTween( "height", self, { height = height }, self.transitionTime )
end

function UIElement:update( dt )
	self:onUpdate( dt )
	for i = 1, #self.children do
		self.children[i]:update( dt )
	end
end

function UIElement:draw()

	if not self.changed then return end
	self.changed = false

	local canvas = self.canvas
	canvas.cursor = nil
	self:onDraw()

	for i = 1, #self.children do
		local child = self.children[i]
		child:draw()
		child.canvas:drawTo( canvas, child.x + self.ox, child.y + self.oy )
		if child.canvas.cursor then
			canvas.cursor = {
				x = child.canvas.cursor.x + child.x + self.ox;
				y = child.canvas.cursor.y + child.y + self.oy;
				colour = child.canvas.cursor.colour;
			}
		end
	end

end

function UIElement:handle( event )

	local children = {}
	for i = 1, #self.children do
		children[i] = self.children[i]
	end
	if event:typeOf( MouseEvent ) then
		local within = event:isInArea( 0, 0, self.width, self.height )
		for i = #children, 1, -1 do
			local child = children[i]
			child:handle( event:clone( child.x + self.ox, child.y + self.oy, within ) )
		end
	else
		for i = #children, 1, -1 do
			children[i]:handle( event )
		end
	end

	if event:typeOf( MouseEvent ) and self.handlesMouse then
		if event.name == Event.MOUSEPING and event:isInArea( 0, 0, self.width, self.height ) then
			local elements = event.elements
			elements[#elements + 1] = self
		end
		self:onMouseEvent( event )
	elseif event:typeOf( KeyboardEvent ) and self.handlesKeyboard then
		self:onKeyboardEvent( event )
	elseif event:typeOf( TextEvent ) and self.handlesText then
		self:onTextEvent( event )
	end

end

function UIElement:onUpdate( dt ) end
function UIElement:onDraw() end
function UIElement:onMouseEvent( event ) end
function UIElement:onKeyboardEvent( event ) end
function UIElement:onTextEvent( event ) end
function UIElement:onParentChanged() end
function UIElement:onParentResized() end

function UIElement:tostring()
	return "[Instance] " .. self.class.name .. " " .. tostring( self.id ) .. " (" .. self.x .. "," .. self.y .. " " .. self.width .. "x" .. self.height .. ")"
end
