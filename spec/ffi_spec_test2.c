#if 0
cd "$(dirname "$(readlink -f "$0")")"

awk '/^\-\-\-\-/ {ofn="/tmp/split_" $2 ".bin"} ofn {print > ofn}' "$(basename "$0")"

echo "const char CDEF_$(basename "$0" .c)_A[]={" > /tmp/defs.c
tail -n +2 /tmp/split_CDEF.bin | xxd -i >> /tmp/defs.c
echo ",0}; const char LDEF_$(basename "$0" .c)_A[]={" >> /tmp/defs.c
tail -n +2 /tmp/split_LDEF.bin | xxd -i >> /tmp/defs.c
echo ",0}; const char MDEF_$(basename "$0" .c)_A[]={" >> /tmp/defs.c
tail -n +2 /tmp/split_MDEF.bin | xxd -i >> /tmp/defs.c
echo ",0};" >> /tmp/defs.c
cat >>/tmp/defs.c <<END
const char *CDEF_$(basename "$0" .c)=&CDEF_$(basename "$0" .c)_A[0];
const char *LDEF_$(basename "$0" .c)=&LDEF_$(basename "$0" .c)_A[0];
const char *MDEF_$(basename "$0" .c)=&MDEF_$(basename "$0" .c)_A[0];
END

gcc -shared -Wall -fPIC "$(basename "$0")" /tmp/defs.c -o "$(basename "$0" .c).so"
rm /tmp/split_*.bin /tmp/defs.c
exit

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
