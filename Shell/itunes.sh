#!/usr/bin/env osascript

on run argv

    set _errormsg to "ERROR. Usage: itunes.sh <lyric|rate> [ARGS]"
    
    set _argvCount to count of argv

    if _argvCount = 0 then return _errormsg

    set _command to item 1 of argv

    tell application "iTunes"
        set _isplaying to ((player state is playing) and (exists current track))
        
        if _command = "lyric" then
            reveal current track
            do shell script "osascript $KITS/FetchLyric/FetchLyric.applescript"
            set _cur_title to (get name of current track)
            set _cur_artist to (get artist of current track)
            return "The lyric of '" & _cur_title & " by " & _cur_artist & "' will be fetched."
        else if _command = "rate" then
            if _argvCount < 2 then return "Error. missing arguments."
            if _isplaying = false then return "Error. iTunes is not playing."
            set _rate to item 2 of argv
            if (_rate < 0) or (_rate > 5) then return "Error. rate must between 0 and 5."
            set rating of current track to _rate * 20
            set _cur_title to (get name of current track)
            set _cur_artist to (get artist of current track)
            return "The rating of '" & _cur_title & " by " & _cur_title & "' is " & _rate & " now."
        else
            return _errormsg
        end if
    end tell

end run