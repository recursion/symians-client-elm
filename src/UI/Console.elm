module UI.Console exposing (render, process)

import Element exposing (..)
import Element.Events exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input
import UI.Model exposing (..)
import App.Styles exposing (Styles(..), stylesheet)
import Chat.Model as Chat
import App.Model exposing (SocketAction(..))
import Chat.Decoders exposing (encodeChatMessage)


(=>) =
    (,)


process : Model -> ( ( Model, Cmd Msg ), SocketAction )
process model =
    let
        _ =
            Debug.log "---> " ()

        processInput =
            if (String.left 1 model.consoleInput) == "\\" then
                Debug.log ("Got console input: " ++ model.consoleInput) NoAction
            else
                Send Chat.newMsgEvent (encodeChatMessage model.consoleInput)
    in
        if model.consoleInput == "" then
            ( { model | consoleInput = "" }, Cmd.none ) => NoAction
        else
            ( { model | consoleInput = "" }, Cmd.none ) => processInput



-- VIEW


render : Chat.Model -> Model -> Element Styles variation Msg
render chatModel model =
    if model.viewConsole then
        modal None
            [ alignBottom, alignLeft, width (percent 60) ]
            (column Hud
                [ width fill, padding 1, clip]
                [ (renderMessages chatModel model)
                , (console model)
                ]
            )
    else
        empty


renderMessages : Chat.Model -> Model -> Element Styles variation Msg
renderMessages chatModel model =
    if model.consoleScroll then
        column None
            [ padding 2
            , height (px 100)
            , width fill
            , yScrollbar
            , onMouseOver ToggleConsoleScrollBar
            , onMouseOut ToggleConsoleScrollBar
            ]
            ((List.map renderMessage) (List.reverse chatModel.messages))

    else 
        column None
            [ padding 2
            , alignBottom
            , height (px 100)
            , width fill
            , onMouseOver ToggleConsoleScrollBar
            , onMouseOut ToggleConsoleScrollBar
            ]
            ((List.map renderMessage) (List.reverse chatModel.messages))


renderMessage : String -> Element Styles variation Msg
renderMessage msg =
    el None [ padding 3 ] (text msg)



-- Console


console : Model -> Element Styles variation Msg
console model =
    row None
        [ width fill, padding 2, spacing 3 ]
        ([ button Hud [ onClick SubmitConsoleInput ] (text "send")
         , consoleInput model
         ]
        )


consoleInput : Model -> Element Styles variation Msg
consoleInput model =
    el None
        [ width fill ]
        (Input.text Hud
            [ onFocus ToggleConsoleFocus
            , onBlur ToggleConsoleFocus
            , width fill
            , padding 3
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
