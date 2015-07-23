describe "String class", ->
  describe "is nonintrusive", ->
    String=require "nMoonLib.string"
    local str
    it "can operate on any string", ->
      assert.is_true  String.startsWith "ABCDEF", "ABC"
      assert.is_false String.endsWith "herpderp", "DEF"
    it "can wrap a string", ->
      str=String "blah"
    it "can operate on a wrapped string", ->
      assert.is_true  str\startsWith "b"
      assert.is_false str\endsWith "b"
    it "defines tostring", ->
      assert.is_equal "blah", tostring(str)
    it "inherits from stdlib/string", ->
      assert.is_equal 4, str\len!
    it "has .str property", ->
      assert.is_equal "blah", str.str
    it "is a reference", ->
      str.str="abc"
      assert.is_true str\startsWith "a"
  describe "can be made intrusive", ->
    require "nMoonLib.string.install"
    it "can now operate transparently", ->
      assert.is_true "asdf"\startsWith "a"
    it "does not pollute string.__tostring", ->
      assert.is_equal "asdf", tostring("asdf")
  describe "has features", ->
    String=require "nMoonLib.string"
    it "supports startsWith", ->
      assert.is_true  String.startsWith "ABCDEF", "ABC"
      assert.is_false String.startsWith "ABCDEF", "DEF"
    it "supports endsWith", ->
      assert.is_true  String.endsWith "ABCDEF", "DEF"
      assert.is_false String.endsWith "ABCDEF", "ABC"
    a="  abc\n "
    it "supports trim", ->
      assert.is_equal "abc", String.trim a
    it "has trim without side effects", ->
      assert.is_equal a, "  abc\n "
    it "supports gsplit", ->
      assert.is_equal "b", ([s for s in String.gsplit "a,b,c", ","])[2]
