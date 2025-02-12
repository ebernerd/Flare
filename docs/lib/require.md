
# The require function

Usage:

`require( string class )`
`(table) library = require( string library )`

Require is the function that lets you load both your own project files and Flare files. If you want to require something, you **must** put it at the top of the file. This is because of how Flare detects what files to include in a build.

When you require something more than once, it doesn't load it again, but it returns whatever the file returned the first time it was loaded (even if it returned nil).

The file name you pass into require is relative and formatted like this:

	file -> file.lua
	dir.file -> dir/file.lua

Let's say you use this to build your project:

	build project /

When you require something, it will first look in `project`, then in `/`, then in `Flare/lib`, then in `Flare/lib/elements` in that order. This means you can override Flare classes with your own ones by placing them in the project folder with the same name, although you should only do this if you **really** know what you're doing.
