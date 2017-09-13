module UI.Camera exposing (..)

import UI.Model exposing (Camera)


tileSize : Int
tileSize =
    64



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


translate : ( Int, Int ) -> Camera ->  ( String, String )
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
