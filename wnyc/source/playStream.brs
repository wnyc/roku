' ***************
' Audio Player 
' **************

Sub Show_Audio_Screen(song as Object, prevLoc as string)
    Audio = AudioInit() 
    print song.showHDPosterUrl
'    picture = getSizedImageUrl("188", "188", song.showHDPosterUrl)
    picture = song.showHDPosterUrl
    print "picture at:"; picture

    o = CreateObject("roAssociativeArray")
    o.HDPosterUrl = picture
    o.SDPosterUrl = picture
    'o.Title = song.shortdescriptionline1
    o.Title  = song.Title
    o.Description = song.Description
    o.contenttype = "episode"

    scr = create_springboard(Audio.port, prevLoc)
    scr.ReloadButtons(2) 'set buttons for state "playing"
    scr.screen.SetTitle("Screen Title")

    'SaveCoverArtForScreenSaver(o.SDPosterUrl,o.HDPosterUrl)
    scr.screen.SetContent(o)

    scr.Show()

    ' start playing

    Audio.setupSong(song.StreamUrls[0], song.streamformat)
    Audio.audioplayer.setNext(0)
    Audio.setPlayState(2)               ' start playing

    while true
        msg = Audio.getMsgEvents(20000, "roSpringboardScreenEvent")

        if type(msg) = "roAudioPlayerEvent"  then       ' event from audio player
            if msg.isStatusMessage() then
                message = msg.getMessage()
                print "AudioPlayer Status Event - " message
                if message = "end of playlist"
                    print "end of playlist (obsolete status msg event)"
                        ' ignore
                else if message = "end of stream"
                    print "done playing this song (obsolete status msg event)"
                    audio.setPlayState(0)      ' stop the player, wait for user input
                    scr.ReloadButtons(0)    ' set button to allow play start
                endif
            else if msg.isListItemSelected() then
                print "starting song:"; msg.GetIndex()
                else if msg.isRequestSucceeded()
                print "ending song:"; msg.GetIndex()
                audio.setPlayState(0)   ' stop the player, wait for user input
                scr.ReloadButtons(0)    ' set button to allow play start
            else if msg.isRequestFailed()
                print "failed to play song:"; msg.GetData()
            else if msg.isFullResult()
                print "FullResult: End of Playlist"
            else if msg.isPaused()
                print "Paused"
            else if msg.isResumed()
                print "Resumed"
            else
                print "ignored event type:"; msg.getType()
            endif
        else if type(msg) = "roSpringboardScreenEvent" then     ' event from user
            if msg.isScreenClosed()
                print "Show_Audio_Screen: screen close - return"
                Audio.setPlayState(0)
                return
            endif
            if msg.isRemoteKeyPressed() then
                button = msg.GetIndex()
                print "Remote Key button = "; button
            else if msg.isButtonPressed() then
                button = msg.GetIndex()
                print "button index="; button
                if button = 1 'pause or resume
                    if Audio.isPlayState < 2    ' stopped or paused?
                        if (Audio.isPlayState = 0)
                              Audio.audioplayer.setNext(0)
                        endif
                        newstate = 2  ' now playing
                    else 'started
                         newstate = 1 ' now paused
                    endif
                else if button = 2 ' stop
                    newstate = 0 ' now stopped
                endif
                audio.setPlayState(newstate)
                scr.ReloadButtons(newstate)
                scr.Show()
            endif
        endif
   ' SetMainAppIsRunning()
   ' RunScreenSaver()
    end while
End Sub

'**********************************************************
'**  Audio Player Example Application - Audio Playback
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'**********************************************************

' playstate
' 0 = stopped
' 1 = paused
' 2 = playing

REM ******************************************************
REM
REM AudioPlayer object init
REM
REM ******************************************************
Function AudioInit() As Object
	o = CreateObject("roAssociativeArray")
	
	o.isPlayState			= 0   ' Stopped
	o.setPlayState			= audioPlayer_newstate
	o.setupSong			= audioPlayer_setup
	o.clearContent			= audioPlayer_clear_content
	o.setContentList		= audioPlayer_set_content_list
	o.getMsgEvents			= audioPlayer_getmsg
	
	audioPlayer			= CreateObject("roAudioPlayer")
	o.port 				= CreateObject("roMessagePort") 'Message will be coming out when a track is done
	audioPlayer.SetMessagePort(o.port)
	o.audioPlayer			= audioPlayer

	audioPlayer.SetLoop(0)
	
	return o
End Function

REM ******************************************************
REM
REM Setup song
REM
REM ******************************************************
Sub audioPlayer_setup(song As string, format as string)
	m.setPlayState(0)
	item = CreateObject("roAssociativeArray")
	item.Url = song
	item.StreamFormat = format
	m.audioPlayer.AddContent(item)
End Sub

REM ******************************************************
REM
REM Play audio
REM
REM ******************************************************
Sub audioPlayer_newstate(newstate as integer)
	if newstate = m.isplaystate return	' already there

	if newstate = 0 then			' STOPPED
		m.audioPlayer.Stop()
		m.isPlayState = 0
	else if newstate = 1 then		' PAUSED
		m.audioPlayer.Pause()
		m.isPlayState = 1
	else if newstate = 2 then		' PLAYING
		if m.isplaystate = 0
			m.audioPlayer.play()	' STOP->START
		else
			m.audioPlayer.Resume()	' PAUSE->START
		endif
		m.isPlayState = 2
	endif
End Sub

Sub audioPlayer_clear_content()
	m.audioPlayer.ClearContent()
End Sub

Sub audioPlayer_set_content_list(contentList As Object) 
	m.audioPlayer.SetContentList(contentList)
End Sub

Function audioPlayer_getmsg(timeout as Integer, escape as String) As Object
	'print "In audioPlayer get selection - Waiting for msg escape=" ; escape
	while true
	    msg = wait(timeout, m.port)
	    'print "Got msg = "; type(msg)
	    if type(msg) = "roAudioPlayerEvent" return msg
	    if type(msg) = escape return msg
	    if type(msg) = "Invalid" return msg
	    ' eat all other messages
	end while
End Function
