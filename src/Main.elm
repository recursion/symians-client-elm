module Main exposing (..)

import Html exposing (..)
import Chat.Chat as Chat
import App.Model exposing (..)
import App.Update exposing (update)
import App.Config exposing (init)
import Phoenix.Socket
import Chat.View
-- import Auth


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
        Sub.batch [ Phoenix.Socket.listen model.socket PhoenixMsg
                  , Sub.map ChatMsg (Chat.subscriptions model.chat)
                  ]



-- VIEW


view : Model -> Html Msg
view model =
        Html.map ChatMsg (Chat.View.view model.chat)
        -- for debug only, Auth.view model.auth
