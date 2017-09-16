module App.Styles exposing (..)

import Color exposing (rgba)
import Style exposing (..)
import Style.Border as Border
import Style.Color as Color
-- import Style.Shadow as Shadow
import Style.Font as Font
-- import Style.Transition as Transition

type Styles
    = None
    | Hud
    | Load
    | Test

colors : {hudBackground : Color.Color}
colors =
    { hudBackground = rgba 80 80 80 0.5
    }

stylesheet : StyleSheet Styles variation
stylesheet =
    Style.styleSheet
        [ style None []
        , style Load
            [ Font.size 62
            , Font.letterSpacing 10
            , Font.lineHeight 1.5
            , Font.bold
            , Font.typeface
                [ Font.font "helvetica"
                , Font.font "arial"
                , Font.font "sans-serif"
                ]
            ]
        , style Hud
            [ Color.background colors.hudBackground
            , Border.all 1
            , Border.solid
            , Color.border Color.black
            , focus [ prop "outline" "none"
                    ]
            ]
        , style Test
            [ Color.border Color.red
            ]
        ]

