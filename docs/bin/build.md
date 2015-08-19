
# Building Flare projects

You can (and have to) build Flare projects into files before running them. You do this with `Flare/bin/build`, or `Flare/bin/debug` (see `debug.md`)

Tip: Use this snippet to add `Flare/bin` to the shell path so you can type `build` into the shell to build something:
`shell.setPath( "Flare/bin/:" .. shell.path() )`

The usage of `build` is as follows:

```
build [options] [dirs]

options:
	-o output - the output file (default=./run) without .lua, '.' is replaced with the project path
	-m main - the main file (default=init) without .lua
	-c - minify source code
	-f - include Flare source files in the build

dirs:
	Each directory given is added as a path that Flare looks in when requiring files

examples:
	build MyProject - builds MyProject with main file 'MyProject/init.lua' and outputs to 'MyProject/run.lua'
	build Test -m main -o ./out - builds Test with main file 'Test/main.lua' and outputs to 'Test/out.lua'
```

Let's say I have a project with this structure:

```
/project
	/main.lua
	/lib.lua
/lib2.lua
```

To build this, with `main.lua` as the starting file, you would use:

```
build -m main /project /
```

You'd then get a file `project/run.lua` which you can use to run your project.

You can change where it outputs to by using the `-o` flag:

```
build -m main -o ./built /project /
```

This would instead create a `project/built.lua` file, rather than `project/run.lua`.

You can also build to paths not in the project directory by not including the `.` or putting it somewhere else, for example:

```
build -m main -o builds/. /project /
```

That would create the output file `builds/demo.lua`.

# Can I include files not in the project folder?

Yes. You can add any path and Flare will look in it.

```
build project path1 path2 path3 "path4 and 5"
```

Flare will look in all those paths when you require a file, with `project` having the highest precedence. You don't even need your main file in the first project, as long as it's in one of them.

# What is a built file?

A built file is an entire project packed into a single file, with a short header that automatically installs Flare if it's not found. You can run a built file just like any other Lua file, and it will run just like any other Lua file.

# How do I distribute my programs?

All you need to do is share the single built file. Pastebin is a great tool to do this - you can create a new paste, put the contents of the built file in, and let the user download and run your program like this:

```
pastebin get [pastebin code] project.lua
project.lua
```

It's usually a good idea to put the source code of your project on something like GitHub with some explanation of how to use it or what it does.
