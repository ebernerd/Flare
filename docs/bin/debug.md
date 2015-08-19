
# Debugging Flare projects

Debugging a project is just building and running it in one go. You can use `Flare/bin/debug` to do this.

Tip: Use this snippet to add `Flare/bin` to the shell path so you can type `debug` into the shell to debug something:
`shell.setPath( "Flare/bin/:" .. shell.path() )`

The arguments you pass to `debug` are the same as the ones you pass to `build` (see `build.md`).
