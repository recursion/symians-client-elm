module UI.Hud exposing (view)

import Html exposing (Html, div, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import UI.Model as UI exposing (Msg(..), Model)
import UI.Inspector.Model
import UI.Inspector.View as Inspector
import UI.Model as UI exposing (..)
import UI.Console.Model as ConsoleModel
import UI.Console.View as ConsoleView
import UI.Selector.View as Selector
import UI.Selector.Model as SelectorModel
import Chat.Model as Chat


view : Chat.Model -> Model -> Html Msg
view chatModel model =
    div [ class "hud-container" ]
        [ Html.map ConsoleMsg (ConsoleView.render chatModel model.console)
        , (controls model)
        , Html.map InspectorMsg (Inspector.render model.inspector)
        ]



-- hud controls


controls : Model -> Html Msg
controls model =
    div [ class "hud-controls" ]
        [ hudButton "Console" (ConsoleMsg ConsoleModel.ToggleVisible) model.console
        , hudButton "Inspector" (InspectorMsg UI.Inspector.Model.ToggleVisible) model.inspector
        , selectorButton
            "Designate"
            (SelectorMsg <| SelectorModel.ChangeMode SelectorModel.Designate)
            model.selector
        , selectorButton
            "Undesignate"
            (SelectorMsg <| SelectorModel.ChangeMode SelectorModel.Undesignate)
            model.selector
        ]


selectorButton name action component =
    let
        selected =
            case component.mode of
                SelectorModel.Designate ->
                    if name == "Designate" then
                        "hud-button__selected"
                    else
                        ""

                SelectorModel.Undesignate ->
                    if name == "Undesignate" then
                        "hud-button__selected"
                    else
                        ""
    in
        button [ onClick action, class <| "hud hud-button " ++ selected ] [text name]


hudButton name action component =
    let
        selected =
            if component.visible then
                "hud-button__selected"
            else
                ""
    in
        button [ onClick action, class <| "hud hud-button " ++ selected ]
            [ text name ]
