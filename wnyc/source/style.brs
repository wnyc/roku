' To do: this entire thing. Why doesn't it work?
Function InitTheme() as void
    app = CreateObject("roAppManager")
    listItemHighlight           = "#FFFFFF"
    listItemText		= "#F0F8FF"
    backgroundColor             = "#333333"
    theme = {
        BackgroundColor: "#333333" 
        ListItemText: listItemText
        ListItemHighlightText: listItemHighlight
        ListScreenDescriptionText: listItemText
        ListScreenBackgroundColor: backgroundColor
        GridScreenBackgroundColor: backgroundColor
        GridScreenFocusBorderHD: ""
    }
    app.SetTheme( theme )
End Function
