module Selector.Model exposing (..)

import World.Models exposing (Coordinates)


type alias Model =
    { enabled : Bool
    , mode : Mode
    , selected : List Coordinates
    }

type Msg
    = ChangeMode Mode
    | Select Coordinates
    | MouseOver Coordinates

type Mode
    = Designate
    | Undesignate
    | SelectRect


init =
    { enabled = False, mode = Designate, selected = [] }
