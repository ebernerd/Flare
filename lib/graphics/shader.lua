
local shader = {}

shader.darken = {
	[colours.white] = colours.lightGrey, [colours.orange] = colours.brown, [colours.magenta] = colours.purple, [colours.lightBlue] = colours.cyan;
	[colours.yellow] = colours.orange, [colours.lime] = colours.green, [colours.pink] = colours.magenta, [colours.grey] = colours.black;
	[colours.lightGrey] = colours.grey, [colours.cyan] = colours.blue, [colours.purple] = colours.grey, [colours.blue] = colours.grey;
	[colours.brown] = colours.black, [colours.green] = colours.grey, [colours.red] = colours.brown, [colours.black] = colours.black;
}
shader.lighten = {
	[colours.white] = colours.white, [colours.orange] = colours.yellow, [colours.magenta] = colours.pink, [colours.lightBlue] = colours.white;
	[colours.yellow] = colours.white, [colours.lime] = colours.white, [colours.pink] = colours.white, [colours.grey] = colours.lightGrey;
	[colours.lightGrey] = colours.white, [colours.cyan] = colours.lightBlue, [colours.purple] = colours.magenta, [colours.blue] = colours.cyan;
	[colours.brown] = colours.red, [colours.green] = colours.lime, [colours.red] = colours.orange, [colours.black] = colours.grey;
}
shader.greyscale = {
	[colours.white] = 1, [colours.orange] = 256, [colours.magenta] = 256, [colours.lightBlue] = 256;
	[colours.yellow] = 1, [colours.lime] = 256, [colours.pink] = 1, [colours.grey] = 256;
	[colours.lightGrey] = 256, [colours.cyan] = 128, [colours.purple] = 128, [colours.blue] = 32768;
	[colours.brown] = 32768, [colours.green] = 128, [colours.red] = 128, [colours.black] = 32768;
}
shader.sepia = {
	[colours.white] = 1, [colours.orange] = 2, [colours.magenta] = 2, [colours.lightBlue] = 2;
	[colours.yellow] = 1, [colours.lime] = 2, [colours.pink] = 1, [colours.grey] = 2;
	[colours.lightGrey] = 2, [colours.cyan] = 16, [colours.purple] = 16, [colours.blue] = 4096;
	[colours.brown] = 4096, [colours.green] = 16, [colours.red] = 16, [colours.black] = 4096;
}

return shader
