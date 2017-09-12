module Main exposing (..)

import Html exposing (Html, div, text)
import App.Socket exposing (initPhxSocket, chatEvent, connectTo, chatChannel, systemChannel)
import App.Model exposing (Model, Msg, Msg(PhoenixMsg, ChatMsg), initModel)
import App.Update exposing (update)
import World.View as World
import UI.View exposing (controlsView, hudView)
import Phoenix.Socket
import Chat.Channel
import Chat.View

-- import Auth


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
            connectTo systemChannel (initModel nextSocket chatModel)
    in
        ( nextModel, Cmd.batch [ Cmd.map PhoenixMsg chatCmd, nextCmd ] )


view : Model -> Html Msg
view model =
        let
            chat = 
                case model.ui.chatView of
                    True -> Html.map ChatMsg (Chat.View.view model.chat)
                    False -> text ""
            info =
                case model.ui.viewInfo of
                    True -> hudView model
                    False -> text ""
        in
            div []
                [ World.view model
                , chat
                , controlsView model
                , info
                ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Phoenix.Socket.listen model.socket PhoenixMsg
        ]
