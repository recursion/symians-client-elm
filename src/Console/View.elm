module Console.View exposing (render)

import Element exposing (..)
import Element.Events exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input
import Console.Model exposing (..)
import App.Styles exposing (Styles(..), stylesheet)
import Chat.Model as Chat


render : Chat.Model -> Model -> Element Styles variation Msg
render chatModel model =
    if model.visible then
        (column Hud
            [ width fill, padding 1, clip ]
            [ (renderMessages chatModel model)
            , (console model)
            ]
        )
    else
        empty


console : Model -> Element Styles variation Msg
console model =
    row None
        [ width fill, padding 1, spacing 1 ]
        ([ button Hud [ onClick SubmitInput ] (text "send")
         , consoleInput model
         ]
        )


consoleInput : Model -> Element Styles variation Msg
consoleInput model =
    el None
        [ width fill ]
        (Input.text Hud
            [ onFocus ToggleInputFocus
            , onBlur ToggleInputFocus
            , width fill
            , padding 3
            ]
            { value = model.input
            , onChange = SetInput
            , label =
                Input.placeholder
                    { label = Input.labelLeft empty
                    , text = "\\h for help."
                    }
            , options =
                []
            }
        )


renderMessages : Chat.Model -> Model -> Element Styles variation Msg
renderMessages chatModel model =
    let
        props =
            if model.scroll then
                [ yScrollbar ]
            else
                [ alignBottom ]
    in
        column None
            (props
                ++ [ padding 2
                   , height (px 100)
                   , width fill
                   , onMouseOver ToggleScrollBar
                   , onMouseOut ToggleScrollBar
                   ]
            )
            ((List.map renderMessage) (List.reverse chatModel.messages))


renderMessage : String -> Element Styles variation Msg
renderMessage msg =
    el None [ padding 3 ] (text msg)
