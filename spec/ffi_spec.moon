describe "ffi helpers", ->
  local ffi,lib,c,l,m
  it "can be loaded", ->
    ffi=require "nMoonLib.ffi"
  it "can load YCDEF libs", ->
    lib=ffi.ycdef "spec/ffi_spec_test1.so"
  it "automatically loads the YCDEF definitions", ->
    assert.are.equal(lib.a,23)
    assert.are.equal(lib.b(2,3), 5)
  it "can protect us from crashing while accessing nil", ->
    assert.are.equal(ffi.check(lib,c), nil)
  it "can load our own CLMDEF libs", ->
    m,l,c=ffi.cdef "spec/ffi_spec_test2.so"
  it "automatically loads the C, Lua and moon definitions", ->
    assert.are.equal(c.a,1)
    assert.are.equal(l.b(2,3), 6)
    assert.are.equal(m.c,"blah")
  it "can wrap C functions", ->
    f=ffi.cwrap (require 'ffi').C, "int #atoi#(const char *str)", (str)=>
      1 + @ str..'0'
    assert.are.equal f'5', 51
