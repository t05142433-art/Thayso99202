sub init()
    m.hostInput = m.top.findNode("hostInput")
    m.userInput = m.top.findNode("userInput")
    m.passInput = m.top.findNode("passInput")
    m.buttons = m.top.findNode("buttons")
    m.errorLabel = m.top.findNode("errorLabel")
    
    m.buttons.observeField("buttonSelected", "onButtonSelected")
    m.buttons.setFocus(true)
end sub

sub onButtonSelected()
    idx = m.buttons.buttonSelected
    if idx = 0
        validateLogin()
    else
        ' Cancelar ou Limpar
    end if
end sub

sub validateLogin()
    host = m.hostInput.text
    user = m.userInput.text
    pass = m.passInput.text
    
    if host = "" or user = "" or pass = ""
        m.errorLabel.text = "Preencha todos os campos"
        return
    end if
    
    ' Simulação de login (Em app real usaria roUrlTransfer)
    ' Aqui apenas notificamos sucesso para prosseguir com a demo da UI
    m.top.loginSuccess = true
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press
        if key = "down"
            if m.hostInput.hasFocus()
                m.userInput.setFocus(true)
            else if m.userInput.hasFocus()
                m.passInput.setFocus(true)
            else if m.passInput.hasFocus()
                m.buttons.setFocus(true)
            end if
            return true
        else if key = "up"
            if m.buttons.hasFocus()
                m.passInput.setFocus(true)
            else if m.passInput.hasFocus()
                m.userInput.setFocus(true)
            else if m.userInput.hasFocus()
                m.hostInput.setFocus(true)
            end if
            return true
        end if
    end if
    return false
end function
