
class "Timer"

local time, timers, fpstimer = 0, {}, nil

local function getTimer( n )
	local timeout = os.clock() + n
	for i = 1, #timers do
		if timers[i].timeout == timeout then
			return timers[i]
		end
	end
	local timer = {
		timeout = timeout;
		timer = os.startTimer( n );
	}
	timers[#timers + 1] = timer;
	return timer
end

local function updateTimers( timer )
	for i = #timers, 1, -1 do
		if timers[i].timer == timer then
			for a = 1, #timers[i] do
				timers[i][a]()
			end
			table.remove( timers, i )
			return true
		end
	end
	return false
end

function Timer.step()
	time = os.clock()
end

function Timer.getDelta()
	return os.clock() - time
end

function Timer.getFPS()
	return fps
end

function Timer.setFPS( f )
	fps = f
	fpstimer = fpstimer or ( f and os.startTimer( 1 / f ) )
end

function Timer.queue( n, action )
	local t = getTimer( n )
	t[#t + 1] = action
	return t.timer
end

function Timer.sleep( n )
	local t = getTimer( n ).timer
	repeat
		local _, timer = coroutine.yield "timer"
	until timer == t
end

function Timer.update( event, timer )
	if event == "timer" then
		if timer == fpstimer then
			fpstimer = fps and os.startTimer( 1 / fps ) or nil
			os.queueEvent "update"
			return true
		else
			return updateTimers( timer )
		end
	end
end
