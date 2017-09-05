module Chat.View exposing (view)

import Html exposing (Html, h3, div, text, ul, li, input, form, button, br, table, tbody, tr, td)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onInput, onSubmit, onClick)
import Chat.Model exposing (..)
import Phoenix.Channel
import Dict exposing (Dict)




-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Channels:" ]
        , div
            []
            [ button [ onClick JoinChannel ] [ text "Join channel" ]
            , button [ onClick LeaveChannel ] [ text "Leave channel" ]
            ]
        , channelsTable (Dict.values model.phxSocket.channels)
        , br [] []
        , h3 [] [ text "Messages:" ]
        , newMessageForm model
        , ul [] ((List.reverse << List.map renderMessage) model.messages)
        ]


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


newMessageForm : Model -> Html Msg
newMessageForm model =
    form [ onSubmit SendMessage ]
        [ input [ type_ "text", value model.newMessage, onInput SetNewMessage ] []
        ]


renderMessage : String -> Html Msg
renderMessage str =
    li [] [ text str ]
