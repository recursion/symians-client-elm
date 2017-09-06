module Chat.Chat exposing (..)

--where

import App.JsonHelpers exposing (encodeChatMessage, decodeChatMessage)
import Chat.Model exposing (..)
import Phoenix.Socket
import Phoenix.Push
import Dict exposing (Dict)


init : ( Model, Cmd Msg )
init =
    ( initModel "system:chat", Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.Socket.listen model.phxSocket PhoenixMsg


processPhoenixMsg msg model =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.update msg model.phxSocket
    in
        ( { model | phxSocket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )


processChatMessage raw model =
    case decodeChatMessage raw of
        Ok chatMessage ->
            let
                currentChannel = Maybe.withDefault (Channel []) (Dict.get model.currentChannel model.channels)
                nextMessages = (chatMessage.user ++ ": " ++ chatMessage.body) :: currentChannel.messages
                nextChannels = Dict.insert model.currentChannel (Channel nextMessages) model.channels
            in

            ( { model | channels = nextChannels }
            , Cmd.none
            )

        Err error ->
            ( model, Cmd.none )

