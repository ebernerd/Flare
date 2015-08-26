
# UITabs

### The UITabs element is an object containing a list of string tabs that can be selected. It automatically adds < and > buttons if the width of the tabs combined exceeds the width of the element.

![Oh noes!](http://puu.sh/jGT1A/46570289aa.png)
![Oh noes!](http://puu.sh/jGT24/16e74797c9.png)

* Note, the height of this object cannot be changed from 1.
* Also note, to add or remove options to this, you have to do a little hacky method:

```lua
-- manipulate options table, i.e. table.insert( element.options, "woah" )
element.width = element.width -- calls the setter getting it to update things
```

* A penultimate note, `UITabs` elements don't contain content themselves, since that is not their only purpose. If you want to switch between views, you can use the `onSelect()` callback to trigger a view switch, and contain the other views in a container or other element.
* Finally, note that the default `selected` is `0`, i.e. nothing, so you should manually call `select( 1 )` after setting the options table.

---

### Constructor

`UITabs( number x, number y, number width, table{string} options )`

* creates a UITabs element with the options given

---

### Callbacks

`UITabs:onSelect()`

* called when an option is selected, after 'self.selected' is updated

---

### Variables

`UITabs.selected` - `number`

* the currently selected tab, with 1 being the first tab, and #options being the last

`UITabs.showButtons` - `bool`

* whether the tabs object is showing tabs

`UITabs.colour` - `number`

* the background colour of unselected tabs
* uses values from the colours table, i.e. `colours.blue`
* this supports 0 as a colour for transparent

`UITabs.textColour` - `number`

* the text colour of unselected tabs
* uses values from the colours table, i.e. `colours.blue`
* this supports 0 as a colour for transparent

`UITabs.selectedColour` - `number`

* the background colour of selected tabs
* uses values from the colours table, i.e. `colours.blue`
* this supports 0 as a colour for transparent

`UITabs.selectedTextColour` - `number`

* the text colour of selected tabs
* uses values from the colours table, i.e. `colours.blue`
* this supports 0 as a colour for transparent

`UITabs.buttonColour` - `number`

* the background colour of the buttons to the left and right of the tabs if shown
* uses values from the colours table, i.e. `colours.blue`
* this supports 0 as a colour for transparent

`UITabs.buttonTextColour` - `number`

* the text colour of the buttons to the left and right of the tabs if shown
* uses values from the colours table, i.e. `colours.blue`
* this supports 0 as a colour for transparent

`UITabs.separator` - `string`

* the separator character between tabs

`UITabs.seperatorTextColour` - `number`

* the text colour of the separator between tabs
* uses values from the colours table, i.e. `colours.blue`
* this supports 0 as a colour for transparent

---

### Methods

`UITabs:select( number index )`

* selects the index given and animates its selection bar

`UITabs:getContentWidth()` returns `number width`

* returns the width of the tabs' content
