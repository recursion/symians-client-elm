module Main exposing(..)
import Html exposing (Html)
import App.Model exposing (..)
import App.View exposing (view)
import App.Update exposing (update)
import Phoenix.Socket


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
        , subscriptions = subscriptions
        }

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [Phoenix.Socket.listen model.phxSocket PhoenixMsg]


initSocket : Phoenix.Socket.Socket Msg
initSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug


init : ( Model, Cmd Msg )
init =
    ( Model "" [] initSocket (User Nothing Nothing ""), Cmd.none )

