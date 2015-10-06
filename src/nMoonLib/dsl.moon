import run_with_scope, defaultbl from require "moon"
import insert from require "table"

local parse_to_table

call = (name, first, arg)=>
  if type(first) == "function"
    insert @_buffer, {:name, value: parse_to_table first, arg}
  else
    insert @_buffer, {:name, value: first}

index = (name)=>
  (...) -> call @, name, ...

parse_to_table=(fn, ...)->
  buf={}
  run_with_scope fn, defaultbl({_buffer:buf},index), @, ...
  buf

parse_to_table
