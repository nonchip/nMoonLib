(fn)->
  setmetatable {},{
    __call: (...)=>
      key=table.concat [tostring(a) or "_" for _,a in ipairs {...}], ";"
      @[key] = fn ... unless @[key]
      @[key]
  }
