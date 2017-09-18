module UI.Hud exposing (view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import UI.Model as UI exposing (Msg(..), Model)
import Inspector.Model
import Inspector.View as Inspector
import UI.Model as UI exposing (..)
import Chat.Model as Chat
import App.Styles exposing (Styles(..), stylesheet)
import Console.Model as ConsoleModel
import Console.View as ConsoleView
import Selector.View as Selector


view : Chat.Model -> Model -> Element Styles variation Msg
view chatModel model =
    column None []
        [ modal None
            [ alignBottom, alignLeft, width (percent 40) ]
            (column None
                [padding 2, spacing 2]
                [ Element.map SelectorMsg (Selector.render model)
                , Element.map ConsoleMsg (ConsoleView.render chatModel model.console)
                , (controls model)
                ]
            )
        , Element.map InspectorMsg (Inspector.render model.inspector)
        ]



-- hud controls


controls : Model -> Element Styles variation Msg
controls model =
    row None
        [ spacing 4, width (percent 20), width fill]
        [ hudButton "Console" (UI.ConsoleMsg ConsoleModel.ToggleVisible)
        , hudButton "Inspector" (InspectorMsg Inspector.Model.ToggleVisible)
        ]

hudButton : String -> Msg -> Element Styles variation Msg
hudButton name action =
    button Hud
        [ onClick action, width fill ]
        (text name)
