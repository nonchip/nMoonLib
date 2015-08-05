#!/bin/zsh

cd "$(dirname "$(readlink -f "$1")")"

awk '/^\-\-\-\-/ {ofn="/tmp/split_" $2 ".bin"} ofn {print > ofn}' "$(basename "$1")"

echo "const char CDEF_$(basename "$1" .c)_A[]={" > /tmp/defs.c
tail -n +2 /tmp/split_CDEF.bin | xxd -i >> /tmp/defs.c
echo ",0}; const char LDEF_$(basename "$1" .c)_A[]={" >> /tmp/defs.c
tail -n +2 /tmp/split_LDEF.bin | xxd -i >> /tmp/defs.c
echo ",0}; const char MDEF_$(basename "$1" .c)_A[]={" >> /tmp/defs.c
tail -n +2 /tmp/split_MDEF.bin | xxd -i >> /tmp/defs.c
echo ",0};" >> /tmp/defs.c
cat >>/tmp/defs.c <<END
const char *CDEF_$(basename "$1" .c)=&CDEF_$(basename "$1" .c)_A[0];
const char *LDEF_$(basename "$1" .c)=&LDEF_$(basename "$1" .c)_A[0];
const char *MDEF_$(basename "$1" .c)=&MDEF_$(basename "$1" .c)_A[0];
END

gcc -shared -Wall -fPIC $2 "$(basename "$1")" /tmp/defs.c -o "$(basename "$1" .c).so"
rm /tmp/split_*.bin /tmp/defs.c
