#!/bin/zsh

cd "$(dirname "$(readlink -f "$0")")"

./spec/ffi_spec_test1.c
./utils/mk_cdeflib.sh ./spec/ffi_spec_test2.c

for i in $(find src -name "*.litmoon")
  do sed -n '/^    / s/^    //p' $i > ${i:r}.moon
done
