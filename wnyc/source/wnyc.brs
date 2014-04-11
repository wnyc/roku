REM ******************************************************
REM
REM FetchStreams
REM
REM GET streams API and return data
REM
REM ******************************************************
Function FetchStreams()
    responsePort = CreateObject("roMessagePort")
    request = CreateObject("roUrlTransfer")
    request.SetMessagePort(responsePort)
    request.SetUrl("http://www.wnyc.org/api/v1/list/streams/")
    success = request.AsyncGetToString()

    if (not success) then
        print request.GetFailureReason()
        return false
    endif

    event = wait(0, responsePort)
    if (type(event) = "roUrlEvent")
        streamsJSON = ParseJSON(event.GetString())
        return streamsJSON
    else
        print "Didn't receive roUrlEvent when fetching streams"
        return false
    endif
End Function



' *********************************************************
' ** WNYC Stream Player
' *********************************************************
Sub Main()
    screen = CreateObject("roParagraphScreen")
    screen.SetTitle("Loading")
    screen.AddParagraph("Fetching streams list")
    screen.Show()
    streams = FetchStreams()
    if (not streams) then
        print "Streams failed to fetch"
        return
    else
        print "Fetched streams"
        For Each stream In streams
            screen.AddParagraph(stream.name)
        End For
    endif
End Sub
