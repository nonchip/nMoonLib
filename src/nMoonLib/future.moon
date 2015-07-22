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
