
### clipboard

The clipboard library is how you put data into the clipboard and get data from it.

---

### Methods

`clipboard.put( table t )`

* puts a set of items into the clipboard
* t is formatted like so:

```lua
	{
		{ type, value };
		{ "plaintext", "some text" }; -- for example
	}
```

`clipboard.empty()`

* clears the clipboard

`clipboard.get( string type )` returns `any value`

* returns the value of something in the clipboard with the type given, i.e. "plaintext"
* returns nil if that type isn't in the clipboard

