
# UIText

### The UIText element is an object for displaying formatted text using Flare's own format (see the end of this document).

![Oh noes!](http://puu.sh/jGVf5/65d285861a.png)

---

### Constructor

`UIText( number x, number y, number width, number height, string text )`

* creates a text object

---

### Variables

`UIText.colour` - `number`

* the background colour of the object

`UIText.textColour` - `number`

* the text colour of the object

`UIText.text` - `string`

* the text of the object

`UIText.selectedColour` - `number`

* the background colour of selected text

`UIText.selectedTextColour` - `number`

* the text colour of selected text

`UIText.alignment` - `string`

* the vertical text alignment

`UIText.wrap` - `bool`

* whether word wrap the text in the object

`UIText.selectable` - `bool`

* whether the text is selectable

`UIText.internalWidth` - `number`

* the width to wrap the text to, defaults to the element's width

`UIText.internalHeight` - `number`

* the height to wrap the text to, defaults to (nothing, no height wrapping)

---

### Methods

`UIText:updateText()`

* reformats the text, called internalls

`UIText:getContentWidth()` returns `number width`

* returns the max width of the content

`UIText:getContentHeight()` returns `number height`

* returns the height of the content

`UIText:getDisplayWidth()` returns `number width`

* returns the width of the text object, used internally for the scrollbars

`UIText:getDisplayHeight()` returns `number height`

* returns the height of the text object, used internally for the scrollbars

`UIText:getHorizontalOffset()` returns `number offset`

* returns the horizontal offset of the text object, used internally for the scrollbars

`UIText:getVerticalOffset()` returns `number offset`

* returns the vertical offset of the text object, used internally for the scrollbars

`UIText:setHorizontalOffset( number scroll )`

* sets the horizontal offset of the text object, used internally for the scrollbars

`UIText:setVerticalOffset( number scroll )`

* sets the vertical offset of the text object, used internally for the scrollbars

---

# Some notes on text formatting

Text formatting in Flare is used by typing @[function]...

There are currently 5 functions
	Alignment: a
		- takes l, r or c to align text horizontally
		- i.e. "@ac" to centre align

	Text colour: t
		- takes a value from the colour identifiers below to set the text colour of following text
		- i.e. "@tb" to set the text colour to blue

	Background colour: b
		- takes a value from the colour identifiers below to set the background colour of following text
		- i.e. "@tb" to set the background colour to blue

	Link: l
		- formatted like so:
			@l[display](link)
		- will trigger onLinkFollowed() of the parent object, but not yet implemented

	Marker: m
		- formatted like so:
			@m(link)
		- will be used for identifying the position of characters after being wrapped and formatted, but not yet implemented

You can also use @ as an escape character, so "@@" will be a single @ in the text object.

Colour identifiers:
* 0 = white
* 1 = orange
* 2 = magenta
* 3 = lightBlue
* 4 = yellow
* 5 = lime
* 6 = pink
* 7 = grey
* 8 = lightGrey
* 9 = cyan
* a = purple
* b = blue
* c = brown
* d = green
* e = red
* f = black
*   = transparent (space)

Example:
	
```lua
local obj = UIText( 0, 0, 20, 5, "@ac@tb@bfHello world" )
```

Output:
	
	Blue text colour, black background colour, and text centred within the boundaries of the object
