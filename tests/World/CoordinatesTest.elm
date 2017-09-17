module World.CoordinatesTest exposing (..)

import Test exposing (..)
import Expect
import World.Models exposing (Coordinates)
import World.Coordinates as Coords

all : Test
all =
    describe "Coordinates"
        [ test "is a record of ints x, y, z" <|
            \_ ->
              let
                  coordinates = Coordinates 5 5 5 
              in
                Expect.equal coordinates {x = 5, y = 5, z = 5}

        , test ".hash - returns a string of | seperated coords" <|
            \_ ->
                let
                    hashed = Coords.hash (Coordinates 5 5 5)
                in
                    Expect.equal hashed "5|5|5"

        , test ".extract - turns a hashed string of coords into a set of coordinates" <|
            \_ ->
                let
                    extracted = Coords.extract "5|5|5"
                in
                Expect.equal extracted (Coordinates 5 5 5)
        ]
