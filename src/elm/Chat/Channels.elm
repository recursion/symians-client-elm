module Chat.Channels exposing (..)

import Chat.Model exposing (..)
import Dict exposing (Dict)




{-| Get the current Channel
-}
getCurrent : Model -> Channel
getCurrent model =
    Maybe.withDefault (Channel []) (Dict.get model.currentChannel model.channels)
