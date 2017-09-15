module World.Coordinates exposing (..)


type alias Coordinates =
    { x : Int
    , y : Int
    , z : Int
    }

{-| takes a set of `Coordinates`
returns a string of coords joined by '|'
-}
hash : Coordinates -> String
hash coords =
    String.join "|"
        [ toString coords.x
        , toString coords.y
        , toString coords.z
        ]

{-| takes a string of '|' seperated coordinates and
splits it into a `Coordinates` record
-}
extract : String -> Coordinates
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
