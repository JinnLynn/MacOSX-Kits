#!/usr/bin/env osascript

property scriptName : "TerminalGrowlNotify"
property isGrowlRunning : false
property defaultGrowlNotify : "Terminal Notify"

on run argv

    tell application "System Events"
        set isGrowlRunning to (count of (every process whose bundle identifier is "com.Growl.GrowlHelperApp")) > 0
    end tell

    script growl
        on growlNotify(_desc, _title)
            if isGrowlRunning = false then return
            tell application id "com.Growl.GrowlHelperApp"
                set the allNotificationsList to {scriptName}
                set the enabledNotificationsList to {scriptName}
                register as application scriptName all notifications allNotificationsList default notifications enabledNotificationsList icon of application "Terminal"
                notify with name scriptName title _title description _desc application name scriptName
            end tell
        end growlNotify
    end script

    set _argvCount to count of argv
    if _argvCount <= 0 then return

    set _desc to item 1 of argv
    set _title to defaultGrowlNotify
    if (_argvCount >= 2) then
        set _title to item 2 of argv
    end if

    tell growl to growlNotify(_desc, _title)

end run