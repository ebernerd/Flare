
# UIWindow

### The UIWindow element is a draggable, resizeable object that contains content in a container.

![Oh noes!](http://puu.sh/jGYhz/2c06632a59.png)

---

### Constructor

`UIWindow( number x, number y, number width, number height )`

* creates the window object

---

### Variables

`UIWindow.content` - `UIContainer`

* the container of elements in the window
* all children to the window should be added to this, NOT the window itself
* you will get clearly weird results if adding to the window itself, or using the window width/height for things in its content

`UIWindow.minWidth` - `number`

* the minimum width of the window object

`UIWindow.minHeight` - `number`

* the minimum height of the window object

`UIWindow.maxWidth` - `number`

* the maximum width of the window object

`UIWindow.maxHeight` - `number`

* the maximum height of the window object

`UIWindow.title` - `string`

* the title text of the window

`UIWindow.titleColour` - `number`

* the title background colour of the window object

`UIWindow.titleTextColour` - `number`

* the title text colour of the window object

`UIWindow.shadowColour` - `number`

* the colour of the window shadow

`UIWindow.closeable` - `bool`

* whether the user is able to close the window

`UIWindow.resizeable` - `bool`

* whether the user is able to resize the window

`UIWindow.moveable` - `bool`

* whether the user is able to move the window
