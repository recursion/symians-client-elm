module World.Coordinates exposing (..)

{-| represents x, y, z coordinates
functions for working with coordinates
-}

import World.Models exposing (Coordinates, CoordHash)


{-| takes a set of `Coordinates`
returns a string of coords joined by '|'
-}
hash : Coordinates -> CoordHash
hash coords =
    String.join "|"
        [ toString coords.x
        , toString coords.y
        , toString coords.z
        ]


{-| takes a string of '|' seperated coordinates and
splits it into a `Coordinates` record
-}
extract : CoordHash -> Coordinates
extract asString =
    let
        toNumber =
            \s -> Result.withDefault 0 (String.toInt s)

        extract_ n =
            String.split "|" asString
                |> List.drop n
                |> List.head
                |> Maybe.withDefault "0"
                |> toNumber
    in
        Coordinates (extract_ 0) (extract_ 1) (extract_ 2)
