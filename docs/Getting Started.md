
Getting Started with Flare.

First, download Flare, of course. Next, you'll need to make a folder to contain your project, let's say `MyProject`, and inside, make an `init.lua` file. Inside `init.lua` is where your main application code goes.

Below is an example script that creates a button that moves to and from x=20 and x=0, animated.

```lua
require "UIButton"

local button = application.view:addChild( UIButton( 0, 0, 20, 5, "Hello world!" ) )
button.colour = colours.cyan
button.textColour = colours.white

local state = false
function button:onClick()
	self.animatedX = state and 0 or 20
	state = not state
end
```

Now, you'll want to run the project. Use the `build` file in Flare/bin to do this.

	Flare/bin/build MyProject

Now, you'll have a file `MyProject/run.lua` that you can run. You can distribute this and it will automatically download Flare if not installed.

See `docs/bin/build.md` for more information on building projects.

Right now, there aren't really any tutorials for Flare. You'd be best off looking through the demo linked on the forum post, and having a careful look through all the documentation. UIElement is the longest one, but to an extent the most important. It's also a good idea to understand the text markup system for UIText objects, so look at that too. As for the graphics, you don't really need to know anything about that unless you plan on making your own elements, and /util and /Event is internal stuff, so you can ignore it unless you plan on extending Flare. Right now, only the elements and core parts are documented, which should be all you need.

Regarding extending Flare, it's probably worth waiting for the tutorials I'm planning on writing. If you can't wait, here are some tips:

Classes that extend UIElement have 'setters', so if you define "setX" and do 'object.x = blah', setX() is called with 'blah' as its first and only parameter, i.e.

```lua
function MyClass:setX( blah )
	self.x = blah
end
```

Setting the variable inside the setter is fine, the class library won't infinitely call the setter. You may want to use the raw table for speed however, 'self.raw.x = blah'.

'The best way to learn is to observe' - take a look through some of the elements in /lib/elements. UIButton is a great place to start for making simple objects. UIWindow is good if you want to make an element that contains a set of other elements. UIText shows how the text utilities work.
