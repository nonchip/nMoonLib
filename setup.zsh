#!/bin/zsh

export NMLT_PATH="$(dirname $(readlink -f $0))"
export NMLT_REAL_ROOT="$NMLT_PATH/.root"
export NMLT_SRC="$NMLT_PATH/.src"
export NMLT_ROOT="/tmp/.nMLt.$(uuidgen -t)-$(uuidgen -r)"

continue_stage=n
if [ -f "$NMLT_PATH/.continue_stage" ]
  then continue_stage=$(cat "$NMLT_PATH/.continue_stage")
fi

if [ -f "$NMLT_PATH/.continue_root" ]
  then NMLT_ROOT=$(cat "$NMLT_PATH/.continue_root")
fi

case $continue_stage in
  n)
    rm -f "$NMLT_PATH/.continue_stage"
    rm -rf "$NMLT_ROOT" "$NMLT_SRC" "$NMLT_REAL_ROOT"
    mkdir -p "$NMLT_REAL_ROOT" "$NMLT_SRC"
    ln -s "$NMLT_REAL_ROOT" "$NMLT_ROOT"
    echo "$NMLT_ROOT" > "$NMLT_PATH/.continue_root"
    ;&
  luajit)
    echo "luajit" > "$NMLT_PATH/.continue_stage"
    cd $NMLT_SRC
    git clone http://luajit.org/git/luajit-2.0.git luajit || exit
    cd luajit
    git checkout v2.1
    git pull
    make amalg PREFIX=$NMLT_ROOT CPATH=$NMLT_ROOT/include LIBRARY_PATH=$NMLT_ROOT/lib && \
    make install PREFIX=$NMLT_ROOT || exit
    ln -sf luajit-2.1.0-alpha $NMLT_ROOT/bin/luajit
    ;&
  luarocks)
    echo "luarocks" > "$NMLT_PATH/.continue_stage"
    cd $NMLT_SRC
    git clone git://github.com/keplerproject/luarocks.git || exit
    cd luarocks
    ./configure --prefix=$NMLT_ROOT \
                --lua-version=5.1 \
                --lua-suffix=jit \
                --with-lua=$NMLT_ROOT \
                --with-lua-include=$NMLT_ROOT/include/luajit-2.1 \
                --with-lua-lib=$NMLT_ROOT/lib/lua/5.1 \
                --force-config && \
    make build && make install || exit
    ;&
  moonscript)
    echo "moonscript" > "$NMLT_PATH/.continue_stage"
    $NMLT_ROOT/bin/luarocks install https://raw.githubusercontent.com/nonchip/moonscript/master/moonscript-dev-1.rockspec || exit
    ;&
  busted)
    echo "busted" > "$NMLT_PATH/.continue_stage"
    $NMLT_ROOT/bin/luarocks install busted || exit
    ;&
  c_helpers)
    echo "c_helpers" > "$NMLT_PATH/.continue_stage"
    "$NMLT_PATH"/spec/ffi_spec_test1.c
    "$NMLT_PATH"/utils/mk_cdeflib.sh "$NMLT_PATH"/spec/ffi_spec_test2.c
    ;&
  wrappers)
    echo "wrappers" > "$NMLT_PATH/.continue_stage"
    # wrappers
    cat > $NMLT_PATH/.run <<END
#!/bin/zsh
export NMLT_PATH="\$(dirname "\$(readlink -f "\$0")")"
export NMLT_REAL_ROOT="\$NMLT_PATH/.root"
export NMLT_ROOT="$NMLT_ROOT"

[ -e "\$NMLT_ROOT" ] || ln -s "\$NMLT_PATH/.root" \$NMLT_ROOT

export PATH="\$NMLT_ROOT/bin:\$PATH"
export LUA_PATH="\$NMLT_PATH/custom_?.lua;\$NMLT_PATH/src/?/init.lua;\$NMLT_PATH/src/?.lua;\$NMLT_PATH/?.lua;\$LUA_PATH;\$NMLT_ROOT/lualib/?.lua;\$NMLT_ROOT/share/luajit-2.1.0-alpha/?.lua;\$NMLT_ROOT/share/lua/5.1/?.lua;\$NMLT_ROOT/share/lua/5.1/?/init.lua"
export LUA_CPATH="\$NMLT_PATH/custom_?.so;\$NMLT_PATH/src/?/init.so;\$NMLT_PATH/src/?.so;\$NMLT_PATH/?.so;\$LUA_CPATH;\$NMLT_ROOT/lualib/?.so;\$NMLT_ROOT/share/luajit-2.1.0-alpha/?.so;\$NMLT_ROOT/share/lua/5.1/?.so;\$NMLT_ROOT/share/lua/5.1/?/init.so"
export MOON_PATH="\$NMLT_PATH/custom_?.moon;\$NMLT_PATH/src/?/init.moon;\$NMLT_PATH/src/?.moon;\$NMLT_PATH/?.moon;\$MOON_PATH;\$NMLT_ROOT/lualib/?.moon;\$NMLT_ROOT/share/luajit-2.1.0-alpha/?.moon;\$NMLT_ROOT/share/lua/5.1/?.moon;\$NMLT_ROOT/share/lua/5.1/?/init.moon"
export LD_LIBRARY_PATH="\$NMLT_ROOT/lib:\$LD_LIBRARY_PATH"

fn=\$(basename \$0)
if [ "\$fn" = ".run" ]
  then exec "\$@"
else
  exec \$fn "\$@"
fi
END
    chmod a+rx $NMLT_PATH/.run
    ln -sf .run $NMLT_PATH/moon
    ln -sf .run $NMLT_PATH/busted
    ;&
esac

# cleanup
rm -rf "$NMLT_SRC"
rm -f "$NMLT_ROOT" "$NMLT_PATH/.continue_stage" "$NMLT_PATH/.continue_root"
