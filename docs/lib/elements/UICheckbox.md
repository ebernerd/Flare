
# UICheckbox

### The UICheckbox is a 1x1 object with a toggleable mark in the centre.

![Oh noes!](http://puu.sh/jGQNF/3ab1db4b90.png)

* Note, you cannot change the width or height of this element.
* This element is a valid `link` for UILabel objects.

---

### Constructor

`UICheckbox( number x, number y )`

* creates a checkbox, 1 wide by 1 tall

---

### Callbacks

`UICheckbox:onToggle()`

* called when the checkbox is toggled

---

### Variables

`UICheckbox.colour` - `number`

* the background colour of the checkbox
* use values from the colours table, i.e. `colours.blue`
* this supports `0` as a colour for transparent

`UICheckbox.checkColour` - `number`

* the text colour of the checkbox
* use values from the colours table, i.e. `colours.blue`
* this supports `0` as a colour for transparent

`UICheckbox.check` - `string`

* the text the checkbox contains
* this is wordwrapped and centre aligned when drawn

`UICheckbox.toggled` - `bool`

* whether the checkbox is currently toggled
