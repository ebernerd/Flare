
# The application object

The application object is the way you interact with Flare's display and get values passed in to your program.

* Note that application.view's canvas is a ScreenCanvas not DrawingCanvas

---

### Callbacks

`application:load( ... )`

* called when the application starts, with the arguments the program was called with

---

### Variables

`application.terminatable` - `bool`

* specifies whether you can terminate out of the application

`application.view` - `UIView`

* the application display/view, all root elements should be added to this

---

### Methods

`application:stop()`

* stops running the application
