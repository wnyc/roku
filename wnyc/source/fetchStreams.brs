Function fetchStreams(list as Object)
    streams_json     = FetchJSON("http://www.wnyc.org/api/v1/list/streams/")
    whats_on_json    = FetchJSON("http://www.wnyc.org/api/v1/whats_on/")
    d                = getMeta(list, streams_json, whats_on_json) 
    return d
End Function

Function FetchJSON(api_url as Object)
    responsePort = CreateObject("roMessagePort")
    request = CreateObject("roUrlTransfer")
    request.SetMessagePort(responsePort)

    request.SetUrl(api_url)
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


Sub getMeta(list as Object, streams_json as Object, whats_on_json as Object) as Object
    streamsMeta = CreateObject("roArray", 20, true)
    tempMeta    = CreateObject("roArray", 20, true)

    for Each show in list 
        for Each i in streams_json.results
            if i.slug = show
                s = CreateObject("roAssociativeArray") 
                s.Title = i.name
                s.ShortDescriptionLine1 = i.short_description
                s.ContentType = "audio"
                s.StreamFormat = "mp3"
                s.HDPosterUrl  = i.image_logo ' Need function to parse out the image file name.
                s.SDPosterUrl  = i.image_logo
                s.StreamUrls   = [ i.mp3_streams, ]
                print i.mp3_streams
                s.Position     = i.site_priority 
                s.Slug         = i.slug
                s.Description  = whats_on_json[show].current_show.description
                s.showHDPosterUrl  = whats_on_json[show].current_show.fullImage.url    
                tempMeta.Push(s)
           End If
        End For 
    End For 

    for Each item in list           ' Return stations in the order they were passed to us.
        for each hash in tempMeta 
            if item = hash.slug
            streamsMeta.Push(hash)
            End If
        End For
    End For
    return streamsMeta
End Sub 
