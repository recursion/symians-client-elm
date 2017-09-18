module Console.Model exposing (..)


type Msg
    = ToggleVisible
    | SubmitInput
    | SetInput String
    | ToggleInputFocus
    | ToggleScrollBar


type alias Model =
    { visible : Bool
    , input : String
    , hasFocus : Bool
    , scroll : Bool
    }


init : Model
init =
    { visible = True
    , input = ""
    , hasFocus = False
    , scroll = False
    }
