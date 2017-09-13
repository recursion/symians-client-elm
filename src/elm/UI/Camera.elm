module UI.Camera exposing (..)

{-| camera provides an abstraction for tracking and manipulating
what the client is currently looking at/rendering
-}

import Svg.Attributes exposing (x, y, xlinkHref, viewBox, transform, width, height, fill, stroke)
import Svg exposing (svg, use, g, rect, text)
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


render svgObject props x_ y_ z_ camera =
    let
        ( posX, posY ) =
            translate ( x_, y_ ) camera

        toNumber =
            \s -> Result.withDefault 0 (String.toInt s)

        maxX =
            (camera.width // tileSize) + 1

        maxY =
            (camera.height // tileSize) + 1

        -- render only the locations that are currently with the camera's view
        inBounds =
            z_
                == camera.z
                && x_
                >= camera.x
                && x_
                < camera.x
                + maxX
                && y_
                >= camera.y
                && y_
                < camera.y
                + maxY
    in
        if inBounds then
            svgObject
                (props
                    ++ [ x posX
                       , y posY
                       ]
                )
                []
        else
            text ""


moveZLevelUp : Dimensions -> Camera -> Camera
moveZLevelUp dim camera =
    if camera.z >= currentZLimit then
        camera
    else
        { camera | z = camera.z + 1 }


moveZLevelDown : Dimensions -> Camera -> Camera
moveZLevelDown dim camera =
    let
        nextZ =
            camera.z - 1
    in
        if nextZ < 0 then
            camera
        else
            { camera | z = nextZ }


moveDown : Dimensions -> Camera -> Camera
moveDown dim camera =
    let
        nextY =
            camera.y + 1

        tilesPos =
            camera.height // tileSize
    in
        if nextY > (dim.height - tilesPos) + 1 then
            camera
        else
            { camera | y = nextY }


moveUp : Dimensions -> Camera -> Camera
moveUp dim camera =
    if camera.y - 1 < -1 then
        camera
    else
        { camera | y = camera.y - 1 }


moveLeft : Dimensions -> Camera -> Camera
moveLeft dim camera =
    if camera.x - 1 < -1 then
        camera
    else
        { camera | x = camera.x - 1 }


moveRight : Dimensions -> Camera -> Camera
moveRight dim camera =
    let
        nextX =
            camera.x + 1

        tilesPos =
            camera.width // tileSize
    in
        if nextX > (dim.width - tilesPos) + 1 then
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
