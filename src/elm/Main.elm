module Main exposing (..)

import Html exposing (Html, div, nav, a, button, text, span, p, label)
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
        [ World.view model
        , controlsView model
        , hudView model
        ]

--TODO: divide the coordinates by the tilesize so we get raw coords?
hudView : Model -> Html Msg
hudView model =
    div [ class "hud hud-tiledata" ]
        [ renderTileData "type: " [ text model.tileData.loc.type_ ]
        , renderTileData "x: " [ text model.tileData.x ]
        , renderTileData "y: " [ text model.tileData.y ]
        , renderTileData "entities" (List.map renderEntity model.tileData.loc.entities)
        ]

renderTileData : String -> List (Html Msg) -> Html Msg
renderTileData key value =
        label [ class "tilelabel" ]
            [ text key
            , span [ class "tiledata" ] value
            ]
renderEntity : String -> Html Msg
renderEntity entity =
    div [class "entity-data"] [ text entity ]

controlsView : Model -> Html Msg
controlsView model =
    case model.ui.chatView of
        True ->
            div [ class "controls" ]
                [ Html.map ChatMsg (Chat.View.view model.chat)
                , button [ class "button is-small chat-toggle hud"
                         , onClick ToggleChatView
                         ] [ text "X" ]
                ]

        False ->
            div [ class "controls" ]
                [ button [ class "button is-small chat-toggle hud"
                         , onClick ToggleChatView
                         ] [ text "Chat" ]
                ]


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
            [ div [ class "navbar-item" ] []
            ]
        ]


navButton : String -> Msg -> Html Msg
navButton txt action =
    button [ class "button nav-button is-primary", onClick action ]
        [ text txt ]
