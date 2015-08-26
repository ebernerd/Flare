
local files, main = ...

if type( files ) ~= "table" or type( main ) ~= "string" then
	if shell and shell.getRunningProgram() == "Flare/run.lua" then
		return printError "Use Flare/bin/debug to run a Flare project"
	else
		return error( "expected table files, string path, got " .. type( files ) .. ", " .. type( main ) )
	end
end

local libpath = "Flare/lib;Flare/lib/elements"
local env = setmetatable( {}, { __index = _ENV or getfenv() } )
local loaded, results = {}, {}
local class

local function extends( new )
	if not class.isClass( env[new] ) then
		return error( new .. " is not a class" )
	end
	local last = class.last()
	last:extends( env[new] )
	return function( t )
		last:mixin( t )
	end
end

local function loadf( content, name )
	local f, err = load( content, name, nil, env )
	if not f then
		return error( err, 0 )
	end
	return f
end

local function loadfile( path, name )
	local h = fs.open( path, "r" )
	local content = h.readAll() -- existence is already checked, so open() must work
	h.close()

	return loadf( content, name )
end

local function require( name )
	if loaded[name] then
		return results[name]
	end
	loaded[name] = true
	if files[name] then
		local ok, data = pcall( loadf( files[name], name ), name )
		if not ok then
			return error( data, 0 )
		end
		results[name] = data
		return data
	else
		for path in libpath:gmatch "[^;]+" do
			local file, fpath = path .. "/" .. name:gsub( "%.", "/" ), nil
			if fs.exists( file .. ".lua" ) and not fs.isDir( file .. ".lua" ) then
				fpath = file .. ".lua"
			elseif fs.exists( file .. "/init.lua" ) and not fs.isDir( file .. "/init.lua" ) then
				fpath = file .. "/init.lua"
			end
			if fpath then
				local ok, data = pcall( loadfile( fpath, name ), name )
				if not ok then
					return error( data, 0 )
				end
				results[name] = data
				return data
			end
		end
		return error( "file not found: '" .. name .. "'" )
	end
end

class = require "class"

env.require = require
env.class = class
env.extends = extends

local screen, view
local running = true
local held = {}

require "UIView"
require "Timer"
require "graphics.ScreenCanvas"

require "Event.Event"
require "Event.MouseEvent"
require "Event.KeyboardEvent"
require "Event.TextEvent"
require "Timer"

local Timer = env.Timer
local Event = env.Event
local MouseEvent = env.MouseEvent
local KeyboardEvent = env.KeyboardEvent
local TextEvent = env.TextEvent

local application = {
	view = env.UIView( 0, 0, term.getSize() );
	terminateable = true;
}

function application:stop()
	running = false
end

application.view.canvas = application.view.canvas:cloneAs( env.ScreenCanvas )
screen = application.view.canvas
view = application.view

local function getEventObject( ev )
	if ev[1] == "key" then
		held[keys.getName( ev[2] ) or ev[2]] = true
		return KeyboardEvent( Event.KEYDOWN, ev[2], held, { isRepeat = ev[3] } )
	elseif ev[1] == "key_up" then
		held[keys.getName( ev[2] ) or ev[2]] = nil
		return KeyboardEvent( Event.KEYUP, ev[2], held, {} )
	elseif ev[1] == "mouse_click" then
		return MouseEvent( Event.MOUSEDOWN, ev[3] - 1, ev[4] - 1, ev[2], true, {} )
	elseif ev[1] == "mouse_up" then
		return MouseEvent( Event.MOUSEUP, ev[3] - 1, ev[4] - 1, ev[2], true, {} )
	elseif ev[1] == "mouse_scroll" then
		return MouseEvent( Event.MOUSESCROLL, ev[3] - 1, ev[4] - 1, ev[2], true, {} )
	elseif ev[1] == "mouse_drag" then
		return MouseEvent( Event.MOUSEDRAG, ev[3] - 1, ev[4] - 1, ev[2], true, {} )
	elseif ev[1] == "char" then
		return TextEvent( Event.TEXT, ev[2], {} )
	elseif ev[1] == "paste" then
		return TextEvent( Event.PASTE, ev[2], {} )
	else
		return Event( ev[1], { unpack( ev, 2 ) } )
	end
end
local function redraw()
	if view.changed then
		screen:clear()
		view:draw()
		screen:drawToScreen()
		if screen.cursor then
			local cursor = screen.cursor
			term.setCursorPos( cursor.x + 1, cursor.y + 1 )
			term.setTextColour( cursor.colour )
			term.setCursorBlink( true )
		else
			term.setCursorBlink( false )
		end
	end
end

env.application = application

require "init"

if type( application.load ) == "function" then
	application:load( select( 3, ... ) )
end

while running do
	Timer.step()
	redraw()
	local event = { coroutine.yield() }
	if event[1] == "term_resize" then
		view.width, view.height = term.getSize()
	elseif event[1] == "terminate" and application.terminateable then
		running = false
	elseif event[1] ~= "timer" or not Timer.update( event[1], event[2] ) then
		view:handle( getEventObject( event ) )
	end
	view:update( Timer.getDelta() )
end

