module UI.View exposing (hud)

import Html exposing (Html, text, div, label, span, button, table, tr, td)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import UI.Model as UI exposing (Msg, Model, Camera, Inspection)


-- hud rendering


hud : Model -> Html Msg
hud model =
    div [ class "hud" ]
        [ controls model
        , inspector model
        ]



-- tile inspector


inspector : Model -> Html Msg
inspector model =
    if model.viewInfo then
        renderInspector model.inspector
    else
        text ""



-- hud controls


controls : Model -> Html Msg
controls model =
    div [ class "controls" ]
        [ hudButton "Chat" UI.ToggleChatView <| isActive model.viewChat
        , hudButton "Info" UI.ToggleInfo <| isActive model.viewInfo
        ]


isActive : Bool -> String
isActive setting =
    if setting then
        "hud-btn-is-active"
    else
        ""


hudButton : String -> msg -> String -> Html msg
hudButton name action class_ =
    button
        [ class ("button is-small hud toggle " ++ class_)
        , onClick action
        ]
        [ text name ]



-- Inspector


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
