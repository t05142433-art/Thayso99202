sub init()
    m.logoAnim = m.top.findNode("logoAnim")
    m.splashTimer = m.top.findNode("splashTimer")
    m.logoGroup = m.top.findNode("logoGroup")
    
    ' Centraliza o grupo para escala
    m.logoGroup.scaleRotateCenter = [0, 0]
    
    m.logoAnim.control = "start"
    m.splashTimer.control = "start"
    m.splashTimer.observeField("fire", "onTimerFire")
end sub

sub onTimerFire()
    m.top.finished = true
end sub
