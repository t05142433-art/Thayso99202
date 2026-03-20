sub init()
    m.hostInput = m.top.findNode("hostInput")
    m.userInput = m.top.findNode("userInput")
    m.passInput = m.top.findNode("passInput")
    m.btnContinueBg = m.top.findNode("btnContinueBg")
    m.btnCancelBg = m.top.findNode("btnCancelBg")
    m.errorLabel = m.top.findNode("errorLabel")
    
    m.hostBg = m.top.findNode("hostBg")
    m.userBg = m.top.findNode("userBg")
    m.passBg = m.top.findNode("passBg")
    
    m.btnContinueText = m.top.findNode("btnContinueText")
    m.btnCancelText = m.top.findNode("btnCancelText")

    m.loginContainer = m.top.findNode("loginContainer")

    ' Inicializa o foco
    m.focusIndex = 0 ' 0: Host, 1: User, 2: Pass, 3: Continue, 4: Cancel
    
    m.top.setFocus(true)
    updateFocus()
end sub

sub updateFocus()
    ' Cores Neon
    neonColor = "0xFF00FFFF"
    idleColor = "0x202020FF"
    btnActive = "0x00FFFF99"
    btnIdle = "0x333333FF"

    ' Reseta estilos
    m.hostBg.color = idleColor
    m.userBg.color = idleColor
    m.passBg.color = idleColor
    m.btnContinueBg.color = btnIdle
    m.btnCancelBg.color = btnIdle
    
    m.btnContinueText.color = "0x888888FF"
    m.btnCancelText.color = "0x888888FF"

    ' Aplica foco visual
    if m.focusIndex = 0
        m.hostBg.color = neonColor
    else if m.focusIndex = 1
        m.userBg.color = neonColor
    else if m.focusIndex = 2
        m.passBg.color = neonColor
    else if m.focusIndex = 3
        m.btnContinueBg.color = btnActive
        m.btnContinueText.color = "0xFFFFFFFF"
    else if m.focusIndex = 4
        m.btnCancelBg.color = "0xFF00FF99"
        m.btnCancelText.color = "0xFFFFFFFF"
    end if
end sub

sub validateLogin()
    host = m.hostInput.text
    user = m.userInput.text
    pass = m.passInput.text
    
    if host = "" or user = "" or pass = ""
        m.errorLabel.text = "ERRO: PREENCHA TODOS OS CAMPOS!"
        return
    end if
    
    m.errorLabel.text = "CONECTANDO AO SERVIDOR..."
    ' Simulação de login
    m.top.loginSuccess = true
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press
        if key = "down"
            if m.focusIndex < 3
                m.focusIndex = m.focusIndex + 1
            else if m.focusIndex = 3
                m.focusIndex = 4
            end if
            updateFocus()
            return true
        else if key = "up"
            if m.focusIndex > 0
                if m.focusIndex = 4
                    m.focusIndex = 3
                else
                    m.focusIndex = m.focusIndex - 1
                end if
            end if
            updateFocus()
            return true
        else if key = "right"
            if m.focusIndex = 3
                m.focusIndex = 4
                updateFocus()
                return true
            end if
        else if key = "left"
            if m.focusIndex = 4
                m.focusIndex = 3
                updateFocus()
                return true
            end if
        else if key = "OK"
            if m.focusIndex = 0
                m.hostInput.active = true
                return true
            else if m.focusIndex = 1
                m.userInput.active = true
                return true
            else if m.focusIndex = 2
                m.passInput.active = true
                return true
            else if m.focusIndex = 3
                validateLogin()
                return true
            else if m.focusIndex = 4
                ' Sair
                return true
            end if
        end if
    end if
    return false
end function
