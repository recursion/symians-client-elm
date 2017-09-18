module Inspector.Update exposing (..)

import Inspector.Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetInspected coords location ->
            ( { model | inspection = Inspection coords location }, Cmd.none )

        ToggleVisible ->
            ( { model | visible = not model.visible }, Cmd.none )
