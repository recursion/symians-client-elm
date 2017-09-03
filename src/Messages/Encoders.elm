module Messages.Encoders exposing (..)
import Json.Encode as JE

userParams : JE.Value
userParams =
    JE.object [ ( "user_id", JE.string "123" ) ]
