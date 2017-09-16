module UI.Views.Hud exposing (view, loadingScreen)

import Html exposing (Html, div, button, text, img, h1)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import UI.Model as UI exposing (Msg, Model, Camera, Inspection)
import UI.Views.Console as Console
import UI.Views.Inspector as Inspector
import Chat.Model as Chat



view : Chat.Model -> Model -> Html Msg
view chatModel model =
    div [ class "hud" ]
        [ controls model
        , Inspector.view model
        , Console.render chatModel model
        ]



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
