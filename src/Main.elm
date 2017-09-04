module Main exposing(..)
import Html exposing (Html)
import App.Model exposing (..)
import App.View exposing (view)
import App.Update exposing (update)
import Sockets.Socket
import Auth


socketServer : String
socketServer =
    "ws://localhost:4000/socket/websocket"

-- Test

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = Sockets.Socket.subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( Model "" [] Sockets.Socket.init (Auth.Model Nothing Nothing ""), Cmd.none )

