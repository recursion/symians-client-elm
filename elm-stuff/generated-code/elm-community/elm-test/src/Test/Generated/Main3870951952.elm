module Test.Generated.Main3870951952 exposing (main)

import World.CoordinatesTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test
import Json.Encode

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "World.CoordinatesTest" [World.CoordinatesTest.all] ]
        |> Test.concat
        |> Test.Runner.Node.runWithOptions { runs = Nothing, report = (ConsoleReport UseColor), seed = Nothing, processes = 2, paths = []}