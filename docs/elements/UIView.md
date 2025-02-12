
# UIView

### The UIView element is an element used as `application.view` that allows keyboard shortcuts to be bound to it.

> No image as it has no graphical aspect on its own.

---

### Constructor

`UIView( number x, number y, number width, number height )`

- creates a view

### Methods

`UIView:createShortcut( string identifier, string shortcut, function action )`

* binds the keyboard shortcut 'shortcut' to the action given
* the action will be called whenever the user presses the correct keys, i.e. ctrl-shift-s -> press s while holding ctrl and shift
* note, the order of keys held doesn't matter, and 'ctrl' and 'shift' can be used to represent both their left/right counterparts
* the identifier is used to change the action or keyboard shortcut later on, and cannot be duplicated

`UIView:shortcutExists( string identifier )` returns `bool exists`

* returns whether a keyboard shortcut has been created with the given identifier

`UIView:deleteShortcut( identifier )`

* deletes a keyboard shortcut with the given identifier

`UIView:getShortcuts()` returns `table shortcuts`

* returns a list of keyboard shortcut identifiers

`UIView:setShortcut( identifier, shortut )`

* sets the keyboard shortcut of an identifier

`UIView:getShortcut( identifier )` returns `string shortcut`

* gets the keyboard shortcut of an identifier

`UIView:setShortcutAction( identifier, action )`

* sets the action to be called when the keyboard shortcut of that identifier is triggered

`UIView:getShortcutAction( identifier )`

* gets the action to be called when the keyboard shortcut of that identifier is triggered
