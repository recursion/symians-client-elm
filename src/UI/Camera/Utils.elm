module UI.Camera.Utils exposing (updateDimensions, translate, resize, getScreenLocations)

import World.Models exposing (Dimensions, Coordinates)
import UI.Camera.Model exposing (Model)
import Window


{-| update the Model dimensions
-}
updateDimensions : Dimensions -> Model -> Model
updateDimensions dim model =
    { model | worldDimensions = dim }


{-| handler for window resize
changes the cameras height/width to match the screen size
-}
resize : Window.Size -> Model -> Model
resize size model =
    { model | width = size.width, height = size.height }


{-| translate a set of world coordinates to Model coordinates
-}
translate : Coordinates -> Model -> ( Int, Int )
translate coords model =
    let
        -- if we are at our movement limit
        -- shift tiles to fill the screen
        tileMultiplier n =
            n * model.tileSize

        translate_ a b =
            ((tileMultiplier a) - (tileMultiplier b))
    in
        ( translate_ coords.x model.position.x
        , translate_ coords.y model.position.y
        )


{-| get all coordinates currently in the Model view
-}
getScreenLocations : Model -> List ( Int, Int )
getScreenLocations model =
    let
        ( xEdge, yEdge) =
            getEdges model

        generateCoords x =
            List.map (coords x) (List.range model.position.y yEdge)

        coords x y =
            ( x, y )
    in
        List.concatMap generateCoords (List.range model.position.x xEdge)


{-| return current camera edge coordinates
i.e. if a camera is currently at (x, y) position
then this returns (x+screen-width, y+screen-height)
-}
getEdges : Model -> ( Int, Int )
getEdges model =
    ( xEdge model
    , yEdge model
    )

{-| return the x camera edge
-}
xEdge : Model -> Int
xEdge model =
    model.position.x + (maxX model)


{-| return the y camera edge
-}
yEdge : Model -> Int
yEdge model =
    model.position.y + (maxY model)


{-| return max view width
-}
maxX : Model -> Int
maxX model =
    (model.width // model.tileSize) + 1


{-| return max view height
-}
maxY : Model -> Int
maxY model =
    (model.height // model.tileSize) + 1


{-| are coordinates inside the Model view
-}
inBounds : Coordinates -> Model -> Bool
inBounds coords model =
    isOnZLevel coords model.position
        && isInXBound (maxX model) coords model.position
        && isInYBound (maxY model) coords model.position


{-| are coordinates on the Model z level
-}
isOnZLevel : Coordinates -> Coordinates -> Bool
isOnZLevel loc cam =
    cam.z == loc.z


{-| are coordinates in the Model x view
-}
isInXBound : Int -> Coordinates -> Coordinates -> Bool
isInXBound maxX loc cam =
    loc.x >= cam.x && loc.x < (cam.x + maxX)


{-| are coordinates in the Model y view
-}
isInYBound : Int -> Coordinates -> Coordinates -> Bool
isInYBound maxY loc cam =
    loc.y >= cam.y && loc.y < (cam.y + maxY)
