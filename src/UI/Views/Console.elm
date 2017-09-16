module UI.Views.Console exposing (render)

import Html exposing (Html, h3, p, div, text, ul, li, input, form, button, br, table, tbody, tr, td)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onInput, onSubmit, onClick, onFocus, onBlur)
import UI.Model exposing (..)
import Chat.Model as Chat

-- VIEW


render : Chat.Model -> Model -> Html Msg
render chatModel model =
    if model.viewConsole then
        div [ class "hud console" ]
            [ div [ class "hud console-display" ]
                [ messages chatModel
                ]
            , console model
            ]
    else
        text ""



-- messages


messages : Chat.Model -> Html Msg
messages chatModel =
    ul [ class "console-messages" ]
        ((List.map renderMessage) chatModel.messages)


renderMessage : String -> Html Msg
renderMessage str =
    li [ class "block console-message" ] [ text str ]


console : Model -> Html Msg
console model =
     form [ class "field has-addons console-message_controls", onSubmit SubmitConsoleInput ]
            [ sendButton
            , consoleInput model
            ]


sendButton : Html Msg
sendButton =
    p [ class "console-control" ]
        [ button [ class "button isStatic is-small hud" ]
            [ text "Send" ]
        ]


consoleInput : Model -> Html Msg
consoleInput model =
    p [ class "console-control console-input" ]
        [ input
            [ class "input is-small hud"
            , type_ "text"
            , value model.consoleInput
            , onInput SetConsoleInput
            , onFocus ToggleConsoleFocus
            , onBlur ToggleConsoleFocus
            ]
            []
        ]
