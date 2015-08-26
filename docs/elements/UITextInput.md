
# UITextInput

### The UITextInput element is an element for getting single line, unformatted text input.

![Oh noes!](http://puu.sh/jGVTp/afd5231f63.png)

---

### Constructor

`UITextInput( number x, number y, number width )`

* creates the UITextInput field

---

### Variables

`UITextInput.text` - `string`

* the text of the field

`UITextInput.mask` - `string`

* the masked chars of the field
* ideal for password fields

`UITextInput.colour` - `number`

* the background colour of the object

`UITextInput.textColour` - `number`

* the text colour of the object

`UITextInput.focussedColour` - `number`

* the focussed background colour of the object

`UITextInput.focussedTextColour` - `number`

* the focussed text colour of the object

`UITextInput.selectedColour` - `number`

* the background colour of selected text of the object

`UITextInput.selectedTextColour` - `number`

* the text colour of selected text of the object

`UITextInput.cursor` - `number`

* the position for the cursor, where 0 is the first character

`UITextInput.selection` - `number`

* the position of the selection, where 0 is the first character
* if this is 1, and cursor is 2, the second and third character will be selected

`UITextInput.focussed` - `number`

* returns whether the field is focussed or not
* note, you can now change this to false to unfocus a text input object

---

### Methods

`UITextInput:write( string text )`

* writes the text to the object, replacing selected text if necessary, and updating the cursor position

`UITextInput:focusOn()`

* focusses on the object so the user can write in it
* this is done automatically when the user clicks on the element
