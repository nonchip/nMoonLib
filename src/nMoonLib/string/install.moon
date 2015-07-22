String=require "nMoonLib.string"
mt=getmetatable("")
oldidx=mt.__index
mt.__index=(key)=>
  String.__base[key] or oldidx[key]

_G.string=String
