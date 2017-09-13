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


type alias Coordinates =
    { x : Int
    , y : Int
    , z : Int
    }


type alias Location =
    { entities : List String
    , type_ : String
    , selected : Bool
    }


type alias Locations =
    Dict String Location


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


initWorldData : Model
initWorldData =
    { locations = Dict.empty
    , dimensions = (Dimensions 0 0 0)
    }
