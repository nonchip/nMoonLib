ffi=require'ffi'
moon=require 'moon'
moonbase=require 'moonscript.base'

_access=(lib,symbol)->
  return lib[symbol]

check=(lib,symbol)->
  ok,v = pcall(_access,lib,symbol)
  return ok and v or nil


isnil=(value)->
  return ((type(value)=="nil") or (value==ffi.NULL))


cdef=(lib,cprefix="CDEF",lprefix="LDEF",mprefix="MDEF")->
  local l,m
  sanelib=string.gsub(lib,'%.so.*$','')
  sanelib=string.gsub(sanelib,'^.*/','')
  sanelib=string.gsub(sanelib,'[^a-zA-Z0-9]','_')
  if cprefix 
    ffi.cdef('const char* '..cprefix..'_'..sanelib..';')
  if lprefix
    ffi.cdef('const char* '..lprefix..'_'..sanelib..';')
  if mprefix
    ffi.cdef('const char* '..mprefix..'_'..sanelib..';')
  handle=ffi.load(lib)
  if cprefix
    cd=check(handle,cprefix..'_'..sanelib)
    if cd
      ffi.cdef ffi.string cd
  if lprefix
    ld=check(handle,lprefix..'_'..sanelib)
    if ld
      l=moon.run_with_scope((assert loadstring ffi.string(ld),lprefix..'_'..sanelib,"bt"), {C:handle})
  if mprefix
    md=check(handle,mprefix..'_'..sanelib)
    if md
      m=moon.run_with_scope((assert moonbase.loadstring ffi.string(md),mprefix..'_'..sanelib,"bt"), {C:handle,L:l})
  return handle,l,m

ycdef=(lib)-> cdef lib, 'YCDEF',nil,nil

{:check,:isnil,:cdef,:ycdef}
