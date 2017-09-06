module Chat.Channel exposing (..)

import App.JsonHelpers exposing (encodeChatMessage, decodeChatMessage)
import Chat.Model exposing (..)
import Phoenix.Channel
import Phoenix.Socket
import Phoenix.Push
import Dict exposing (Dict)

getCurrent model =
    Maybe.withDefault (Channel []) (Dict.get model.currentChannel model.channels)

   --  nextMessages = (chatMessage.user ++ ": " ++ chatMessage.body) :: currentChannel.messages
   --  nextChannels = Dict.insert model.currentChannel (Channel nextMessages) model.channels
updateMessages messages channelName model =
    Dict.insert channelName (Channel messages) model.channels


join model =
    let
        channel =
            Phoenix.Channel.init model.currentChannel
                -- this is where the user token should get attached
                -- |> Phoenix.Channel.withPayload userParams
                |> Phoenix.Channel.onJoin (always (ShowJoinedMessage model.currentChannel))
                |> Phoenix.Channel.onClose (always (ShowLeftMessage model.currentChannel))

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join channel model.phxSocket
    in
        ( { model | phxSocket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )


send auth model =
    let
        token =
            Maybe.withDefault "" auth.token

        payload =
            encodeChatMessage token model.newMessage

        push_ =
            Phoenix.Push.init newChatMsgEvent model.currentChannel
                |> Phoenix.Push.withPayload payload

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.push push_ model.phxSocket
    in
        ( { model
            | newMessage = ""
            , phxSocket = phxSocket
          }
        , Cmd.map PhoenixMsg phxCmd
        )


leave model =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.leave model.currentChannel model.phxSocket
    in
        ( { model | phxSocket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )

addMessage msg channelName model =
    let
      currentChannel = Maybe.withDefault (Channel []) (Dict.get channelName model.channels)
      nextMessages = msg :: currentChannel.messages
      nextChannels = updateMessages nextMessages channelName model
    in
        nextChannels

showJoinedMessage channelName model =
    let
        nextChannels = addMessage ("Joined channel " ++ channelName) channelName model
    in
      ( { model | channels = nextChannels  }
      , Cmd.none
      )

showLeftMessage channelName model =
    let
        nextChannels = addMessage ("Left channel " ++ channelName) channelName model
    in
      ( { model | channels = nextChannels  }
      , Cmd.none
      )
