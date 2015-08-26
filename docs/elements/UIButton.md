
# UIButton

### The UIButton is a clickable object with centre-aligned wordwrapped text.

![Oh noes!](http://puu.sh/jGQan/7fc94de1dc.png)

---

### Constructor

`UIButton ( number x, number y, number width, number height, string text = "" )`

* creates a button object

---

### Callbacks

`UIButton:onClick()`

* called when the button is clicked

---

### Variables

`UIButton.colour` - `number`

* the background colour of the button
* use values from the colours table, i.e. `colours.blue`
* this supports `0` as a colour for transparent

`UIButton.textColour` - `number`

* the text colour of the button
* use values from the colours table, i.e. `colours.blue`
* this supports `0` as a colour for transparent

`UIButton.text` - `number`

* the text the button contains
* this is wordwrapped and centre aligned when drawn

`UIButton.holding` - `bool`

* tracks whether the button is being held by the user (mouse down on it)
* this should not be changed manually
