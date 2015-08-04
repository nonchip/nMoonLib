#if 0
cd "$(dirname "$(readlink -f "$0")")"
gcc -shared -Wall -fPIC "$(basename "$0")" -o "$(basename "$0" .c).so"
exit
#endif

const char* CDEF_ffi_spec_test2=
  "const int a;"
;

const char* LDEF_ffi_spec_test2=
  "function b(x,y)\n"
  "  return C.a+x+y\n"
  "end\n"
  "str='blah'\n"
  "return {b=b,str=str}\n"
;

const char* MDEF_ffi_spec_test2=
  "ffi=require'ffi'\n"
  "c=ffi.string L.str\n"
  "{:c}\n"
;

const int a=1;
