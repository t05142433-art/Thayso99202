sub init()
    m.contentGroup = m.top.findNode("contentGroup")
    m.splash = m.top.findNode("splash")
    
    ' Iniciar Splash
    m.splash.observeField("finished", "onSplashFinished")
end sub

sub onSplashFinished()
    m.top.removeChild(m.splash)
    
    ' Verificar se já existe login salvo no Registry
    sec = createObject("roRegistrySection", "Authentication")
    if sec.exists("credentials")
        creds = parseJson(sec.read("credentials"))
        if creds <> invalid
            m.global.addFields({auth: creds})
            showHome()
            return
        end if
    end if
    
    showLogin()
end sub

sub showLogin()
    m.login = createObject("roSGNode", "Login")
    m.contentGroup.appendChild(m.login)
    m.login.setFocus(true)
    m.login.observeField("loginSuccess", "onLoginSuccess")
end sub

sub onLoginSuccess()
    ' Salvar no Registry
    sec = createObject("roRegistrySection", "Authentication")
    sec.write("credentials", formatJson(m.login.credentials))
    sec.flush()
    
    m.global.addFields({auth: m.login.credentials})
    
    m.contentGroup.removeChild(m.login)
    showHome()
end sub

sub showHome()
    m.home = createObject("roSGNode", "Home")
    m.contentGroup.appendChild(m.home)
    m.home.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press
        if key = "back"
            ' Lógica de voltar
            handled = true
        end if
    end if
    return handled
end function
