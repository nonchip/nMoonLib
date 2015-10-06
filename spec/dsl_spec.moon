describe "DSL", ->
  local dsl, cache
  it "can be loaded", ->
    dsl=require "nMoonLib.dsl"
  it "can parse to table", ->
    cache = dsl ->
      a ->
        b ->
          c 5
          d 3, 4
        e 7
      f "blah"
      g ->
        h 2
  it "does so as expected", ->
    expected = {
      {name: "a", value: {
        {name: "b", value: {
          {name: "c", value: 5}
          {name: "d", value: {3,4}}
        }}
        {name: "e", value: 7}
      }}
      {name: "f", value: "blah"}
      {name: "g", value: {
        {name: "h", value: 2}
      }}
    }
    assert.are.same expected, cache
