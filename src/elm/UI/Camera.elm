module UI.Camera exposing (..)

import UI.Model exposing (Camera)
import World.Model exposing (Dimensions)


tileSize : Int
tileSize =
    64



-- Camera controls


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
