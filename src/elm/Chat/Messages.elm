module Chat.Messages exposing (..)
import Chat.Model exposing (..)
import Dict exposing (Dict)
import Json.Encode as JE
import App.JsonHelpers exposing (decodeChatMessage)

{- Update the messages in a channel -}
update : List String -> String -> Model -> Channels
update messages channelName model =
    Dict.insert channelName (Channel messages) model.channels


{- Add a message to a channel
-}
add : String -> String -> Model -> Channels
add msg channelName model =
    let
        currentChannel =
            Maybe.withDefault (Channel []) (Dict.get channelName model.channels)

        nextMessages =
            msg :: currentChannel.messages

        nextChannels =
            update nextMessages channelName model
    in
        nextChannels

{- Adds a joined message to the channel messages
-}
showJoined : String -> Model -> Model
showJoined channelName model =
    let
        nextChannels =
            add ("Joined channel " ++ channelName) channelName model
    in
        { model | channels = nextChannels }

{- Adds a left message to a channel
-}
showLeft : String -> Model -> Model
showLeft channelName model =
    let
        nextChannels =
            add ("Left channel " ++ channelName) channelName model
    in
        { model | channels = nextChannels }

{- We recieved a new chat message - decode it and add it to the current channels messages
-}
process : JE.Value -> Model -> Model
process raw model =
    case decodeChatMessage raw of
        Ok chatMessage ->
            let
                currentChannel =
                    Maybe.withDefault (Channel []) (Dict.get model.currentChannel model.channels)

                nextMessages =
                    (chatMessage.user ++ ": " ++ chatMessage.body) :: currentChannel.messages

                nextChannels =
                    Dict.insert model.currentChannel (Channel nextMessages) model.channels
            in
                { model | channels = nextChannels }

        Err error ->
            model
