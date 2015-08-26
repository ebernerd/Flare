
# UIPanel

### The UIPanel is an object used for giving an area a colour and preventing click events from being handled by elements below it.

![Oh noes!](http://puu.sh/jGSCi/d8bb638c88.png)

---

### Constructors

`UIPanel( number x, number y, number width, number height )`
`UIPanel( number x, number y, number width, number height, number colour )`

* creates a panel, setting its colour if given

---

### Variables

`UIPanel.colour` - `number`
	- the background colour of the panel
	- use values from the colours table, i.e. `colours.blue`
	- this supports `0` as a colour for transparent
