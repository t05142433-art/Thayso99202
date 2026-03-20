sub init()
    m.video = m.top.findNode("video")
    m.controls = m.top.findNode("controls")
    m.progressBar = m.top.findNode("progressBar")
    m.timeLabel = m.top.findNode("timeLabel")
    
    m.top.observeField("control", "onControlChange")
    m.video.observeField("position", "onPositionChange")
    m.video.observeField("duration", "onDurationChange")
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

sub onPositionChange()
    if m.video.duration > 0
        progress = (m.video.position / m.video.duration) * 1720
        m.progressBar.width = progress
        
        posStr = formatTime(m.video.position)
        durStr = formatTime(m.video.duration)
        m.timeLabel.text = posStr + " / " + durStr
    end if
end sub

sub onDurationChange()
    ' Atualiza duração total
end sub

function formatTime(seconds as Integer) as String
    hours = Int(seconds / 3600)
    minutes = Int((seconds MOD 3600) / 60)
    secs = seconds MOD 60
    
    if hours > 0
        return hours.toStr() + ":" + minutes.toStr().padLeft(2, "0") + ":" + secs.toStr().padLeft(2, "0")
    else
        return minutes.toStr().padLeft(2, "0") + ":" + secs.toStr().padLeft(2, "0")
    end if
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press
        if key = "OK"
            m.controls.visible = not m.controls.visible
            return true
        else if key = "play" or key = "pause"
            if m.video.state = "playing"
                m.video.control = "pause"
            else
                m.video.control = "resume"
            end if
            return true
        end if
    end if
    return false
end function
