class Future
  new: =>
    @obj=nil
    fb=getmetatable(@).__index
    setmetatable @, {
      __index: (k)=>
        o=rawget @, 'obj'
        if o
          return o[k]
        else
          return fb[k]
    }
  now: (@obj)=>



do class Example
  someClass: require "extern.foo.0"
  SomeClassThatExpectsSomeInitStuff: require "extern.foo.1"
  new:=>
    @something=someClass!
  example:=>
    @somevar=Future!
    @something\registerSomeCallback @somevar
    @something\doSomeInitStuff!
    @somevar\now @SomeClassThatExpectsSomeInitStuff!