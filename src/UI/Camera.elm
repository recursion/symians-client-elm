module UI.Camera
    exposing
        ( tileSize
        , translate
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
import World.Models exposing (Dimensions, Coordinates)
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


{-| translate a set of world coordinates to camera coordinates
-}
translate : Coordinates -> Camera -> ( Int, Int)
translate coords camera =
    let
        tileMultiplier n =
            n * tileSize

        translate_ a b =
            ((tileMultiplier a) - (tileMultiplier b))
    in
        ( translate_ coords.x camera.position.x
        , translate_ coords.y camera.position.y
        )


{-| get all coordinates currently in the camera view
-}
getScreenLocations : Camera -> List ( Int, Int )
getScreenLocations camera =
    let
        ( width, height ) =
            size camera

        xGen x =
            List.map (coords x) (List.range camera.position.y height)

        coords x y =
            ( x, y )
    in
        List.concatMap xGen (List.range camera.position.x width)


{-| return the camera view size 
-}
size : Camera -> ( Int, Int )
size camera =
    ( width camera
    , height camera
    )
width : Camera -> Int
width camera =
    camera.position.x + (maxX camera)

height : Camera -> Int
height camera =
    camera.position.y + (maxY camera)

{-| return camera view width
-}
maxX : Camera -> Int
maxX camera =
    (camera.width // tileSize) + 1


{-| return camera view height
-}
maxY : Camera -> Int
maxY camera =
    (camera.height // tileSize) + 1


{-| are coordinates inside the camera view
-}
inBounds : Coordinates -> Camera -> Bool
inBounds coords camera =
    isOnZLevel coords camera.position
        && isInXBound (maxX camera) coords camera.position
        && isInYBound (maxY camera) coords camera.position


{-| are coordinates on the camera z level
-}
isOnZLevel : Coordinates -> Coordinates -> Bool
isOnZLevel loc cam =
    cam.z == loc.z


{-| are coordinates in the camera x view
-}
isInXBound : Int -> Coordinates -> Coordinates -> Bool
isInXBound maxX loc cam =
    loc.x >= cam.x && loc.x < (cam.x + maxX)


{-| are coordinates in the camera y view
-}
isInYBound : Int -> Coordinates -> Coordinates -> Bool
isInYBound maxY loc cam =
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
