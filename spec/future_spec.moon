describe "Future class", ->
  local Future, instance, cache
  it "can be loaded", ->
    Future=require "nMoonLib.future"
  it "can be initialized", ->
    instance=Future!
  it "can be passed around", ->
    cache=instance
  it "can then be changed", ->
    instance\now class
      x: => 2+3
  it "is now changed everywhere", ->
    assert.are.equal(cache, instance)
    assert.are.equal(cache\x!, 5)
