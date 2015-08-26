
local type, sub, upper, unpack = type, string.sub, string.upper, unpack

-- cache the names of the property getter/setter functions
local setters = setmetatable( {}, { __index = function( self, k ) if type( k ) ~= "string" then return end local v = "set" .. upper( sub( k, 1, 1 ) ) .. sub( k, 2 ) self[k] = v return v end; } )
local getters = setmetatable( {}, { __index = function( self, k ) if type( k ) ~= "string" then return end local v = "get" .. upper( sub( k, 1, 1 ) ) .. sub( k, 2 ) self[k] = v return v end; } )

local last_created
local class = {}

local function __tostring( self )
	return "[Class] " .. self.name
end

local function newSuper( object, super )
	local t = {}
	if super.super then
		t.super = newSuper( object, super.super )
	end
	setmetatable( t, { __index = function( t, k )
		if type( super[k] ) == "function" then
			return function( self, ... )
				if self == t then
					self = object
				end
				object.super = t.super
				local v = { super[k]( self, ... ) }
				object.super = t
				return unpack( v )
			end
		else
			return super[k]
		end
	end, __newindex = super, __tostring = function( self )
		return "[Super] " .. tostring( super ) .. " of " .. tostring( object )
	end } )
	return t
end

function class:new( name ) -- creates a new class

	local mt = {}
	mt.__index = self
	mt.__type = name
	mt.__isClass = true
	mt.__tostring = __tostring

	local classobj = {} -- the class object
	classobj.name = name
	classobj.mt = mt

	function mt:__call( ... )
		return self:new( ... )
	end

	function classobj:new( ... ) -- creates an instance
		local ID = sub( tostring {}, 8 )
		local instance, classobj = {}, self

		local useProxy = self.useGetters or self.useSetters

		local raw = useProxy and setmetatable( {}, { __index = classobj } ) or instance
		instance.raw = raw

		instance.class = self
		if self.super then
			instance.super = newSuper( instance, self.super )
		end

		instance.mt = {}
		instance.mt.__isInstance = true

		function instance.mt:__tostring()
			return "[Instance] " .. self.class.name .. " " .. ID
		end

		for k, v in pairs( self.mt ) do
			if k ~= "__isClass" and ( k ~= "__tostring" or v ~= __tostring ) then
				instance.mt[k] = v
			end
		end

		if self.useGetters then
			local getting = {}

			if type( classobj.get ) == "function" then
				local genericgetter = classobj.get
				function instance.mt:__index( k )
					if not getting[k] then
						local getter = getters[k]
						if getter and type( classobj[getter] ) == "function" then
							getting[k] = true
							local value = classobj[getter]( self )
							getting[k] = nil
							return value
						end
						getting[k] = true
						local use, value = genericgetter( self, k )
						getting[k] = nil
						if use then return value end
					end
					return raw[k]
				end
			else
				function instance.mt:__index( k )
					if not getting[k] then
						local getter = getters[k]
						if getter and type( classobj[getter] ) == "function" then
							getting[k] = true
							local value = classobj[getter]( self )
							getting[k] = nil
							return value
						end
					end
					return raw[k]
				end
			end
		else
			instance.mt.__index = useProxy and raw or self
		end
		if self.useSetters then
			local setting = {}

			if type( classobj.set ) == "function" then
				local genericsetter = classobj.set
				function instance.mt:__newindex( k, v )
					if not setting[k] then
						local setter = setters[k]
						if setter and type( classobj[setter] ) == "function" then
							setting[k] = true
							classobj[setter]( self, v )
							setting[k] = nil
							return
						end
						setting[k] = true
						local use = genericsetter( self, k, v )
						setting[k] = nil
						if use then return end
					end
					raw[k] = v
				end
			else
				function instance.mt:__newindex( k, v )
					if not setting[k] then
						local setter = setters[k]
						if setter and type( classobj[setter] ) == "function" then
							setting[k] = true
							classobj[setter]( self, v )
							setting[k] = nil
							return
						end
					end
					raw[k] = v
				end
			end
		end

		for k, v in pairs( self.mt ) do
			if k ~= "__isClass" and k ~= "__call" and k ~= "__index" and ( k ~= "__tostring" or v ~= __tostring ) then
				instance.mt[k] = v
			end
		end

		setmetatable( instance, instance.mt )

		if type( instance.init ) == "function" then -- initialise the instance
			instance:init( ... )
		end

		return instance

	end

	setmetatable( classobj, mt )

	getfenv( 2 )[name] = classobj
	last_created = classobj

	return function( data )
		for k, v in pairs( data ) do
			classobj[k] = v
		end
	end
end

function class:typeOf( _class )
	if type( self ) ~= "table" then return false end
	if self.class then return self.class:typeOf( _class ) end
	if self == _class then return true end
	if self.super then return self.super:typeOf( _class ) end
	return false
end

function class:type()
	local _type = type( self )
	pcall( function()
		_type = getmetatable( self ).__type or _type
	end )
	return _type
end

function class:can( method )
	return type( self[method] ) == "function"
end

function class:has( t, weak )
	for k, v in pairs( t ) do
		if ( not weak and self[k] ~= v ) or type( self[k] ) ~= type( v ) then
			return false
		end
	end
	return true
end

function class:mixin( t )
	for k, v in pairs( t ) do
		self[k] = v
	end
end

function class:extends( class )
	self.super = class
	for k, v in pairs( class.mt ) do -- things like __add
		if k ~= "__index" and k ~= "__type" and k ~= "__tostring" and k ~= "__call" and k ~= "__isClass" then
			self.mt[k] = v
		end
	end
	self.mt.__index = class
end

function class:isClass()
	return pcall( function() if not getmetatable( self ).__isClass then error "" end end ), nil
end

function class.last()
	return last_created
end

setmetatable( class, { __call = function( self, ... ) return self:new( ... ) end } )

return class
