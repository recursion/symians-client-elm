module UI.Hud exposing (view)

import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)
import UI.Model as UI exposing (Msg(..), Model)
import UI.Inspector.Model
import UI.Inspector.View as Inspector
import UI.Model as UI exposing (..)
import UI.Console.Model as ConsoleModel
import UI.Console.View as ConsoleView
import UI.Selector.View as Selector
import Chat.Model as Chat


view : Chat.Model -> Model -> Html Msg
view chatModel model =
    div []
        [ Html.map SelectorMsg (Selector.render model)
        , Html.map ConsoleMsg (ConsoleView.render chatModel model.console)
        , (controls model)
        , Html.map InspectorMsg (Inspector.render model.inspector)
        ]



-- hud controls


controls : Model -> Html Msg
controls model =
    div []
        [ hudButton "Console" (UI.ConsoleMsg ConsoleModel.ToggleVisible)
        , hudButton "Inspector" (InspectorMsg UI.Inspector.Model.ToggleVisible)
        ]


hudButton : String -> Msg -> Html Msg
hudButton name action =
    button [ onClick action ]
        [ text name ]
