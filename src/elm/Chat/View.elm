module Chat.View exposing (view)

import Html exposing (Html, h3, p, div, text, ul, li, input, form, button, br, table, tbody, tr, td)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onInput, onSubmit, onClick)
import Chat.Model exposing (..)
import Chat.Channel as Channel
import Phoenix.Channel


-- import Dict exposing (Dict)
-- VIEW


view : Model -> Html Msg
view model =
    div [class "panel"]
      [ div [ class "panel-block messagebox" ]
          [ messages model
          ]
      , newMessageForm model
      , channelsButtons
      -- , channelsTable (Dict.values model.phxSocket.channels)
      ]


messages model =
    ul [ class "messages" ]
        ((List.map renderMessage) (Channel.getCurrent model).messages)


channelsButtons =
    div [ class "panel-block channel-buttons" ]
        [ p [ class "control" ]
            [ channelButton "Join chat" JoinChannel
            , channelButton "Leave chat" LeaveChannel
            ]
        ]

channelButton name action =
        button [ class "button isPrimary", onClick action] [ text name ]

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
    div [ class "panel-block" ]
        [ form [ class "field has-addons messageControls", onSubmit SendMessage ]
            [ p [ class "control" ]
                [ button [ class "button isStatic" ] [ text "Send" ]
                ]
            , p [ class "control messageInput" ]
                [ input [ class "input large", type_ "text", value model.newMessage, onInput SetNewMessage ] []
                ]
            ]
        ]


renderMessage : String -> Html Msg
renderMessage str =
    li [ class "block chatMessage" ] [ text str ]