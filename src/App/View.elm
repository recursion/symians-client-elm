module App.View exposing (root)

import Element exposing (..)
import Html exposing (Html)
import Element.Attributes exposing (..)
import App.Styles exposing (Styles(..), stylesheet)
import App.Model exposing (Model, Msg(..), State(..))
import UI.Views.Hud as Hud
import World.Models as World
import World.View


root : Model -> Html Msg
root model =
    Element.viewport stylesheet <|
        case model.world of
            Loading ->
                Element.map UIMsg Hud.loadingScreen

            Loaded world ->
                render world model

render : World.Model -> Model -> Element Styles variation Msg
render world model =
    column None
        [ clip, height fill, width fill ]
        [ full None
            [ width fill, height fill ]
            (html (Html.map UIMsg (World.View.render world model.ui)))
        , el None
            [ ]
            (Element.map UIMsg (Hud.view model.chat model.ui))
        ]
