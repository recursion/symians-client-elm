module UI.Camera exposing (..)

import UI.Model exposing (Camera)
import World.Location as Location


tileSize : Int
tileSize =
    63



-- Camera controls


moveDown : Camera -> Camera
moveDown camera =
    { camera | y = camera.y + 1 }


moveUp : Camera -> Camera
moveUp camera =
    if camera.y - 1 < 0 then
        camera
    else
        { camera | y = camera.y - 1 }


moveLeft : Camera -> Camera
moveLeft camera =
    if camera.x - 1 < 0 then
        camera
    else
        { camera | x = camera.x - 1 }


moveRight : Camera -> Camera
moveRight camera =
    { camera | x = camera.x + 1 }


translate : Camera -> ( Int, Int ) -> ( String, String )
translate camera ( x_, y_ ) =
    let
        tileMultiplier n =
            n * tileSize

        positionx =
            toString ((tileMultiplier x_) - (tileMultiplier camera.x))

        positiony =
            toString ((tileMultiplier y_) - (tileMultiplier camera.y))
    in
        ( positionx, positiony )
