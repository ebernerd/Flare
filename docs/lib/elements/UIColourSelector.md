
# UIColourSelector

### The UIColourSelector is an object used for the user to select colours.

![Oh noes!](http://puu.sh/jGQY7/a52321f02c.png)

* Note, the width and height of this object are rounded to the nearest multiple of the ratio. This means that if you have a ratio of `1` (`4/4`), and set the width to `9`, the width will actually become `8`.

---

### Constructor

`UIColourSelector( number x, number y, number width, number height, number ratio = 4/4 )`

* creates a colour selector object

---

### Callbacks

`UIColourSelector:onSelect( number colour )`

* called with the colour the user pressed

---

### Variables

`UIColourSelector.ratio` - `number`

* the ratio of columns to rows of the colour selector
* supported ratios are `1/16`, `2/8`, `4/4`, `8/2`, `16/1`
* using an unsupported ratio will result in an error
