module Chat.Messages exposing (..)

import Chat.Model exposing (..)
import Json.Encode as JE
import Chat.Decoders exposing (decodeChatMessage)



{-| Update the messages in a channel
-}
update : List String -> Model -> Model
update nextMessages model =
    { model | messages = nextMessages }


{-| Add a message to a channel
-}
add : String -> Model -> Model
add msg model =
    let
        nextMessages =
            msg :: model.messages
    in
        update nextMessages model


{-| Adds a joined message to the channel messages
-}
showJoined : Model -> Model
showJoined model =
      add ("Joined channel " ++ model.name) model


{-| Adds a left message to a channel
-}
showLeft : Model -> Model
showLeft model =
      add ("Left channel " ++ model.name) model


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
            in
                add msg model

        Err error ->
            let
                _ =
                    Debug.log "Error processing chat message." error
            in
                model
