
# UIAnimationHandler

### The UIAnimationHandler class is used internally by all UI elements to handle animations.

---

### Constructor

`UIAnimationHandler()`

* creates a UIAnimationHandler object

---

### Methods

`UIAnimationHandler:killTween( string label )`
	- stops a tween with the label specified

`UIAnimationHandler:createTween( string label, table object, table target, number duration, string easing )`

* creates a tween to be performed on the object given
* the target contains a set of variables to be animated
* the easing defaults to `inOutSine` and can be ignored
* label is to avoid multiple tweens affecting the same value, i.e. having 2 animations of the `x` value

`UIAnimationHandler:createRoundedTween( string label, table object, table target, number duration, string easing )`

* creates a rounded tween to be performed on the object given
* the target contains a set of variables to be animated
* the easing defaults to `inOutSine` and can be ignored
* label is to avoid multiple tweens affecting the same value, i.e. having 2 animations of the `x` value
* this should be used in any coordinate or size animations

`UIAnimationHandler:update( dt )`

* updates the animation handler
* called internally, this need not be touched
