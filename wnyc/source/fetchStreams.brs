' ****************
' Streams API doesn't quite return the data that Roku wants. 
' Fetch and massage it a little, return a Brightscript Audio MetaData object.
' This could be generalized to return metadata for video and mp3s. 
' ***************

Function FetchStreams(list as Object)
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
        formatedMeta = makeMeta(list, streamsJSON) 
        return formatedMeta 
    else
        print "Didn't receive roUrlEvent when fetching streams"
        return false
    endif
End Function

Function makeMeta(list as Object, json as Object)
    streamsMeta = CreateObject("roArray", 20, true)
    tempMeta    = CreateObject("roArray", 20, true)
    
    for Each i in json.results
        for Each show in list 
            if i.slug = show
                s = CreateObject("roAssociativeArray") 
                s.Title = i.name
                s.ShortDescriptionLine1 = i.short_description
                s.ContentType = "audio"
                s.StreamFormat = "mp3"
                s.HDPosterUrl  = i.image_logo ' Need function to parse out the image file name.
                s.SDPosterUrl  = i.image_logo
                s.StreamUrls   = [ i.mp3_streams, ]
                s.Position     = i.site_priority 
                s.Slug         = i.slug
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
End Function 
