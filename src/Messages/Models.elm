module Messages.Models exposing (..)

type alias Chat =
    { user : String
    , body : String
    }

type alias Join =
    { status: String
    , id : Maybe Int
    , token : Maybe String
    }
