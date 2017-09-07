module Main exposing (..)

import Html exposing (Html, div, nav, a, button, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Chat.Chat as Chat
import App.Model exposing (..)
import App.Update exposing (update)
import App.Config exposing (init)
import Phoenix.Socket
import World.View as World
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
    Sub.batch
        [ Phoenix.Socket.listen model.socket PhoenixMsg
        , Sub.map ChatMsg (Chat.subscriptions model.chat)
        ]



-- VIEW


view : Model -> Html Msg
view model =
    let
        mainView =
            case model.ui.viewing of
                Chat ->
                    Html.map ChatMsg (Chat.View.view model.chat)

                World ->
                    World.view model
    in
        div []
            [ navView
            , mainView
            ]


navView =
    nav [ class "navbar" ]
        [ div [ class "navbar-brand" ]
            [ navButton "Symians" (ChangeView World)
            , navButton "World" (ChangeView World)
            , navButton "Chat" (ChangeView Chat)
            ]
        ]


navButton txt action =
    button [ class "navbar-item button", onClick action ]
        [ text txt ]
