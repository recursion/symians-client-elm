module Messages.Decoders exposing (..)

import Json.Decode as JD exposing (field)
import Messages.Models as Msgs

joinMessageDecoder : JD.Decoder Msgs.Join
joinMessageDecoder =
    JD.map3 Msgs.Join
        (field "status" JD.string)
        (JD.maybe (field "id" JD.int))
        (JD.maybe (field "token" JD.string))

chatMessageDecoder : JD.Decoder Msgs.Chat 
chatMessageDecoder =
    JD.map2 Msgs.Chat
        (field "user" JD.string)
        (field "body" JD.string)


decodeChatMessage = 
  JD.decodeValue chatMessageDecoder

decodeJoinMessage = 
  JD.decodeValue joinMessageDecoder
