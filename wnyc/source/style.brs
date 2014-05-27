' To do: this entire thing.
Function InitTheme() as void
    app = CreateObject("roAppManager")
    white = "#FFFFFF"
    grey  = "#333333"
    'ugly  = "#3300FF" Bright, ugly blue. For testing attributes.
    theme = {
        BackgroundColor: grey 
        SpringboardActorColor: white 
        SpringboardAlbumLabelColor: white
        SpringboardArtistColor: white
        SpringboardArtistLabelColor: white
        SpringboardTitleText: white
        SpringboardRuntimeColor: white
        SpringboardSynopsisColor: white ' End Audio Player Config
        ListItemText: white
        ListItemHighlightText: white 
        ListScreenDescriptionText: white 
        ListScreenBackgroundColor: grey
        GridScreenOverhangHeightHD: "99"
        'GridScreenBackgroundColor: "#363636" 
        GridScreenBackgroundColor: grey 
        GridScreenFocusBorderHD: "pkg:/images/ja1.png" 
        GridScreenBorderOffsetHD: "(-10,-30)"
        OverhangPrimaryLogoOffsetHD_X: 1280
        OverhangPrimaryLogoOffsetHD_Y: 720
    }
    app.SetTheme( theme )
End Function
