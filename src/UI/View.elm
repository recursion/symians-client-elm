module UI.View exposing (hud, loadingScreen)

import Html exposing (Html, img, text, div, label, span, button, table, tr, td, h1)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import UI.Model as UI exposing (Msg, Model, Camera, Inspection)
import UI.Console as Console
import Chat.Model as Chat

-- hud rendering


hud : Chat.Model -> Model -> Html Msg
hud chatModel model =
    div [ class "hud" ]
        [ controls model
        , inspector model
        , Console.render chatModel model 
        ]



-- tile inspector


inspector : Model -> Html Msg
inspector model =
    if model.viewInspector then
        renderInspector model.inspector
    else
        text ""



-- hud controls


controls : Model -> Html Msg
controls model =
    div [ class "controls" ]
        [ hudButton "Console" UI.ToggleConsole <| isActive model.viewConsole
        , hudButton "Inspector" UI.ToggleInspector <| isActive model.viewInspector
        ]


isActive : Bool -> String
isActive setting =
    if setting then
        "hud-btn-is-active"
    else
        "hud-btn"


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



-- Loading screen


loadingScreen : Html Msg
loadingScreen =
    div [ class "fullscreen loadscreen" ]
        [ div [ class "centered" ]
            [ h1 [ class "" ] [ Html.text "Loading" ]
            , img
                [ src "img/loading.gif"
                , class "loading"
                ]
                []
            ]
        ]