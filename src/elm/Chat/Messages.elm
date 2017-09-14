module Chat.Messages exposing (..)

import Chat.Model exposing (..)
import Dict exposing (Dict)
import Json.Encode as JE
import Chat.Decoders exposing (decodeChatMessage)
import Chat.Channels as Channels



{-| Update the messages in a channel
-}
update : List String -> String -> Model -> Channels
update messages channelName model =
    Dict.insert channelName (Channel messages) model.channels


{-| Add a message to a channel
-}
add : String -> String -> Model -> Channels
add msg channelName model =
    let
        currentChannel =
            Channels.getCurrent model

        nextMessages =
            msg :: currentChannel.messages
    in
        update nextMessages channelName model


{-| Adds a joined message to the channel messages
-}
showJoined : String -> Model -> Model
showJoined channelName model =
    let
        nextChannels =
            add ("Joined channel " ++ channelName) channelName model
    in
        { model | channels = nextChannels }


{-| Adds a left message to a channel
-}
showLeft : String -> Model -> Model
showLeft channelName model =
    let
        nextChannels =
            add ("Left channel " ++ channelName) channelName model
    in
        { model | channels = nextChannels }


{-|  decode an incoming new chat message
and add it to the current channels messages
-}
process : JE.Value -> Model -> Model
process raw model =
    case decodeChatMessage raw of
        Ok chatMessage ->
            let
                msg =
                    (chatMessage.user ++ ": " ++ chatMessage.body)

                nextChannels =
                    add msg model.currentChannel model
            in
                { model | channels = nextChannels }

        Err error ->
            let
                _ =
                    Debug.log "Error processing chat message." error
            in
                model
