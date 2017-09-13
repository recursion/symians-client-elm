module World.Location exposing (..)


hashCoords x y z =
    String.join "|" [x, y, z]

extractCoords : String -> ( Int, Int, Int )
extractCoords asString =
    let
        toNumber =
            \s -> Result.withDefault 0 (String.toInt s)

        coords_ =
            String.split "|" asString

        x =
            Maybe.withDefault "0" (List.head coords_)
                |> toNumber

        y =
            Maybe.withDefault "0" (List.head (List.drop 1 coords_))
                |> toNumber

        z =
            Maybe.withDefault "0" (List.head (List.drop 2 coords_))
                |> toNumber
    in
        ( x, y, z )

