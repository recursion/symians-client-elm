module World.Model exposing (..)

import Dict exposing (Dict)


type alias Model =
    { locations : Locations
    , dimensions : Dimensions
    }


type alias Dimensions =
    { length : Int
    , width : Int
    , height : Int
    }


type alias Location =
    { entities : List String
    , type_ : String
    , selected : Bool
    }


type alias Locations =
    Dict String Location

type alias CoordHash =
    String


type alias Coordinates =
    { x : Int
    , y : Int
    , z : Int
    }

init : Model
init =
    { locations = Dict.empty
    , dimensions = (Dimensions 0 0 0)
    }


initLocation : Location
initLocation =
    { entities = []
    , type_ = ""
    , selected = False
    }
