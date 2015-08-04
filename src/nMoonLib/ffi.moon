ffi=require'ffi'

_access=(lib,symbol)->
  return lib[symbol]

check=(lib,symbol)->
  ok,v = pcall(_access,lib,symbol)
  return ok and v or nil


isnil=(value)->
  return ((type(value)=="nil") or (value==ffi.NULL))


ycdef=(lib,path)->
  sanelib=string.gsub(lib,'%.so.*$','')
  sanelib=string.gsub(sanelib,'[^a-zA-Z0-9]','_')
  ffi.cdef('const char* YCDEF_'..sanelib..';')
  handle=ffi.load(path and path.."/"..lib or lib)
  ffi.cdef(ffi.string(handle['YCDEF_'..sanelib]))
  return handle

{:check,:isnil,:ycdef}
