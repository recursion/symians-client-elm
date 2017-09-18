module App.View exposing (root)

import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src, class)

import App.Model exposing (Model, Msg(..), State(..))
import UI.Hud as Hud
import UI.Model as UI
import World.Models as World
import World.View


root : Model -> Html Msg
root model =
    case model.world of
        Loading ->
            loadingScreen model.ui

        Loaded world ->
            symView world model


symView : World.Model -> Model -> Html Msg
symView world model =
    div [ class "app" ]
        [ (Html.map UIMsg (World.View.render world model.ui))
        , (Html.map UIMsg (Hud.view model.chat model.ui))
        ]



-- Loading screen


loadingScreen : UI.Model -> Html Msg
loadingScreen model =
    div [ class "app" ]
      [ h1 [ ] [text "Loading"]
      , img [ src model.images.loading ] []
      ]
