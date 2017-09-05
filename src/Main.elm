module Main exposing (..)

import Html exposing (..)
import Chat.Chat as Chat
import App.Model exposing (..)
import App.Update exposing (update)
import Phoenix.Socket
import Chat.View
import Auth


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
    let
        -- Phoenix.Socket.listen model.socket PhoenixMsg
        local =
            Phoenix.Socket.listen model.socket PhoenixMsg
    in
        Sub.batch [ local, Sub.map ChatMsg (Chat.subscriptions model.chat) ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.map ChatMsg (Chat.View.view model.chat)
        , Auth.view model.auth
        ]
