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
    @=tostring @ -- all those functions return pure strings, do e.g. `String (String "blah  ")\trim!` to get an object back
    return str=='' or string.sub(@,1,string.len(str))==str
  endsWith:(str)=>
    @=tostring @
    return str=='' or string.sub(@,-string.len(str))==str
  trim:=>
    @=tostring @
    @\match'^()%s*$' and '' or @\match'^%s*(.*%S)'
  gsplit:(sep, plain)=> -- if you want to split to table, just [s for s in *gsplit]
    @=tostring @
    start = 1
    done = false
    pass=(i, j, ...)->
      if i
        seg = @\sub(start, i - 1)
        start = j + 1
        return seg, ...
      else
        done = true
        return @\sub(start)
    return ->
      return if done
      if sep == ''
        done = true
        return @
      return pass @\find sep, start, plain
