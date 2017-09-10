module Main exposing (..)

import Html exposing (Html, div, nav, a, button, text, span)
import Html.Attributes exposing (id, class, attribute, href)
import Html.Events exposing (onClick)
import App.Model exposing (..)
import App.Update exposing (update)
import App.Config exposing (init)
import App.Model exposing (UI)
import Phoenix.Socket
import World.View as World
import Chat.View


-- import Auth


main : Program Never Model Msg
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
        ]



-- VIEW

-- TODO: move the navigation/main views out into its own module
view : Model -> Html Msg
view model =
    div []
        [ navView model.ui
        , mainView model
        ]


mainView : Model -> Html Msg
mainView model =
    case model.ui.viewing of
        Chat ->
            Html.map ChatMsg (Chat.View.view model.chat)

        World ->
            World.view model


navView : UI -> Html Msg
navView model =
    let
        active =
            if model.nav.isActive then
                " is-active"
            else
                ""
    in
        nav [ class "navbar" ]
            [ navBrand model
            , navMenu active
            ]


navBrand : UI -> Html Msg
navBrand model =
    let
        active =
            case model.nav.isActive of
                True ->
                    " is-active"

                False ->
                    ""
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


navMenu : String -> Html Msg
navMenu active =
    div [ id "navMenubd", class ("navbar-menu" ++ active) ]
        [ div [ class "navbar-start" ]
            [ div [ class "navbar-item" ]
                [ navButton "World" (ChangeView World)
                , navButton "Chat" (ChangeView Chat)
                ]
            ]
        ]


navButton : String -> Msg -> Html Msg
navButton txt action =
    button [ class "button nav-button is-primary", onClick action ]
        [ text txt ]
