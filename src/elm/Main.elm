module Main exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import App.Socket exposing (initPhxSocket, chatEvent, initSystemChannel, chatChannel, systemChannel)
import App.Model exposing (Model, Msg, Msg(PhoenixMsg, ChatMsg, KeyMsg, ResizeWindow), initModel)
import App.Update exposing (update)
import UI.View exposing (renderHud, renderWorld)
import Phoenix.Socket
import Chat.Channel
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
        ( ( chatModel, chatCmd ), nextSocket ) =
            Chat.Channel.initWithSocket chatEvent chatChannel ChatMsg initPhxSocket

        ( nextModel, nextCmd ) =
            initSystemChannel (initModel nextSocket chatModel)

        getWindowSize = Task.perform ResizeWindow Window.size
    in
        ( nextModel, Cmd.batch [ Cmd.map PhoenixMsg chatCmd, nextCmd, getWindowSize ] )


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ renderWorld model.world.locations model.ui.camera
        , renderHud model
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Phoenix.Socket.listen model.socket PhoenixMsg
        , Keyboard.downs KeyMsg
        , Window.resizes ResizeWindow
        ]
