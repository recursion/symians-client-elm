module Main exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)

import App.Model exposing (Model, Msg(..))
import Chat.Model as Chat
import UI.Model as UI

import App.Update exposing (update)
import App.Socket as Socket
import App.Init as Init

import Chat.View
import World.View
import UI.View


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    let
        ( initialModel, uiCmd ) =
            App.Model.init Socket.initPhxSocket
                <| Chat.initModel Chat.defaultChannel

        ( nextModel, systemCmd ) =
            Init.system initialModel

        ( finalModel, chatCmd ) =
            Init.chat ChatMsg Chat.defaultChannel nextModel
    in
        ( finalModel
        , Cmd.batch [ uiCmd, systemCmd, chatCmd ]
        )


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ World.View.render model
        , div [ class "ui" ]
            [ Html.map ChatMsg (Chat.View.render model.ui model.chat)
            , Html.map UIMsg (UI.View.hud model.ui)
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Socket.listen model
        , Sub.map UIMsg  (UI.subscriptions model.ui)
        ]
