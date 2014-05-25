' To do: this entire thing. Why doesn't it work?
Function InitTheme() as void
    app = CreateObject("roAppManager")
    listItemHighlight           = "#FFFFFF"
    listItemText                = "#707070"
    backgroundColor             = "#333333"
    theme = {
        BackgroundColor: "#333333" 
        ListItemText: listItemText
        ListItemHighlightText: listItemHighlight
        ListScreenDescriptionText: listItemText
        ListScreenBackgroundColor: backgroundColor
        GridScreenBackgroundColor: backgroundColor
        GridScreenFocusBorderHD: ""

'        GridScreenLogoHD: "pkg://images/wnyc_2_1.png"
'        GridScreenLogoSD: "pkg://images/background.jpg"
    '    GridScreenOverhangHeightHD: "69"
    '    GridScreenOverhangHeightSD: "69"
'        GridScreenOverhangSliceHD: "pkg:/images/wnyc_2_1.png"
'        GridScreenOverhangSliceSD: "pkg:/images/wnyc_2_1.png"
'         GridScreenLogoOffsetHD_X: "0"
'         GridScreenLogoOffsetHD_Y: "0"
    '    GridScreenLogoOffsetSD_X: "0"
    '    GridScreenLogoOffsetSD_Y: "0"

      '  OverhangPrimaryLogoHD: "pkg:/images/nypr-splash-title.gif"
      '  OverhangPrimaryLogoOffsetHD_X: "0"
      '  OverhangPrimaryLogoOffsetHD_Y: "0"
    }
    app.SetTheme( theme )
End Function
