module Auth exposing (..)

import Html exposing (Html, div, h3, text)
import Html.Attributes exposing (class)


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
