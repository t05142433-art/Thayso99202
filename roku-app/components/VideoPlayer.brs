sub init()
    m.video = m.top.findNode("video")
    m.controls = m.top.findNode("controls")
    
    m.top.observeField("control", "onControlChange")
end sub

sub onControlChange()
    if m.top.control = "play"
        ' Mock stream
        content = createObject("roSGNode", "ContentNode")
        content.url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        content.streamFormat = "mp4"
        m.video.content = content
        m.video.control = "play"
    else if m.top.control = "stop"
        m.video.control = "stop"
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press
        if key = "OK"
            m.controls.visible = not m.controls.visible
            return true
        end if
    end if
    return false
end function
