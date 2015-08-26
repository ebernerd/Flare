
# UITerminal

### The UITerminal element is an element with its own term redirect used for simulating a CraftOS screen and event system

![Oh noes!](http://puu.sh/jGTgQ/f81a5e4450.png)

* Note, the window in that image is the `UIWindow` element, its content is the UITerminal.

---

### Constructor

`UITerminal( number x, number y, number width, number height )`

* creates a terminal object

---

### Callbacks

`UITerminal:onEvent( string event, ... )`

* called when the terminal gets an event, i.e. a click
* arguments are the computercraft formatted event, i.e. "mouse_click" or "mouse_drag"
* mouse event coordinates are relative to the object
* you can use this to pass events to a coroutine manager, and wrap to its canvas (see `wrap()`) before resuming to run a program inside the terminal

---

### Variables

`UITerminal.canvas` - `TermCanvas`

* the canvas with :getTerminalRedirect() that it draws to

---

### Methods

`UITerminal:wrap()`

* returns the result of term.redirect() to its TermCanvas
