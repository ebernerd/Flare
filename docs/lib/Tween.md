
# Tween

### The Tween class is used internally by `UIAnimationHandler` to animate objects.

> Credit to kikito
>Copyright (c) 2011, Enrique García Cota
> All rights reserved.
> 
> Redistribution and use in source and binary forms, with or without modification, 
> are permitted provided that the following conditions are met:
> 
>   1. Redistributions of source code must retain the above copyright notice, 
>      this list of conditions and the following disclaimer.
>   2. Redistributions in binary form must reproduce the above copyright notice, 
>      this list of conditions and the following disclaimer in the documentation 
>      and/or other materials provided with the distribution.
>   3. Neither the name of tween.lua nor the names of its contributors 
>      may be used to endorse or promote products derived from this software 
>      without specific prior written permission.
> 
> THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
> ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
> WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
> IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
> INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
> BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
> LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
> OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
> OF THE POSSIBILITY OF SUCH DAMAGE.
> 
> =====================================================================================
> 
> The easing functions were taken from emmanuelOga's easing functions
> (https://github.com/EmmanuelOga/easing).
> 
> Here's its license:
> 
> Tweener authors,
> Yuichi Tateno,
> Emmanuel Oga
> 
> The MIT License
> --------
> Copyright (c) 2010, Emmanuel Oga.
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
> 
> =====================================================================================
> 
> Emmanuel Oga's functions, in turn, were adapted from Penner's Easing Equations 
> and http://code.google.com/p/tweener/ (jstweener javascript version)
> 
> Disclaimer for Robert Penner's Easing Equations license:
> 
> TERMS OF USE - EASING EQUATIONS
> 
> Open source under the BSD License.
> 
> Copyright © 2001 Robert Penner
> All rights reserved.
> 
> Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
> 
>     * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
>     * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
>     * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.
> 
> THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

---

### Constructor

`Tween( table subject, table target, number duration, string easing )`

* easing defaults to 'Tween.DEFAULT_EASING', which is "inOutSine"
* duration defaults to 'Tween.DEFAULT_DURATION', which is .3
* the subject is the object you wish to perform the tween on
* the target is a table containing all the values you want animated

---

### Variables

`Tween.duration` - `number`

* the duration of the tween

`Tween.subject` - `table`

* the subject of the tween

`Tween.initial` - `table`

* a copy of the subject holding its starting values

`Tween.target` - `table`

* the target for the values you want animated

`Tween.easing` - `string`

* the easing to use

`Tween.clock` - `number`

* the current clock time (0 -> duration)

`Tween.round` - `bool`

* whether or not to round values, useful for coordinate or size information

---

### Methods

`Tween:set( number clock )`

* sets the clock to that given and updates the values of the subject

`Tween:update( number dt )`

* adds dt to the clock and updates the values of the subject

`Tween:reset()`

* sets the clock back to 0
