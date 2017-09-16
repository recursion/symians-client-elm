module UI.Views.Console exposing (render)

import Element exposing (..)
import Element.Events exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input
import UI.Model exposing (..)
import App.Styles exposing (Styles(..), stylesheet)
import Json.Decode as JD
import Chat.Model as Chat


-- VIEW

render : Chat.Model -> Model -> Element Styles variation Msg
render chatModel model =
    if model.viewConsole then
        modal None
            [ alignBottom, alignLeft, width (percent 60) ]
            (column Hud
                [ width fill, padding 1 ]
                [ (messages chatModel)
                , (console model)
                ]
            )
    else
        empty


messages : Chat.Model -> Element Styles variation Msg
messages chatModel =
    column None
        [ padding 2
        , alignBottom
        , height (px 100)
        , width fill
        , clip
        , yScrollbar
        ]
        ((List.map renderMessage) (List.reverse chatModel.messages))


renderMessage : String -> Element Styles variation Msg
renderMessage str =
    el None [] ( text str )



-- Console


console : Model -> Element Styles variation Msg
console model =
    row None
        [ width fill, padding 2, spacing 3 ]
        [ sendButton
        , consoleInput model
        ]


consoleInput : Model -> Element Styles variation Msg
consoleInput model =
    el None
        [ width fill ]
        (Input.text Hud
            [ onFocus ToggleConsoleFocus
            , onBlur ToggleConsoleFocus
            , on "keyup" (JD.map ConsoleInput keyCode)
            , width fill
            ]
            { value = model.consoleInput
            , onChange = SetConsoleInput
            , label =
                Input.placeholder
                    { label = Input.labelLeft empty
                    , text = "Enter \\help for help."
                    }
            , options =
                []
            }
        )

sendButton : Element Styles variation Msg
sendButton =
    button Hud [ onClick SubmitConsoleInput ] (text "send")
