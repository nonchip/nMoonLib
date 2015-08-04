describe "ffi helpers", ->
  local ffi,lib
  it "can be loaded", ->
    ffi=require "nMoonLib.ffi"
  it "can load YCDEF libs", ->
    lib=ffi.ycdef "spec/ffi_spec_test.so"
  it "automatically loads the YCDEF definitions", ->
    assert.are.equal(lib.a,23)
    assert.are.equal(lib.b(2,3), 5)
  it "can protect us from crashing while accessing nil", ->
    assert.are.equal(ffi.check(lib,c), nil)
