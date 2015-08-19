
# UILabel

### The UILabel is a 1 tall text element used for labelling other elements such as checkboxes.

![Oh noes!](http://puu.sh/jGSsI/8023752a98.png)

---

### Constructors

`UILabel( number x, number y, string text )`
`UILabel( number x, number y, string text, [UIElement] link )`
	
* creates a label, linked to the element if given (see `UILabel.link`)

---

### Variables

`UILabel.textColour` - `number`

* the text colour of the label
* use values from the colours table, i.e. `colours.blue`
* this supports `0` as a colour for transparent


`UILabel.text` - `string`

* the text the label contains
* note, changing this updates the width of the label

`UILabel.link` - `[UIElement]`

* the element the label is linked with
* when the label is clicked, if its link has an onLabelPressed() method, that will be called
* currently supported inbuilt elements are
	* UICheckbox
	* UIRadioButton
	* UIToggle
