module UI.Inspector.Model exposing (..)

import World.Models exposing (Coordinates, Location, initLocation)


type Msg
    = SetInspected Coordinates Location
    | ToggleVisible


type alias Model =
    { visible : Bool
    , inspection : Inspection
    }


type alias Inspection =
    { position : Coordinates
    , loc : Location
    }


init : Model 
init =
    { visible = True
    , inspection = initInspection
    }


initInspection : Inspection
initInspection =
    { position = Coordinates 0 0 0
    , loc = initLocation
    }
