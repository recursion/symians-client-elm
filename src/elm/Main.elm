module Main exposing (..)

import Html exposing (Html, div, nav, a, button, text, span)
import Html.Attributes exposing (id, class, attribute, href)
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
    div []
        [ navView model.ui.nav
        , mainView model
        ]


mainView model =
    case model.ui.viewing of
        Chat ->
            Html.map ChatMsg (Chat.View.view model.chat)

        World ->
            World.view model


navView model =
    let
        active =
            if model.isActive then
                " is-active"
            else
                ""
    in
        nav [ class "navbar" ]
            [ navBrand model
            , navMenu active
            ]


navBrand model =
    let
        active = case model.isActive of
                     True -> " is-active"
                     False -> ""
    in
      div [ onClick ActivateNav, class "navbar-brand", attribute "data-target" "navMenubd" ]
          [ div [ class "navbar-item logo" ]
                [ text "Symians" ]
          , div [ class ("navbar-burger burger" ++ active) ]
              [ span [] []
              , span [] []
              , span [] []
              ]
          ]

navMenu active =
    div [ id "navMenubd", class ("navbar-menu" ++ active) ]
        [ div [ class "navbar-start" ]
            [ div [ class "navbar-item" ]
                [ navButton "World" (ChangeView World)
                , navButton "Chat" (ChangeView Chat)
                ]
            ]
        ]



navButton txt action =
    button [ class "button nav-button", onClick action ]
        [ text txt ]
