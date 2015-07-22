moon=require "moon"

string=require "string"

class String
  new: (@str)=> -- yep, that's how you wrap the string library -_-
    mt=getmetatable @
    oldidx=mt.__index
    mt.__index=(k)=>
      if oldidx[k]
        return oldidx[k]
      else
        return (_,...)->
          string[k] @str, ...
  __tostring: =>
    @str
  startsWith:(str)=>
    @=tostring @
    return str=='' or string.sub(@,1,string.len(str))==str
  endsWith:(str)=>
    @=tostring @
    return str=='' or string.sub(@,-string.len(str))==str
  trim:=>
    @=tostring @
    @\match'^()%s*$' and '' or @\match'^%s*(.*%S)'
