#if 0

---- CDEF
const int a;

---- LDEF
function b(x,y)
  return C.a+x+y
end
str='blah'
return {b=b,str=str}

---- MDEF
ffi=require'ffi'
local c
if C.a==1
  c=ffi.string L.str
else
  c='that shouldn\'t happen'
{:c}
---- END

#endif

const int a=1;
