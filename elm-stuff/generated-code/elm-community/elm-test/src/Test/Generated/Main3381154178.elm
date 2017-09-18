module Test.Generated.Main3381154178 exposing (main)

import Coordinates

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test
import Json.Encode

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Coordinates" [Coordinates.all] ]
        |> Test.concat
        |> Test.Runner.Node.runWithOptions { runs = Nothing, report = (ConsoleReport UseColor), seed = Nothing, processes = 2, paths = []}