#if 0
cd "$(dirname "$(readlink -f "$0")")"
gcc -shared -Wall -fPIC "$(basename "$0")" -o "$(basename "$0" .c).so"
exit
#endif
const char* YCDEF_ffi_spec_test=
  "const int a;"
  "int b(int,int);"
;

const int a=23;

int b(int x,int y){
  return x+y;
}