module Console.Input exposing (..)

import Console.Model exposing (..)
import Chat.Model as Chat
import App.Model exposing (SocketAction(..))
import Chat.Decoders exposing (encodeChatMessage)
import Utils exposing ((=>))



process : Model -> ( ( Model, Cmd Msg ), SocketAction )
process model =
    let
        _ =
            Debug.log "---> " ()

        processInput =
            if (String.left 1 model.input) == "\\" then
                Debug.log ("Got console input: " ++ model.input) NoAction
            else
                Send Chat.newMsgEvent (encodeChatMessage model.input)
    in
        if model.input == "" then
            ( { model | input = "" } , Cmd.none ) => NoAction
        else
            ( { model | input = "" } , Cmd.none ) => processInput
