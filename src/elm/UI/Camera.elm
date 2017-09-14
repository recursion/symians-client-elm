module UI.Camera exposing (..)

{-| camera provides an abstraction for tracking and manipulating
what the client is currently looking at/rendering
-}

import Svg.Attributes exposing (x, y)
import Svg exposing (svg, text)
import UI.Model exposing (Camera)
import World.Model exposing (Dimensions)


tileSize : Int
tileSize =
    64


{-| currently we are only sending 3 z levels, so limit here
-}
currentZLimit : Int
currentZLimit =
    2

render : (List (Svg.Attribute msg) -> List a -> Svg.Svg msg1)
       -> List (Svg.Attribute msg)
       -> Int -> Int -> Int
       -> Camera
       -> Svg.Svg msg1
render svgObject props x_ y_ z_ camera =
    let
        ( posX, posY ) =
            translate ( x_, y_ ) camera

        toNumber =
            \s -> Result.withDefault 0 (String.toInt s)

    in
        if inBounds x_ y_ z_ camera then
            svgObject
                (props
                    ++ [ x posX
                       , y posY
                       ]
                )
                []
        else
            text ""

inBounds : Int -> Int -> Int -> Camera -> Bool
inBounds x y z camera =
    let
        maxX =
            (camera.width // tileSize) + 1

        maxY =
            (camera.height // tileSize) + 1
    in
      z == camera.z
        && x >= camera.x
        && x < camera.x + maxX
        && y >= camera.y
        && y < camera.y + maxY

moveZLevelUp : Camera -> Camera
moveZLevelUp camera =
    if camera.z >= currentZLimit then
        camera
    else
        { camera | z = camera.z + 1 }


moveZLevelDown : Camera -> Camera
moveZLevelDown camera =
    let
        nextZ =
            camera.z - 1
    in
        if nextZ < 0 then
            camera
        else
            { camera | z = nextZ }


moveDown : Camera -> Camera
moveDown camera =
    let
        nextY =
            camera.y + 1

        tilesPos =
            camera.height // tileSize
    in
        if nextY > (camera.worldDimensions.height - tilesPos) + 1 then
            camera
        else
            { camera | y = nextY }


moveUp :  Camera -> Camera
moveUp camera =
    if camera.y - 1 < -1 then
        camera
    else
        { camera | y = camera.y - 1 }


moveLeft : Camera -> Camera
moveLeft camera =
    if camera.x - 1 < -1 then
        camera
    else
        { camera | x = camera.x - 1 }


moveRight : Camera -> Camera
moveRight camera =
    let
        nextX =
            camera.x + 1

        tilesPos =
            camera.width // tileSize
    in
        if nextX > (camera.worldDimensions.width - tilesPos) + 1 then
            camera
        else
            { camera | x = nextX }


translate : ( Int, Int ) -> Camera -> ( String, String )
translate ( x_, y_ ) camera =
    let
        tileMultiplier n =
            n * tileSize

        positionx =
            toString ((tileMultiplier x_) - (tileMultiplier camera.x))

        positiony =
            toString ((tileMultiplier y_) - (tileMultiplier camera.y))
    in
        ( positionx, positiony )
