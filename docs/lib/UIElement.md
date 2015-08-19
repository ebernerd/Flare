
# UIElement

### The UIElement is the base class for all UI elements, and provides a set of commonly used functions for identification, parenting, positioning, and animation.

> Note, any element can contain any other element. A button can contain a container, and the other way round.
> However, some elements treat children differently to others, such as containers, which add scrollbars automatically if needed.

> UIElements use a complicated set of setter functions that mean setting variables can cause complex actions, for example setting the width of an element like `element.width = 5` calls `onParentResized()` in all children. Bear in mind this is a fairly laggy process, so all variable assignments should be minimised. If, for whatever reason, you want to avoid invoking a setter, use `element.raw.variable = blah`, but this may cause unexpected/erroring behaviour.

> Also note all callbacks are called with self, so should be defined as follows, `function element:callback( parameter1 )`, or, if self cannot be used for some reason, `function element.callback( _self, parameter1 )`.

> Any values with `[SETTER]` at the start mean it is a value that isn't stored, and only used to set something (using metatable magic)

---

### Constructor

`UIElement( number x, number y, number width, number height )`

* creates a new element

--

### Callbacks


`UIElement:onParentChanged()`

* called when the parent is changed, as in the element's parent is switched to another parent

`UIElement:onParentResized()`

* called when the parent of the element is resized

---

### Variables

`UIElement.id` - `anything`

* the id used for identifying the element from a parent with `getChildById()`

`UIElement.tags` - `table`

* a table containing all the element's tags
* this should not be modified or used directly

`UIElement.x` - `number`

* the x position of the element, based at 0

`UIElement.y` - `number`

* the y position of the element, based at 0

`UIElement.width` - `number`

* the width of the element

`UIElement.height` - `number`

* the height of the element

`UIElement.ox` - `number`

* the x offset of children of this element
* this number is added to the child's coordinates whenever a related function is called

`UIElement.oy` - `number`

* the y offset of children of this element
* this number is added to the child's coordinates whenever a related function is called

`UIElement.children` - `table`

* a table containing the children of the element
* this table should not be modified manually, see `addChild()` and `removeChild()`

`UIElement.animationHandler` - `UIAnimationHandler`

* an object used for handling (and creating) all animations of the element

`UIElement.parent` - `[UIElement]`

* the parent of the element, or nil if there is no parent
* setting the parent of an element like `element.parent = blah` is possible, and correctly adds the element to the parent's list of children

`UIElement.transitionTime` - `number`

* the default transition time used for animating the element

`UIElement.changed` - `bool`

* true if the element has undrawn changes

`[SETTER] UIElement.animatedX` - `number`

* used to animate the x position to a new value
* the setter function returns the `Tween` object

`[SETTER] UIElement.animatedY` - `number`

* used to animate the y position to a new value
* the setter function returns the `Tween` object

`[SETTER] UIElement.animatedOX` - `number`

* used to animate the offset x position to a new value
* the setter function returns the `Tween` object

`[SETTER] UIElement.animatedOY` - `number`

* used to animate the offset y position to a new value
* the setter function returns the `Tween` object

`[SETTER] UIElement.animatedWidth` - `number`

* used to animate the width to a new value
* the setter function returns the `Tween` object

`[SETTER] UIElement.animatedHeight` - `number`

* used to animate the height to a new value
* the setter function returns the `Tween` object

---

### Methods

`UIElement:getChildById( * id, bool recursive )` returns `[UIElement] child`

* looks in the element for a child with the id given
* if recursive is true, this will also look inside children of children, etc

`UIElement:getElementById( * id, bool recursive )` returns `[UIElement] child`

* looks in the element for a child with the id given
* if recursive is true, this will also look inside children of children, etc

`UIElement:getChildrenByTag( string tag, bool recursive )` returns `table children`

* returns a table containing all children with the tag given
* if recursive is true, this will also look inside children of children, etc

`UIElement:childrenWithTag( string tag, bool recursive )` returns `function iterator`

* returns an iterator for all children with the tag given
* if recursive is true, this will also look inside children of children, etc
* usage example:
		for child in element:childrenWithTag "tag" do

`UIElement:addTag( string tag )`

* gives the element a tag

`UIElement:removeTag( string tag )`

* removes a tag from the element

`UIElement:hasTag( string tag )` returns `bool hasTag`

* returns whether the element has a tag

`UIElement:getChildrenAt( number x, number y )` returns `table children`

* returns a table containing all the children at the coordinates given
* this returns children under children, not just ones at the top layer at those coordinates

`UIElement:childrenAt( number x, number y )` returns `function iterator`

* returns an iterator for all the children at the coordinates given
* this returns children under children, not just ones at the top layer at those coordinates
* usage example:
		for child in element:childrenAt( 5, 5 ) do

`UIElement:addChild( [UIElement] child )` returns `arg#1 child`

* adds the child to this element and sets its parent, calling child:onParentChanged()
* returns the child

`UIElement:removeChild( [UIElement] child )` returns `arg#1 child`

* removes the child from this element and sets its parent to nil, calling child:onParentChanged()
* returns the child

`UIElement:remove()`

* removes the element from its parent if it has one

`UIElement:transitionInLeft( string easing )` returns `Tween animation`

* moves an element in to the left side of its parent
* easing is optional and defaults to "inOutSine"

`UIElement:transitionInLeftFrom( number x, string easing )` returns `Tween animation`

* moves an element in to the left side of its parent from the x coordinate given
* easing is optional and defaults to "inOutSine"

`UIElement:transitionInRight( string easing )` returns `Tween animation`

* moves an element in to the right side of its parent
* easing is optional and defaults to "inOutSine"

`UIElement:transitionInRightFrom( number x, string easing )` returns `Tween animation`

* moves an element in to the right side of its parent from the x coordinate given
* easing is optional and defaults to "inOutSine"

`UIElement:transitionInTop( string easing )` returns `Tween animation`

* moves an element in to the top side of its parent
* easing is optional and defaults to "inOutSine"

`UIElement:transitionInTopFrom( number y, string easing )` returns `Tween animation`

* moves an element in to the top side of its parent from the y coordinate given
* easing is optional and defaults to "inOutSine"

`UIElement:transitionInBottom( string easing )` returns `Tween animation`

* moves an element in to the bottom side of its parent
* easing is optional and defaults to "inOutSine"

`UIElement:transitionInBottomFrom( number y, string easing )` returns `Tween animation`

* moves an element in to the bottom side of its parent from the y coordinate given
* easing is optional and defaults to "inOutSine"

`UIElement:transitionOutLeft( string easing )` returns `Tween animation`

* moves an element out of the left side of its parent and removes it when the animation has finished
* easing is optional and defaults to "inOutSine"

`UIElement:transitionOutLeftTo( number x, string easing )` returns `Tween animation`

* moves an element out of the left side of its parent to the x coordinate given and removes it when the animation has finished
* easing is optional and defaults to "inOutSine"

`UIElement:transitionOutRight( string easing )` returns `Tween animation`

* moves an element out of the right side of its parent and removes it when the animation has finished
* easing is optional and defaults to "inOutSine"

`UIElement:transitionOutRightTo( number x, string easing )` returns `Tween animation`

* moves an element out of the right side of its parent to the x coordinate given and removes it when the animation has finished
* easing is optional and defaults to "inOutSine"

`UIElement:transitionOutTop( string easing )` returns `Tween animation`

* moves an element out of the top side of its parent and removes it when the animation has finished
* easing is optional and defaults to "inOutSine"

`UIElement:transitionOutTopTo( number y, string easing )` returns `Tween animation`

* moves an element out of the top side of its parent to the y coordinate given and removes it when the animation has finished
* easing is optional and defaults to "inOutSine"

`UIElement:transitionOutBottom( string easing )` returns `Tween animation`

* moves an element out of the bottom side of its parent and removes it when the animation has finished
* easing is optional and defaults to "inOutSine"

`UIElement:transitionOutBottomTo( number y, string easing )` returns `Tween animation`

* moves an element out of the bottom side of its parent to the y coordinate given and removes it when the animation has finished
* easing is optional and defaults to "inOutSine"

`UIElement:bringToFront()`

* brings the element to the front of its parent's child list (so it draws on top and gets events first)

---

# UIElement internals

`UIElement.handlesMouse` - `bool`

* if true, onMouseEvent() is called when handle() is called with a mouse event

`UIElement.handlesKeyboard` - `bool`

* if true, onKeyboardEvent() is called when handle() is called with a keyboard event
	
`UIElement.handlesText` - `bool`

* if true, onTextEvent() is called when handle() is called with a text event

`UIElement.canvas` - `DrawingCanvas`

* the canvas of the element

---

To document:

		(Callback) UIElement.update( number dt )
		* A_CALLBACK_I_NEED_TO_DOCUMENT

		(Callback) UIElement.draw()
		* A_CALLBACK_I_NEED_TO_DOCUMENT

		(Callback) UIElement.handle( [Event] event )
		* A_CALLBACK_I_NEED_TO_DOCUMENT

		(Callback) UIElement.onUpdate( number dt ) end
		* A_CALLBACK_I_NEED_TO_DOCUMENT

		(Callback) UIElement.onDraw() end
		* A_CALLBACK_I_NEED_TO_DOCUMENT

		(Callback) UIElement.onMouseEvent( MouseEvent event ) end
		* A_CALLBACK_I_NEED_TO_DOCUMENT

		(Callback) UIElement.onKeyboardEvent( KeyboardEvent event ) end
		* A_CALLBACK_I_NEED_TO_DOCUMENT

		(Callback) UIElement.onTextEvent( TextEvent event ) end
		* A_CALLBACK_I_NEED_TO_DOCUMENT

		(Callback) UIElement.onParentChanged() end
		* A_CALLBACK_I_NEED_TO_DOCUMENT

		(Callback) UIElement.onParentResized() end
		* A_CALLBACK_I_NEED_TO_DOCUMENT

