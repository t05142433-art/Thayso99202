sub init()
    m.logoLabel = m.top.findNode("logoLabel")
    m.logoAnim = m.top.findNode("logoAnim")
    m.splashTimer = m.top.findNode("splashTimer")
    
    m.logoAnim.control = "start"
    m.splashTimer.control = "start"
    m.splashTimer.observeField("fire", "onTimerFire")
end sub

sub onTimerFire()
    m.top.finished = true
end sub
