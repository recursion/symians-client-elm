module UI.Inspector exposing (view)

import UI.Model exposing (Model, Msg, Inspection)
import Element exposing (..)
import Element.Attributes exposing (..)
import App.Styles exposing (Styles(..), stylesheet)


view : Model -> Element Styles variation Msg
view model =
    if model.viewInspector then
        renderInspector model.inspector
    else
        empty


renderInspector : Inspection -> Element Styles variation Msg
renderInspector model =
    modal Hud
        [ alignRight, alignTop, width (percent 15), height fill ]
        (column None
            [ padding 5, spacing 3 ]
            [ renderIData "type: " (text model.loc.type_)
            , renderIData "x: " (text <| toString model.position.x)
            , renderIData "y: " (text <| toString model.position.y)
            , renderIData "z: " (text <| toString model.position.z)
            , el None [] (text "entities:")
            ]
        )


renderIData : String -> Element Styles variation Msg -> Element Styles variation Msg
renderIData key value =
    row None
        [ width fill ]
        [ el None [ width (percent 50) ] (text key)
        , el None [ width (percent 50) ] (value)
        ]


renderEntity : String -> Element Styles variation Msg
renderEntity entity =
    el None [] (text entity)
