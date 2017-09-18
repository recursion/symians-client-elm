module UI.Console.View exposing (render)

import Html exposing (Html, div, text, ul, li, button, input)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onFocus, onBlur, onInput, onClick)
import UI.Console.Model exposing (..)
import Chat.Model as Chat


render : Chat.Model -> Model -> Html Msg
render chatModel model =
    if model.visible then
        div []
            [ (renderMessages chatModel model)
            , (console model)
            ]
    else
        text ""


console : Model -> Html Msg
console model =
    div []
        [ button [ onClick SubmitInput ] [text "send"]
        , consoleInput model
        ]


consoleInput : Model -> Html Msg
consoleInput model =
    input
        [ onFocus ToggleInputFocus
        , onBlur ToggleInputFocus
        , onInput SetInput
        , placeholder "\\h for help."
        ]
        []


renderMessages : Chat.Model -> Model -> Html Msg
renderMessages chatModel model =
    ul []
        ((List.map renderMessage) (List.reverse chatModel.messages))


renderMessage : String -> Html Msg
renderMessage msg =
    li [] [ text msg ]
