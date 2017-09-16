module UI.Views.Hud exposing (view, loadingScreen)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)

import UI.Model as UI exposing (Msg, Model, Camera, Inspection)
import UI.Views.Console as Console
import UI.Views.Inspector as Inspector
import Chat.Model as Chat
import App.Styles exposing (Styles(..), stylesheet)


view : Chat.Model -> Model -> Element Styles variation Msg
view chatModel model =
    column None []
        [ Console.render chatModel model
        , Inspector.view model
        , controls model
        ]



-- hud controls


controls : Model -> Element Styles variation Msg
controls model =
    modal None [ padding 4, alignLeft, alignTop, width (percent 15), height fill]
        (column None [ spacing 4, width fill ]
            [ hudButton "Console" UI.ToggleConsole
            , hudButton "Inspector" UI.ToggleInspector
            ])


hudButton : String -> Msg -> Element Styles variation Msg
hudButton name action =
    button Hud
        [ onClick action, width fill]
        (text name)



-- Loading screen


loadingScreen : Model -> Element Styles variation Msg
loadingScreen model =
    modal None []
      (column None [width fill, height fill, center]
          [ h1 None [center] (text "Loading")
          , image None [center] {src = model.images.loading, caption = "Loading"}
          ])
