
# UIRadioButton

### The UIRadioButton is a 1x1 object with a toggleable mark in the centre that is linked to other objects in its group such that only one object is toggled on at a time.

![Oh noes!](http://puu.sh/jGSHu/c0023d4c04.png)

* Note, you cannot change the width or height of this object

---

### Constructor

`UIRadioButton( number x, number y )`

* creates a radio button, 1 wide by 1 tall

---

### Callbacks

`UIRadioButton:onToggle()`

* called when the radio button is toggled

---

### Variables

`UIRadioButton.colour` - `number`

* the background colour of the radio button
* use values from the colours table, i.e. `colours.blue`
* this supports 0 as a colour for transparent

`UIRadioButton.checkColour` - `number`

* the text colour of the radio button
* use values from the colours table, i.e. `colours.blue`
* this supports 0 as a colour for transparent

`UIRadioButton.check` - `string`

* the text the radio button contains
* this is wordwrapped and centre aligned when drawn

`UIRadioButton.toggled` - `bool`

* whether or not the radio button is currently toggled

`UIRadioButton.group` - `number/string`

* the group the radio button belongs to
