module StartAppTest where

import ElmTest.Test as Test exposing (test, Test)
import ElmTest.Assertion exposing (assert, assertEqual)

suite = Test.suite "StartApp"
  [ test "Addition" <| assertEqual (3 + 7) 10
  ]
