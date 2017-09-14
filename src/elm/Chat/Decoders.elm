module Chat.Decoders exposing (..)

import Chat.Model exposing (ChatMessage)
import Json.Decode as JD exposing (field, maybe, int, string, float, nullable, Decoder)
import Json.Encode as JE

chatMessageDecoder : JD.Decoder ChatMessage
chatMessageDecoder =
    JD.map2 ChatMessage
        (field "user" JD.string)
        (field "body" JD.string)

decodeChatMessage : JD.Value -> Result String ChatMessage
decodeChatMessage =
    JD.decodeValue chatMessageDecoder


encodeChatMessage : String -> String -> JE.Value
encodeChatMessage msg token =
    (JE.object [ ( "token", JE.string token ), ( "body", JE.string msg ) ])
