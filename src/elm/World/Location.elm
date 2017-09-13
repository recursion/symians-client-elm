module World.Location exposing (..)

import App.Model exposing (Msg, Msg(SetInspected))
import Svg.Attributes exposing (x, y, xlinkHref)
import Svg.Events exposing (onMouseOver)
import Svg exposing (svg, use)


render camera ( ogX, ogY, posX, posY ) loc =
    use
        [ xlinkHref ("#" ++ loc.type_)
        , x posX
        , y posY
        , onMouseOver (SetInspected ogX ogY loc)
        ] []


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

