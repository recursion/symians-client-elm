port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import App.Styles
import UI.Styles


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "public/css/index.css", Css.File.compile [ App.Styles.css, UI.Styles.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
