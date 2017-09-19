module UI.Console.View exposing (render)

import Html exposing (Html, div, text, ul, li, button, input)
import Html.Attributes exposing (placeholder, class, value, id)
import Html.Events exposing (onFocus, onBlur, onInput, onClick)
import UI.Console.Model exposing (..)
import Chat.Model as Chat


render : Chat.Model -> Model -> Html Msg
render chatModel model =
    if model.visible then
        div [ class "console"]
            [ renderMessages chatModel model
            , inputControls model
            ]
    else
        text ""


inputControls : Model -> Html Msg
inputControls model =
    div [ class "console-controls"]
        [ button [ onClick SubmitInput, class "console-button hud" ] [text "send"]
        , input [ onFocus ToggleInputFocus
                , onBlur ToggleInputFocus
                , onInput SetInput
                , placeholder "\\h for help."
                , class "console-input hud"
                , value model.input
                ] []
        ]



renderMessages : Chat.Model -> Model -> Html Msg
renderMessages chatModel model =
    ul [ id "console-messages", class "hud"]
        ((List.map renderMessage) chatModel.messages)


renderMessage : String -> Html Msg
renderMessage msg =
    li [] [ text msg ]
