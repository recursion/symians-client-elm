module UI.Selector.Model exposing (..)

import World.Models exposing (Coordinates)


type alias Model =
    { enabled : Bool
    , mode : Mode
    , selected : List Coordinates
    , buffer : List Coordinates
    , start : Maybe Coordinates
    }

type Msg
    = ChangeMode Mode
    | StartSelection Coordinates
    | MouseOver Coordinates
    | Enable
    | Disable

type Mode
    = Designate
    | Undesignate


init =
    { enabled = False
    , mode = Designate
    , selected = []
    , buffer = []
    , start = Nothing
    }
