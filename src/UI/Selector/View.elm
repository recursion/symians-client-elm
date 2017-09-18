module UI.Selector.View exposing (render)

import Html exposing (Html, div, button, text)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import UI.Selector.Model exposing (..)

render : Model -> Html Msg
render model =
    div [ id "selector"]
        [ hudButton "Designate" (ChangeMode Designate)
        , hudButton "Undesignate" (ChangeMode Undesignate)
        ]

hudButton : String -> Msg -> Html Msg
hudButton name action =
    button
        [ onClick action, class "hud selector-button" ]
        [text name]
