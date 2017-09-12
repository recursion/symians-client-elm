module UI.Camera exposing (..)

import App.Model exposing (Model, Msg, Msg(DisplayTile))
import World.Model exposing (Location)
import UI.Model exposing (Camera)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onMouseOver)
import Html exposing (Html)
import Dict exposing (Dict)
import Svg exposing (..)


-- constants


smallTile : Int
smallTile =
    32


baseSize : Int
baseSize =
    63


overlayTileSize : Int
overlayTileSize =
    62



-- Camera controls


moveDown camera =
    { camera | y = camera.y + 1 }


moveUp camera =
    { camera | y = camera.y - 1 }


moveLeft camera =
    { camera | x = camera.x - 1 }


moveRight camera =
    { camera | x = camera.x + 1 }



-- View functions


render : Dict String Location -> Camera -> Html Msg
render locations camera =
    let
        locations_ =
            (Dict.toList locations)
                |> (List.map (\loc -> renderLocation camera loc))
    in
        svg
            [ class "world level"
            ]
            locations_


renderLocation : Camera -> ( String, Location ) -> Html Msg
renderLocation camera ( coords, loc ) =
    let
        ( x_, y_, z_ ) =
            extractCoords coords

        ogX =
            toString x_

        ogY =
            toString y_

        ( posX, posY ) =
            adjustCoordsForCamera camera ( x_, y_ )
    in
        g []
            [ use
                [ xlinkHref ("#" ++ loc.type_)
                , x posX
                , y posY
                ]
                []
            , rect
                [ fill "rgba(255, 255, 255, 0.01)"
                , x posX
                , y posY
                , width <| toString overlayTileSize
                , height <| toString overlayTileSize
                , onMouseOver (DisplayTile ogX ogY loc)
                ]
                []
            ]



extractCoords : String -> ( Int, Int, Int )
extractCoords asString =
    let
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


toNumber =
    \s -> Result.withDefault 0 (String.toInt s)


adjustCoordsForCamera : Camera -> ( Int, Int ) -> ( String, String )
adjustCoordsForCamera camera ( x_, y_ ) =
    let
        positionx =
            toString ((x_ * baseSize) - (camera.x * baseSize))

        positiony =
            toString ((y_ * baseSize) - (camera.y * baseSize))
    in
        ( positionx, positiony )
