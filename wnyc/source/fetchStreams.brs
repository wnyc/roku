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
        for Each stream in streams_json.results
            
            if stream.slug = show
                s = CreateObject("roAssociativeArray") 
                
                 if (whats_on_json[show].current_show.show_title = invalid ) 
                    s.Title    = stream.Name
                else                
                    s.Title    = whats_on_json[show].current_show.show_title
                End If
                
                s.ShortDescriptionLine1 = stream.short_description
                s.ContentType  = "audio"
                s.StreamFormat = "mp3"
                s.HDPosterUrl  = stream.image_logo 
                s.SDPosterUrl  = stream.image_logo
                s.StreamUrls   = [ stream.mp3_streams, ]
                s.Position     = stream.site_priority 
                s.Slug         = stream.slug
                s.Description  = whats_on_json[show].current_show.description
                s.ShowTitle    = whats_on_json[show].current_show.show_title
                s.showHDPosterUrl  = whats_on_json[show].current_show.fullImage.url    
               ' s.showHDPosterUrl  = whats_on_json[show].current_show.group_image    
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
