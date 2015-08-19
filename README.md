# Flare

Flare is a GUI framework for ComputerCraft. It supports the following elements:

* UIButton
* UICheckbox
* UIColourSelector
* UIContainer
* UIFileDialogue (currently undocumented)
* UIImage
* UILabel
* UIMenu (currently undocumented)
* UIPanel
* UIRadioButton
* UITabs
* UITerminal
* UIText
* UITextInput
* UIToggle
* UIView
* UIWindow

It's easy to make a Flare application. A hello world in Flare:

```lua
require "UIButton"

local button = application.view:addChild( UIButton( 0, 0, 20, 5, "Hello world!" ) )
button.colour = colours.cyan
button.textColour = colours.white
```

Then to run it, `Flare/build/debug MyProject`

There's more to it than that, but read through the docs for more information (the docs folder in the repo). `Getting Started.md` is a great place to start.
