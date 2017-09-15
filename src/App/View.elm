module App.View exposing (root)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import App.Model exposing (Model, Msg(..), State(..))
import UI.View exposing (loadingScreen)
import World.Models as World
import World.View
import UI.View


root : Model -> Html Msg
root model =
    case model.world of
        Loading ->
            Html.map UIMsg loadingScreen

        Loaded world ->
            render world model

render : World.Model -> Model -> Html Msg
render world model = 
    div [ class "app" ]
        [ Html.map UIMsg (World.View.render world model.ui)
        , div [ class "ui" ]
            [ Html.map UIMsg (UI.View.hud model.chat model.ui)
            ]
        ]
