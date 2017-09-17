module Camera.Model exposing (..)

import World.Models exposing (Coordinates, Dimensions)

type alias Model =
    { position : Coordinates
    , worldDimensions : Dimensions
    , width : Int
    , height : Int
    , tileSize : Int
    }


initCamera : Model
initCamera =
    { position = Coordinates 0 0 0
    , worldDimensions = Dimensions 0 0 0
    , width = 0
    , height = 0
    , tileSize = 64
    }
