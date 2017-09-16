module App.Styles exposing (..)

import Color exposing (rgba)
import Style exposing (..)
import Style.Border as Border
import Style.Color as Color
-- import Style.Font as Font
-- import Style.Transition as Transition

type Styles
    = None
    | Hud
    | Test

colors : {hudBackground : Color.Color}
colors =
    { hudBackground = rgba 80 80 80 0.5
    }

stylesheet : StyleSheet Styles variation
stylesheet =
    Style.styleSheet
        [ style None [] -- It's handy to have a blank style
        , style Hud
            [ Color.background colors.hudBackground
            , Border.all 1
            , Border.solid
            , Color.border Color.black
            ]
        , style Test
            [ Color.border Color.red
            ]
        ]

