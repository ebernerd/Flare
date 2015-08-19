
# Timer

The Timer class handles time related tasks, including delta time control, queueing of actions, and sleeping.

---

### Functions

`Timer.step()`

* steps the Timer, see `getDelta()`

`Timer.getDelta()` returns `number dt`

* returns the time between now and the last time `step()` was called

`Timer.setFPS( number fps )`
`Timer.setFPS()`

* sets the desired fps
* triggers an `update` event 'fps' times a second

`Timer.getFPS()` returns `number fps`

* returns the desired fps
* for getting the actual fps, use `1/Timer.getDelta()`

`Timer.queue( number time, function action )`

* queues an action to be called in `time` seconds
* this reuses timers for efficiency, so should be used wherever possible over os.startTimer()

`Timer.sleep( number n )`

* sleeps for `n` seconds
* this is prefered to `sleep()`

`Timer.update( string event, number Timer )`

* updates the timers and framerate Timer
* this is called internally, there is no need to use this
* event passed should be from os.pullEvent()
* the function does check that the event is a Timer event, so doing `Timer.update( os.pullEvent() )` is acceptable
