module World.Model exposing (..)

import Dict exposing (Dict)


type alias Model =
    { dimensions: Dimensions
    , worldData: WorldData
    }


type alias WorldData =
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
    }


type alias Locations =
    Dict String Location


initLocation : Location
initLocation =
    { entities = [], type_ = "" }


initWorldData : WorldData
initWorldData =
    { locations = Dict.empty
    , dimensions = (Dimensions 0 0 0)
    }
