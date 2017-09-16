module UI.Views.Inspector exposing (view)

import Html exposing (Html, img, text, div, label, span, button, table, tr, td, h1)
import Html.Attributes exposing (src, class)
import UI.Model as UI exposing (Msg, Model, Camera, Inspection)



view : Model -> Html Msg
view model =
    if model.viewInspector then
        renderInspector model.inspector
    else
        text ""


renderInspector : Inspection -> Html Msg
renderInspector model =
    table [ class "hud hud-tiledata" ]
        [ renderIData "type: " [ text model.loc.type_ ]
        , renderIData "x: " [ text <| toString model.position.x ]
        , renderIData "y: " [ text <| toString model.position.y ]
        , renderIData "z: " [ text <| toString model.position.z ]
        , renderIData "entities:" (List.map renderEntity model.loc.entities)
        ]


renderIData : String -> List (Html Msg) -> Html Msg
renderIData key value =
    tr [ class "tiledata" ]
        [ td [ class "tiledata-label" ] [ text key ]
        , td [ class "tiledata-value" ] value
        ]


renderEntity : String -> Html Msg
renderEntity entity =
    div [ class "entity-data" ] [ text entity ]
