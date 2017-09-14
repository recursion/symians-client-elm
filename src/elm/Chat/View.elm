module Chat.View exposing (root)

import Html exposing (Html, h3, p, div, text, ul, li, input, form, button, br, table, tbody, tr, td)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onInput, onSubmit, onClick, onFocus, onBlur)
import Chat.Model exposing (..)


-- VIEW


root : Model -> Html Msg
root model =
    div [ class "chat-container" ]
        [ div [ class "messagebox hud" ]
            [ messages model
            ]
        , newMessageForm model
        ]


-- messages


messages : Model -> Html Msg
messages model =
    ul [ class "messages" ]
        ((List.map renderMessage) model.messages)


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
