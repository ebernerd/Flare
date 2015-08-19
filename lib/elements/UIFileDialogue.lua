
-- line 169
-- add in settings button (needs UIMenu first, which idk how to implement)

require "graphics.DrawingCanvas"

require "UIElement"
require "UIButton"
require "UITextInput"
require "UIPanel"
require "UIContainer"
require "UIImage"
require "UIWindow"
require "UILabel"

local function getSize( path )
	if fs.isDir( path ) then
		local n = 0
		for i, v in ipairs( fs.list( path ) ) do
			n = n + getSize( path .. "/" .. v )
		end
		return n
	end
	return tonumber( select( 2, pcall( fs.getSize, path ) ) ) or 0
end
local function fmtSize( size )
	local ending = " bytes"
	if size >= 1024 then
		size = math.floor( size / 1024 )
		ending = "KB"
	end
	if size >= 1024 then
		size = math.floor( size / 1024 )
		ending = "MB"
	end
	return size .. ending
end

class "UIFileDialogue" extends "UIElement" {
	icons = {}; -- static

	sortBy = "name"; -- , size
	sortOrder = "ascending"; -- , descending
	custom_sorter = nil;

	mode = "open"; -- save

	showBackButton = true;
	showForwardButton = true;
	showUpButton = true;
	showSettingsButton = true;
	showButtons = true;
	showFileName = true;

	backButton = nil;
	forwardButton = nil;
	upButton = nil;
	settingsButton = nil;
	addressBar = nil;
	button1 = nil;
	button2 = nil;
	fileNameBox = nil;

	content = nil;

	header = nil;
	background = nil;

	headerColour = colours.grey;
	backgroundColour = colours.white;
	headerButtonColour = colours.lightGrey;
	buttonColour = colours.grey;

	path = nil;
	history = {};
	hindex = 0;

	fileobjects = {};
	window = nil;
}

UIFileDialogue.icons.default = DrawingCanvas( 4, 3 )
UIFileDialogue.icons.default:mapPixels {
	{  1, { 1, 256, "-" } };
	{  2, { 1, 256, "-" } };
	{  3, { 1, 256, "-" } };
	{  4, { 1, 256, "-" } };
	{  5, { 1, 256, "f" } };
	{  6, { 1, 256, "i" } };
	{  7, { 1, 256, "l" } };
	{  8, { 1, 256, "e" } };
	{  9, { 1, 256, "-" } };
	{ 10, { 1, 256, "-" } };
	{ 11, { 1, 256, "-" } };
	{ 12, { 1, 256, "-" } };
}

UIFileDialogue.icons.folder = DrawingCanvas( 4, 3 )
UIFileDialogue.icons.folder:mapPixels {
	{  1, { 16, 128, "f" } };
	{  2, { 16, 128, "l" } };
	{  3, { 16, 128, "d" } };
	{  4, { 16, 128, "r" } };
	{  5, { 16, 128, " " } };
	{  6, { 16, 128, " " } };
	{  7, { 16, 128, " " } };
	{  8, { 16, 128, " " } };
	{  9, { 16, 128, " " } };
	{ 10, { 16, 128, " " } };
	{ 11, { 16, 128, " " } };
	{ 12, { 16, 128, ">" } };
}

function UIFileDialogue:init( x, y, w, h, path )

	self.super:init( x, y, w, h )

	self.backButton = UIButton( 0, 0, 3, 1, " < " )
	self.forwardButton = UIButton( 0, 0, 3, 1, " > " )
	self.upButton = UIButton( 0, 0, 3, 1, " ^ " )
	self.settingsButton = UIButton( 0, 0, 3, 1, " = " )
	self.addressBar = UITextInput( 0, 1, 0 )
	self.button1 = UIButton( 0, 0, 8, 1, "Open" )
	self.button2 = UIButton( 0, 0, 8, 1, "Cancel" )
	self.fileNameBox = UITextInput( 0, 0, 0 )

	self.content = UIContainer( 1, 4, w - 2, h - 5 )
	self.header = UIPanel( 0, 0, w, 3, self.headerColour )
	self.background = UIPanel( 0, 3, w, h - 3, self.backgroundColour )

	self.backButton.colour = self.headerButtonColour
	self.forwardButton.colour = self.headerButtonColour
	self.upButton.colour = self.headerButtonColour
	self.settingsButton.colour = self.headerButtonColour

	self.button1.colour = self.buttonColour
	self.button1.textColour = colours.white
	self.button2.colour = self.buttonColour
	self.button2.textColour = colours.white

	self.fileNameBox.focussedColour = colours.lightGrey

	function self.addressBar:onTab()
		self.parent.fileNameBox:focusOn()
	end
	function self.fileNameBox:onTab()
		self.parent.addressBar:focusOn()
	end
	function self.addressBar:onEnter()
		self.parent:goto( self.text )
	end
	function self.fileNameBox:onEnter()
		self.parent.button1:onClick()
	end

	function self.backButton:onClick()
		self.parent:back()
	end
	function self.forwardButton:onClick()
		self.parent:forward()
	end
	function self.upButton:onClick()
		self.parent:goto( self.parent.path:match "(.+)/" or "" )
	end

	function self.button1:onClick()
		if self.parent.fileNameBox.text == "" then
			-- error
		elseif self.mode == "save" then
			if self.onSave then
				self:onSave( self.parent.path .. "/" .. self.parent.fileNameBox.text )
			end
		else
			self.parent:goto( self.parent.path .. "/" .. self.parent.fileNameBox.text )
		end
		self.parent.fileNameBox.text = ""
	end
	function self.button2:onClick()
		if self.parent.onCancel then
			self.parent:onCancel()
		end
	end

	self.raw.history = {}
	self.raw.fileobjects = {}

	self:goto( path or "" )

	self.width = w
	self.height = h
end

function UIFileDialogue:back()
	self.hindex = math.max( 1, self.hindex - 1 )
	self:show( self.history[self.hindex] )
end

function UIFileDialogue:forward()
	self.hindex = math.min( #self.history, self.hindex + 1 )
	self:show( self.history[self.hindex] )
end

function UIFileDialogue:show( path )
	if fs.isDir( path ) then
		self.raw.path = path
		self.addressBar.text = path
		self:calculateFiles()
		return true
	else
		if self.window then
			self.window:remove()
		end

		local win = self:addChild( UIWindow( math.floor( self.width / 2 - 10.5 ), math.max( 4, math.floor( self.height / 2 - 4 ) ), 21, 8 ) )
		win.title = "Path not a folder"

		win.resizeable = false
		win.moveable = false

		win.content:addChild( UILabel( 1, 1, "The path you input" ) )
		win.content:addChild( UILabel( 1, 2, "does not exist!" ) )

		local button = win.content:addChild( UIButton( math.floor( win.width / 2 - 2 ), 4, 4, 1, "ok" ) )
		button.colour = colours.lightGrey
		button.textColour = colours.black

		function button:onClick()
			self.parent.parent:onClose()
			self.parent.parent:remove()
		end

		function win:onClose()
			self.parent.window = nil
		end

		self.window = win
	end
end

function UIFileDialogue:goto( path )
	while self.history[self.hindex + 1] do
		self.history[#self.history] = nil
	end
	if fs.exists( path ) and not fs.isDir( path ) then
		if self.mode == "open" and self.onOpen then
			self:onOpen( path )
		elseif self.mode == "save" and self.onSave then
			self:onSave( path )
		end
	else
		if path ~= self.path then
			if self:show( path ) then
				self.hindex = self.hindex + 1
				self.history[self.hindex] = path
			end
		end
	end
end

function UIFileDialogue:reposition()

	local function position( element, condition, x, y )
		if condition then
			self:addChild( element )
			element.x = x
			element.y = y
		else
			self:removeChild( element )
		end
		return condition
	end

	local x = 1
	self:addChild( self.header )
	self:addChild( self.background )
	self:addChild( self.content )
	self:addChild( self.addressBar )

	if self.window then
		self:addChild( self.window )
		self.window.x = math.floor( self.width / 2 - self.window.width / 2 )
		self.window.y = math.max( 4, math.floor( self.height / 2 - self.window.height / 2 ) )
	end

	self.header.width = self.width
	self.background.width = self.width
	self.background.height = self.height - 3
	self.content.width = self.width - 2

	if position( self.backButton, self.showBackButton, x, 1 ) then
		x = x + 4
	end
	if position( self.forwardButton, self.showForwardButton, x, 1 ) then
		x = x + 4
	end
	if position( self.upButton, self.showUpButton, x, 1 ) then
		x = x + 4
	end
	self.addressBar.x = x
	self.addressBar.y = 1
	self.addressBar.width = self.width - x - 1
	x = self.width
	if position( self.settingsButton, self.showSettingsButton, x - 4, 1 ) then
		self.addressBar.width = self.addressBar.width - 4
	end

	self.content.height = self.height - 5 - ( ( self.showButtons or self.showFileName ) and 2 or 0 )

	local x = self.width
	if position( self.button2, self.showButtons, x - 9, self.height - 2 ) then
		x = x - 18
	end
	position( self.button1, self.showButtons, x, self.height - 2 )
	if position( self.fileNameBox, self.showFileName, 1, self.height - 2 ) then
		if self.width <= 30 then
			self.fileNameBox.y = self.height - 4
			self.content.height = self.content.height - 2
			self.button1.x = 1
			self.fileNameBox.width = self.width - 2
		else
			self.fileNameBox.width = x - 2
		end
	end

	local width = self.content.width
	if #self.fileobjects * 4 - 1 > self.content.height then
		width = width - 1
	end
	for i = 1, #self.fileobjects do
		local ob = self.fileobjects[i]
		ob.width = width
		ob:getChildById "clicker" .width = width
		ob:getChildById "name" .width = width - 4
		ob:getChildById "extn" .width = width - 4
		ob:getChildById "size" .width = width - 4
	end

end

function UIFileDialogue:calculateFiles()

	self.fileobjects = {}
	for i = #self.content.children, 1, -1 do
		self.content.children[i]:remove()
	end

	local path = self.path

	local files = fs.list( path )
	local width = self.content.width
	if #files * 4 - 1 > self.content.height then
		width = width - 1
	end

	local objects = {}
	for i = 1, #files do
		objects[i] = {
			type = fs.isDir( path .. "/" .. files[i] ) and "directory" or "file";
			name = files[i];
			path = path .. "/" .. files[i];
			extension = files[i]:match( "%.(.-)$" ) or "";
			size = getSize( path .. "/" .. files[i] );
		}
	end

	if self.customSorter then
		table.sort( objects, self.customSorter )
	elseif self.sortBy == "name" then
		table.sort( objects, function( a, b )
			if a.type == b.type then
				return a.name < b.name
			end
			return a.type == "directory"
		end )
	elseif self.sortBy == "size" then
		table.sort( objects, function( a, b )
			if a.type == b.type then
				return a.size < b.size
			end
			return a.type == "directory"
		end )
	end

	local start, fin, step = 1, #objects, 1
	if self.sortOrder == "descending" then
		start, fin, step = #objects, 1, -1
	end
	local y = 0
	for i = start, fin, step do
		local container = self.content:addChild( UIElement( 0, y, width, 3 ) )
		local icon = container:addChild( UIImage( 0, 0, objects[i].type == "directory" and self.icons.folder or self.icons[objects[i].extension] or self.icons.default ) )
		local name = container:addChild( UILabel( 5, 0, objects[i].name ) )
		local extn = container:addChild( UILabel( 5, 1, objects[i].extension ) )
		local size = container:addChild( UILabel( 5, 2, fmtSize( objects[i].size ) ) )
		local clicker = container:addChild( UIButton( 0, 0, container.width, container.height, "" ) )

		name.textColour = colours.grey

		icon.id = "icon"
		name.id = "name"
		extn.id = "extn"
		size.id = "size"
		clicker.id = "clicker"

		name.width = math.min( name.width, container.width - 4 )
		extn.width = math.min( extn.width, container.width - 4 )
		size.width = math.min( size.width, container.width - 4 )

		function clicker.canvas:drawTo() end

		function clicker:onClick()
			self.parent.parent.parent:goto( path .. "/" .. objects[i].name )
		end

		self.fileobjects[i] = container

		y = y + 4
	end
end

function UIFileDialogue:setWidth( width )
	local min1 = 9 + ( self.showBackButton and 4 or 0 ) + ( self.showForwardButton and 4 or 0 ) + ( self.showUpButton and 4 or 0 ) + ( self.showSettingsButton and 4 or 0 )
	local min2 = 13
	local min3 = 1 + ( self.showButtons and 18 or 0 ) + ( ( self.width > 30 and self.showFileName and 10 ) or 0 )
	self.super:setWidth( math.max( width, min1, min2, min3 ) )
	self:reposition()
end

function UIFileDialogue:setHeight( height )
	local min = 13 + ( ( self.showButtons or self.showFileName ) and 2 ) + ( self.width <= 30 and 2 or 0 )
	self.super:setHeight( math.max( height, min ) )
	self:reposition()
end

function UIFileDialogue:setPath( path )
	self:goto( tostring( path ) )
end

function UIFileDialogue:setShowBackButton( bool )
	self.raw.showBackButton = bool
	self:reposition()
end

function UIFileDialogue:setShowForwardButton( bool )
	self.raw.showForwardButton = bool
	self:reposition()
end

function UIFileDialogue:setShowUpButton( bool )
	self.raw.showUpButton = bool
	self:reposition()
end

function UIFileDialogue:setShowSettingsButton( bool )
	self.raw.showSettingsButton = bool
	self:reposition()
end

function UIFileDialogue:setShowFileName( bool )
	self.raw.showFileName = bool
	self:reposition()
end

function UIFileDialogue:setShowButtons( bool )
	self.raw.showButtons = bool
	self:reposition()
end

function UIFileDialogue:setIcons( icons )
	self.raw.icons = icons
	self:calculateFiles()
end

function UIFileDialogue:setSortBy( sortBy )
	self.raw.sortBy = sortBy
	self:calculateFiles()
end

function UIFileDialogue:setSortOrder( sortOrder )
	self.raw.sortOrder = sortOrder
	self:calculateFiles()
end

function UIFileDialogue:setCustomSorter( sorter )
	self.customSorter = sorter
	self:calculateFiles()
end

function UIFileDialogue:setMode( mode )
	if mode == "open" then
		self.raw.mode = "open"
		self.button1.text = "Open"
	elseif mode == "save" then
		self.raw.mode = "save"
		self.button1.text = "Save"
	else
		error( "no such mode '" .. tostring( mode ) .. "'", 3 )
	end
end

function UIFileDialogue:setHeaderColour( colour )
	self.raw.headerColour = colour
	self.header.colour = colour
end

function UIFileDialogue:setBackgroundColour( colour )
	self.raw.backgroundColour = colour
	self.background.colour = colour
end

function UIFileDialogue:setHeaderButtonColour( colour )
	self.raw.headerButtonColour = colour
	self.backButton.colour = colour
	self.forwardButton.colour = colour
	self.upButton.colour = colour
	self.settingsButton.colour = colour
end

function UIFileDialogue:setButtonColour( colour )
	self.raw.buttonColour = colour
	self.button1.colour = colour
	self.button2.colour = colour
end
