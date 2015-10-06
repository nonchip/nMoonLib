import run_with_scope, defaultbl from require "moon"
import insert from require "table"

local parse_to_table

args = (first, ...)->
  if #{...}>0
    {first, ...}
  else
    first

call = (name, first, ...)=>
  if type(first) == "function"
    insert @_buffer, {:name, value: parse_to_table first, args ...}
  else
    insert @_buffer, {:name, value: args first, ...}

index = (name)=>
  (...) -> call @, name, ...

parse_to_table=(fn)->
  buf={}
  run_with_scope fn, defaultbl({_buffer:buf},index)
  buf

parse_to_table
