module App.View exposing (root)

import Element exposing (..)
import Html exposing (Html)
import Element.Attributes exposing (..)
import App.Styles exposing (Styles(..), stylesheet)
import App.Model exposing (Model, Msg(..), State(..))
import UI.Hud as Hud
import UI.Model as UI
import World.Models as World
import World.View


root : Model -> Html Msg
root model =
    Element.viewport stylesheet <|
        case model.world of
            Loading ->
                loadingScreen model.ui

            Loaded world ->
                symView world model


symView : World.Model -> Model -> Element Styles variation Msg
symView world model =
    column None
        [ clip, height fill, width fill ]
        [ full None
            [ width fill, height fill ]
            (html (Html.map UIMsg (World.View.render world model.ui)))
        , el None
            []
            (Element.map UIMsg (Hud.view model.chat model.ui))
        ]



-- Loading screen


loadingScreen : UI.Model -> Element Styles variation Msg
loadingScreen model =
    modal None
        [ verticalCenter, width fill, height fill, center ]
        (column None
            [ width fill, height fill, center ]
            [ h1 Load [ center ] (text "Loading")
            , image None [ center ] { src = model.images.loading, caption = "Loading" }
            ]
        )
