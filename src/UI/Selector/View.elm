module UI.Selector.View exposing (render)

import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)
import UI.Selector.Model exposing (..)

render model =
    div []
        [ hudButton "Designate" (ChangeMode Designate)
        , hudButton "Undesignate" (ChangeMode Undesignate)
        ]

hudButton : String -> Msg -> Html Msg
hudButton name action =
    button
        [ onClick action]
        [text name]
