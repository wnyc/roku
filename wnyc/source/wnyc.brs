' *********
'
'   New York Public Radio. 
'   Main Screen/Entry Point. 
'
' *********

Function Main()
    port = CreateObject("roMessagePort")
    grid = CreateObject("roGridScreen")
    grid.SetMessagePort(port)

    InitTheme()
    grid.SetGridStyle("four-column-flat-landscape") 
    grid.SetDisplayMode("scale-to-fit")

    rowTitles  = ["On Air Now",]
    liveStations = ["wnyc-fm939", "wqxr", "jonathan-channel", "q2", "njpr"]
    
    grid.SetupLists(rowTitles.Count())
    grid.SetListNames(rowTitles)
    
    grid.SetDescriptionVisible(true)
    grid.SetFocusedListItem(0, 3) 

    streams  = CreateObject("roArray")
    streams  = fetchStreams(liveStations)
    streams.Push("") ' Empty Item will create a blank poster to show the end of the list.
    grid.SetContentList(0, streams)

    grid.Show()
    
    while true
         msg = wait(0, grid.GetMessagePort())
         if type(msg) = "roGridScreenEvent" then
             if msg.isScreenClosed() then
                 return -1
             elseif msg.isListItemFocused()
                 print "Focused msg: ";msg.GetMessage();"row: ";msg.GetIndex();
                 print " col: ";msg.GetData()
             elseif msg.isListItemSelected()
                 print "Selected msg: ";msg.GetMessage();"row: ";msg.GetIndex();
                 print " col: ";msg.GetData()
                 selected = msg.GetData()
                 print selected
                 Show_Audio_Screen(streams[selected], "")
             endif
         endif
     end while
End Function
