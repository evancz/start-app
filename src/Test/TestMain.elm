module Main where

import IO.IO exposing (..)
import IO.Runner exposing (Request, Response, run)

import ElmTest.Test as Test
import ElmTest.Runner.Console as Console

import StartAppTest

allTests = Test.suite ""
  [ StartAppTest.suite
  ]

testRunner : IO ()
testRunner = Console.runDisplay allTests

port requests : Signal Request
port requests = run responses testRunner

port responses : Signal Response
