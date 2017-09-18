module UI.Inspector.View exposing (render)

import Html exposing (Html, div, span, text)
import UI.Inspector.Model exposing (Model, Msg, Inspection)


render : Model -> Html Msg
render model =
    if model.visible then
        renderInspector model
    else
        text ""


renderInspector : Model -> Html Msg
renderInspector model =
    div []
        [ renderIData "type: " (text model.inspection.loc.type_)
        , renderIData "x: " (text <| toString model.inspection.position.x)
        , renderIData "y: " (text <| toString model.inspection.position.y)
        , renderIData "z: " (text <| toString model.inspection.position.z)
        ]


renderIData : String -> Html Msg -> Html Msg
renderIData key value =
    div []
        [ span [] [text key]
        , span [] [value]
        ]


renderEntity : String -> Html Msg
renderEntity entity =
    span [] [text entity]
