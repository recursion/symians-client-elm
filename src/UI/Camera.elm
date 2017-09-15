module UI.Camera
    exposing
        ( tileSize
        , translate
        , inBounds
        , moveZLevelDown
        , moveZLevelUp
        , moveUp
        , moveDown
        , moveLeft
        , moveRight
        , resize
        , updateDimensions
        , getScreenLocations
        )

{-| camera provides functions for tracking and manipulating
what the client is currently looking at/rendering
-}

import UI.Model exposing (Camera)
import World.Model exposing (Dimensions)
import World.Coordinates exposing (Coordinates)
import Window


tileSize : Int
tileSize =
    64


{-| currently we are only sending 3 z levels, so limit here
TODO: get rid of this
-}
currentZLimit : Int
currentZLimit =
    2


{-| update the camera dimensions
-}
updateDimensions : Dimensions -> Camera -> Camera
updateDimensions dim camera =
    { camera | worldDimensions = dim }


{-| translate a set of coordinates to their position in the camera view
-}
translate : Coordinates -> Camera -> ( String, String )
translate coords camera =
    let
        tileMultiplier n =
            n * tileSize

        positionx =
            toString ((tileMultiplier coords.x) - (tileMultiplier camera.position.x))

        positiony =
            toString ((tileMultiplier coords.y) - (tileMultiplier camera.position.y))
    in
        ( positionx, positiony )

{-| get all coordinates currently in the camera bounds
-}
getScreenLocations : Camera -> List ( Int, Int )
getScreenLocations camera =
    let
        (width, height) = size camera
        xGen x =
            List.map (coords x) (List.range camera.position.y height)

        coords x y =
            (x, y)
    in
        List.concatMap xGen (List.range camera.position.x width)
{-| returns the size of a cameras view
in the shape of a width, height tuple
          (width, height)
-}
size : Camera -> (Int, Int)
size camera =
    ( (camera.position.x + maxX camera)
    , (camera.position.y + maxY camera)
    )


maxX : Camera -> Int
maxX camera =
    (camera.width // tileSize) + 1


maxY : Camera -> Int
maxY camera =
    (camera.height // tileSize) + 1


{-| check coordinates to see if they are within the cameras view
-}
inBounds : Coordinates -> Camera -> Bool
inBounds coords camera =
    onZLevel coords camera.position
        && xInView (maxX camera) coords camera.position
        && yInView (maxY camera) coords camera.position


onZLevel : Coordinates -> Coordinates -> Bool
onZLevel loc cam =
    cam.z == loc.z


xInView : Int -> Coordinates -> Coordinates -> Bool
xInView maxX loc cam =
    loc.x >= cam.x && loc.x < (cam.x + maxX)


yInView : Int -> Coordinates -> Coordinates -> Bool
yInView maxY loc cam =
    loc.y >= cam.y && loc.y < (cam.y + maxY)



-- Camera Controls


{-| move the camera up a z level
keeps the view in bounds of the world dimensions
-}
moveZLevelUp : Camera -> Camera
moveZLevelUp camera =
    if camera.position.z >= currentZLimit then
        camera
    else
        let
            pos =
                camera.position

            nextPos =
                { pos | z = camera.position.z + 1 }
        in
            { camera | position = nextPos }


{-| move the camera down a z level
keeps the view in bounds of the world dimensions
-}
moveZLevelDown : Camera -> Camera
moveZLevelDown camera =
    let
        nextZ =
            camera.position.z - 1

        pos =
            camera.position

        nextPos =
            { pos | z = nextZ }
    in
        if nextZ < 0 then
            camera
        else
            { camera | position = nextPos }


{-| move the camera down
keeps the view in bounds of the world dimensions
-}
moveDown : Camera -> Camera
moveDown camera =
    let
        nextY =
            camera.position.y + 1

        tilesPos =
            camera.height // tileSize

        pos =
            camera.position

        nextPos =
            { pos | y = nextY }
    in
        if nextY > (camera.worldDimensions.height - tilesPos) + 1 then
            camera
        else
            { camera | position = nextPos }


{-| move the camera up
keeps the view in bounds of the world dimensions
-}
moveUp : Camera -> Camera
moveUp camera =
    if camera.position.y - 1 < -1 then
        camera
    else
        let
            pos =
                camera.position

            nextPos =
                { pos | y = camera.position.y - 1 }
        in
            { camera | position = nextPos }


{-| move the camera to the left
keeps the view in bounds of the world dimensions
-}
moveLeft : Camera -> Camera
moveLeft camera =
    if camera.position.x - 1 < -1 then
        camera
    else
        let
            pos =
                camera.position

            nextPos =
                { pos | x = camera.position.x - 1 }
        in
            { camera | position = nextPos }


{-| move the camera to the right
keeps the view in bounds of the world dimensions
-}
moveRight : Camera -> Camera
moveRight camera =
    let
        nextX =
            camera.position.x + 1

        tilesPos =
            camera.width // tileSize

        pos =
            camera.position

        nextPos =
            { pos | x = nextX }
    in
        if nextX > (camera.worldDimensions.width - tilesPos) + 1 then
            camera
        else
            { camera | position = nextPos }


{-| handler for window resize
changes the cameras height/width to match the screen size
-}
resize : Window.Size -> Camera -> Camera
resize size model =
    { model | width = size.width, height = size.height }
