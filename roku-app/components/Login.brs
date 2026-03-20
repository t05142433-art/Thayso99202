sub init()
    m.codeLabel = m.top.findNode("codeLabel")
    m.urlLabel = m.top.findNode("urlLabel")
    m.statusLabel = m.top.findNode("statusLabel")
    m.loadingProgress = m.top.findNode("loadingProgress")
    m.pollTimer = m.top.findNode("pollTimer")
    m.animTimer = m.top.findNode("animTimer")
    
    m.pairingCode = ""
    m.progressWidth = 0
    
    ' Iniciar animação da barra
    m.animTimer.control = "start"
    m.animTimer.observeField("fire", "onAnimTick")
    
    ' Gerar código inicial via Task
    m.generateTask = createObject("roSGNode", "NetworkTask")
    m.generateTask.requestType = "generateCode"
    m.generateTask.observeField("response", "onGenerateResponse")
    m.generateTask.control = "run"
end sub

sub onGenerateResponse()
    if m.generateTask.response <> invalid
        m.pairingCode = m.generateTask.response.code
        m.codeLabel.text = m.pairingCode
        
        ' Iniciar polling
        m.pollTimer.control = "start"
        m.pollTimer.observeField("fire", "onPollTick")
    end if
end sub

sub onPollTick()
    if m.pairingCode <> ""
        m.pollTask = createObject("roSGNode", "NetworkTask")
        m.pollTask.requestType = "pollStatus"
        m.pollTask.params = { code: m.pairingCode }
        m.pollTask.observeField("response", "onPollResponse")
        m.pollTask.control = "run"
    end if
end sub

sub onPollResponse()
    if m.pollTask.response <> invalid
        if m.pollTask.response.status = "completed"
            ' Login bem sucedido!
            m.top.credentials = m.pollTask.response.credentials
            m.top.loginSuccess = true
        end if
    end if
end sub

sub onAnimTick()
    m.progressWidth = (m.progressWidth + 10) MOD 400
    m.loadingProgress.width = m.progressWidth
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press
        if key = "back"
            return true
        end if
    end if
    return false
end function
