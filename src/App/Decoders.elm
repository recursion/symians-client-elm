module App.Decoders exposing (..)

import Json.Decode as JD exposing (field, maybe)
import Auth


tokenMessageDecoder : JD.Decoder Auth.Model
tokenMessageDecoder =
    JD.map3 Auth.Model
        (maybe (field "id" JD.int))
        (maybe (field "token" JD.string))
        (field "status" JD.string)

decodeTokenMessage =
  JD.decodeValue tokenMessageDecoder
