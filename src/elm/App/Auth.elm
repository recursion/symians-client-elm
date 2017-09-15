module App.Auth exposing (..)

import Json.Decode as JD exposing (maybe, field)


type alias Model =
    { id : Maybe Int
    , token : Maybe String
    , status : String
    }


init : Model
init =
    Model Nothing Nothing ""


decodeTokenMessage : JD.Value -> Result String Model
decodeTokenMessage =
    JD.decodeValue tokenMessageDecoder


tokenMessageDecoder : JD.Decoder Model
tokenMessageDecoder =
    JD.map3 Model
        (maybe (field "id" JD.int))
        (maybe (field "token" JD.string))
        (field "status" JD.string)
