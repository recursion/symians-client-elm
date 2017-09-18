module UI.Inspector.View exposing (render)

import Element exposing (..)
import Element.Attributes exposing (..)

import UI.Inspector.Model exposing (Model, Msg, Inspection)
import App.Styles exposing (Styles(..), stylesheet)


render : Model -> Element Styles variation Msg
render model =
    if model.visible then
        renderInspector model
    else
        empty


renderInspector : Model -> Element Styles variation Msg
renderInspector model =
    modal Hud
        [ alignRight, alignTop, minWidth (px 125), moveDown 3, moveLeft 1 ]
        (column None
            [ padding 5, spacing 3 ]
            [ renderIData "type: " (text model.inspection.loc.type_)
            , renderIData "x: " (text <| toString model.inspection.position.x)
            , renderIData "y: " (text <| toString model.inspection.position.y)
            , renderIData "z: " (text <| toString model.inspection.position.z)
            ]
        )


renderIData : String -> Element Styles variation Msg -> Element Styles variation Msg
renderIData key value =
    row None
        [ width fill, center, padding 2, spacing 2 ]
        [ el Label [ width (percent 45) ] (text key)
        , el Value [ width (percent 55), paddingLeft 10 ] (value)
        ]


renderEntity : String -> Element Styles variation Msg
renderEntity entity =
    el None [] (text entity)
