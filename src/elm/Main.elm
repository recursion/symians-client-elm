module Main exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import App.Socket exposing (initPhxSocket, initSystemChannel, systemChannel)
import App.Model exposing (Model, Msg, Msg(PhoenixMsg, ChatMsg, KeyMsg, ResizeWindow), initModel)
import App.Update exposing (update)
import App.Socket as Socket
import Chat.Model as Chat
import Phoenix.Socket
import World.View
import UI.View
import Keyboard
import Window
import Task


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
        ( initialModel, systemCmd ) =
            initSystemChannel (initModel initPhxSocket (Chat.initModel Chat.defaultChannel))

        ( nextModel, chatCmd ) = Socket.initChatChannel initialModel

        getWindowSize =
            Task.perform ResizeWindow Window.size
    in
        ( nextModel
        , Cmd.batch [ systemCmd, chatCmd, getWindowSize ]
        )

view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ World.View.render model.world.locations model.ui.camera
        , UI.View.render model
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Phoenix.Socket.listen model.socket PhoenixMsg
        , Keyboard.downs KeyMsg
        , Window.resizes ResizeWindow
        ]
