module App.Auth exposing (..)

import Html exposing (Html, div, h3, text)
import Html.Attributes exposing (class)
import Json.Decode as JD exposing (field, maybe, int, string, float, nullable, Decoder)


type alias Model =
    { id : Maybe Int
    , token : Maybe String
    , status : String
    }

init : Model
init =
    Model Nothing Nothing ""


view : Model -> Html msg
view model =
    let
        id =
            (toString (Maybe.withDefault 0 model.id))

        token =
            (Maybe.withDefault "" model.token)
    in
        div
            [ class "auth" ]
            [ h3 [] [ text id ]
            , h3 [] [ text token ]
            , h3 [] [ text model.status ]
            ]

decodeTokenMessage : JD.Value -> Result String Model
decodeTokenMessage =
    JD.decodeValue tokenMessageDecoder

tokenMessageDecoder : JD.Decoder Model
tokenMessageDecoder =
    JD.map3 Model
        (maybe (field "id" JD.int))
        (maybe (field "token" JD.string))
        (field "status" JD.string)

