module App.View exposing (view)
import Html exposing (Html, h3, div, text, ul, li, input, form, button, br, table, tbody, tr, td)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onInput, onSubmit, onClick)
import App.Model exposing (Msg(..), Model)
import Phoenix.Channel
import Dict

-- VIEW


view : Model -> Html Msg
view model =
  div []
      [ channels model
      , messages model
      , user model
      ]

-- Users views 

user : Model -> Html Msg
user model =
  let
    id = (toString (Maybe.withDefault 0 model.user.id))
    token = (Maybe.withDefault "" model.user.token)
  in
    div
      [ class "user" ]
      [ h3 [] [text id]
      , h3 [] [text token]
      , h3 [] [text model.user.status]
      ]

-- Messages Views

messages model =
  div [ class "messages" ]
      [ h3 [] [ text "-> Messages:" ]
      , newMessageForm model
      , ul [] ((List.reverse << List.map renderMessage) model.messages)
      ]

newMessageForm : Model -> Html Msg
newMessageForm model =
    form [ onSubmit SendMessage ]
        [ input [ type_ "text", value model.newMessage, onInput SetNewMessage ] []
        ]


renderMessage : String -> Html Msg
renderMessage str =
    li [] [ text str ]



-- Channels Views


channels model =
  div [ class "channels" ]
      [ h3 [] [ text "Channels:" ]
      , div []
        [ button [ onClick (JoinChannel "chat:lobby") ] [ text "Join channel Lobby" ]
        , button [ onClick (LeaveChannel "chat:lobby") ] [ text "Leave channel Lobby" ]
        , button [ onClick (JoinChannel "chat:system") ] [ text "Join channel Secret" ]
        , button [ onClick (LeaveChannel "chat:system") ] [ text "Leave channel Secret" ]
        , button [ onClick (Subscribe "new:msg" "chat:lobby" ReceiveChatMessage) ] [ text "Sub"]
        ]
      , channelsTable (Dict.values model.phxSocket.channels)
      , br [] []
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

