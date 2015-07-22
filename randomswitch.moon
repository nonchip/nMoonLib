randomswitch=do
  import random from require "math"
  (funcs, ...)-> funcs[random #funcs] ...



do class Example
  new:=>
  example:=>
    randomswitch {
      ->      @something
      ->      print "something"
      (a)->   print a
      (a,b)-> print a*b
    }, 1337, 42
  something:=>
    print "each of those inline closures above has a 1/4 chance of being called"