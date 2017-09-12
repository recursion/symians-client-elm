module Chat.View exposing (view)

import Html exposing (Html, h3, p, div, text, ul, li, input, form, button, br, table, tbody, tr, td)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onInput, onSubmit, onClick, onFocus, onBlur)
import Chat.Model exposing (..)
import Chat.Channel as Channel
import Phoenix.Channel


-- VIEW


view : Model -> Html Msg
view model =
    div [ class "chat-container" ]
        [ div [ class "messagebox hud" ]
            [ messages model
            ]
        , newMessageForm model

        -- , channelsTable (Dict.values model.phxSocket.channels)
        ]



-- messages


messages : Model -> Html Msg
messages model =
    ul [ class "messages" ]
        ((List.map renderMessage) (Channel.getCurrent model).messages)


renderMessage : String -> Html Msg
renderMessage str =
    li [ class "block chatMessage" ] [ text str ]


newMessageForm : Model -> Html Msg
newMessageForm model =
    div [ class "" ]
        [ form [ class "field has-addons messageControls", onSubmit SendMessage ]
            [ sendButton
            , messageInput model
            ]
        ]

sendButton : Html Msg
sendButton =
    p [ class "control" ]
        [ button [ class "button isStatic is-small hud" ]
              [ text "Send" ]
        ]

messageInput : Model -> Html Msg
messageInput model =
    p [ class "control messageInput" ]
        [ input
            [ class "input is-small hud"
            , type_ "text"
            , value model.newMessage
            , onInput SetNewMessage
            , onFocus ToggleChatInputFocus
            , onBlur ToggleChatInputFocus
            ]
            []
        ]



-- Channels


channelsButtons : Html Msg
channelsButtons =
    div [ class "panel-block channel-buttons" ]
        [ p [ class "control" ]
            [ channelButton "Join chat" JoinChannel
            , channelButton "Leave chat" LeaveChannel
            ]
        ]


channelButton : String -> Msg -> Html Msg
channelButton name action =
    button [ class "button isPrimary", onClick action ] [ text name ]


channelsTable : List (Phoenix.Channel.Channel Msg) -> Html Msg
channelsTable channels =
    table []
        [ tbody [] (List.map channelRow channels)
        ]


channelRow : Phoenix.Channel.Channel Msg -> Html Msg
channelRow channel =
    tr []
        [ td [] [ text channel.name ]
        , td [] [ (text << toString) channel.payload ]
        , td [] [ (text << toString) channel.state ]
        ]
