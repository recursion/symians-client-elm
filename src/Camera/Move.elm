module Camera.Move exposing (..)

import Camera.Model exposing (..)

currentZLimit = 2
borderBounds = 5


{-| move the camera up a z level
keeps the view in bounds of the world dimensions
-}
zLevelUp : Model -> Model
zLevelUp camera =
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

{-| move the model down a z level
keeps the view in bounds of the world dimensions
-}
zLevelDown : Model -> Model
zLevelDown model =
    let
        nextZ =
            model.position.z - 1

        pos =
            model.position

        nextPos =
            { pos | z = nextZ }
    in
        if nextZ < -borderBounds then
            model
        else
            { model | position = nextPos }


{-| move the model down
keeps the view in bounds of the world dimensions
-}
down : Model -> Model
down model =
    let
        nextY =
            model.position.y + 1

        screenHeightInTiles =
            model.height // model.tileSize

        pos =
            model.position

        nextPos =
            { pos | y = nextY }
    in
        if (nextY + screenHeightInTiles) > (model.worldDimensions.height + borderBounds)  then
            model
        else
            { model | position = nextPos }


{-| move the model up
keeps the view in bounds of the world dimensions
-}
up : Model -> Model
up model =
    if model.position.y - 1 < -borderBounds then
        model
    else
        let
            pos =
                model.position

            nextPos =
                { pos | y = model.position.y - 1 }
        in
            { model | position = nextPos }


{-| move the model to the left
keeps the view in bounds of the world dimensions
-}
left : Model -> Model
left model =
    if model.position.x - 1 < -borderBounds then
        model
    else
        let
            pos =
                model.position

            nextPos =
                { pos | x = model.position.x - 1 }
        in
            { model | position = nextPos }


{-| move the model to the right
keeps the view in bounds of the world dimensions
-}
right : Model -> Model
right model =
    let
        nextX =
            model.position.x + 1

        screenWidthInTiles =
            model.width // model.tileSize

        pos =
            model.position

        nextPos =
            { pos | x = nextX }
    in
        if (nextX + screenWidthInTiles) > (model.worldDimensions.width + borderBounds) then
            model
        else
            { model | position = nextPos }
