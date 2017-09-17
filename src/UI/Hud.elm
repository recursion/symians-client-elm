module UI.Hud exposing (view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import UI.Model as UI exposing (Msg, Model, Inspection)
import UI.Inspector as Inspector
import UI.Model as UI exposing (..)
import Chat.Model as Chat
import App.Styles exposing (Styles(..), stylesheet)
import Console.Model as Console
import Console.View as Console


view : Chat.Model -> Model -> Element Styles variation Msg
view chatModel model =
    column None
        []
        [ Element.map ConsoleMsg (Console.render chatModel model.console)
        , Inspector.view model
        , controls model
        ]



-- hud controls


controls : Model -> Element Styles variation Msg
controls model =
    modal None
        [ padding 4, alignLeft, alignTop, width (percent 15), height fill ]
        (column None
            [ spacing 4, width fill ]
            [ hudButton "Console" (UI.ConsoleMsg Console.ToggleVisible)
            , hudButton "Inspector" UI.ToggleInspector
            ]
        )


hudButton : String -> Msg -> Element Styles variation Msg
hudButton name action =
    button Hud
        [ onClick action, width fill ]
        (text name)
