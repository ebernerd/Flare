
# UIContainer

### The UIContainer is an object used for containing other objects and adding scrollbars if necessary.

![Oh noes!](http://puu.sh/jGRZO/6551bf488e.png)

---

### Constructor

`UIContainer( number x, number y, number width, number height )`

* creates a container object

---

### Variables

`UIContainer.colour` - `number`

* the background colour of the container

`UIContainer.scrollbars` - `bool` default = `true`

* whether or not scrollbars should be automatically shown if the content overflows the display area of the container

---

### Methods

`UIContainer:getContentWidth()` returns `number width`

* returns the total width of the content (the largest sum of a child's x and width)

`UIContainer:getContentHeight()` returns `number height`

* returns the total height of the content (the largest sum of a child's y and height)

`UIContainer:getDisplayWidth()` returns `number width`

* returns the width of the container, used internally for the scrollbars

`UIContainer:getDisplayHeight()` returns `number height`

* returns the height of the container, used internally for the scrollbars

`UIContainer:getHorizontalOffset()` returns `number offset`

* returns the horizontal offset of the container, used internally for the scrollbars

`UIContainer:getVerticalOffset()` returns `number offset`

* returns the vertical offset of the container, used internally for the scrollbars

`UIContainer:setHorizontalOffset( number scroll )`

* sets the horizontal offset of the container, used internally for the scrollbars

`UIContainer:setVerticalOffset( number scroll )`

* sets the vertical offset of the container, used internally for the scrollbars
