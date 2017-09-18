module UI.Selector.View exposing (render)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import App.Styles exposing (Styles(..), stylesheet)

import UI.Selector.Model exposing (..)

render model =
    row None
        []
        [ hudButton "Designate" (ChangeMode Designate)
        , hudButton "Undesignate" (ChangeMode Undesignate)
        ]

hudButton : String -> Msg -> Element Styles variation Msg
hudButton name action =
    button Hud
        [ onClick action, width fill ]
        (text name)
