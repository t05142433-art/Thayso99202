sub init()
    m.menuList = m.top.findNode("menuList")
    m.contentGrid = m.top.findNode("contentGrid")
    m.titleLabel = m.top.findNode("titleLabel")
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.contentArea = m.top.findNode("contentArea")
    
    m.menuItems = ["Canais", "Filmes", "Séries", "Continuar", "Configurações"]
    m.menuList.content = createMenuContent()
    
    m.menuList.observeField("itemFocused", "onMenuItemFocused")
    m.menuList.observeField("itemSelected", "onMenuItemSelected")
    
    m.contentGrid.observeField("itemSelected", "onContentSelected")
    
    m.menuList.setFocus(true)
    
    ' Carregar dados iniciais
    loadChannels()
end sub

function createMenuContent() as Object
    content = createObject("roSGNode", "ContentNode")
    for each item in m.menuItems
        node = content.createChild("ContentNode")
        node.title = item
    end for
    return content
end function

sub onMenuItemFocused()
    idx = m.menuList.itemFocused
    m.titleLabel.text = m.menuItems[idx]
    
    if idx = 0
        loadChannels()
    else if idx = 1
        loadMovies()
    else if idx = 2
        loadSeries()
    else if idx = 4
        showSettings()
    end if
end sub

sub showSettings()
    m.contentGrid.visible = false
    m.settings = createObject("roSGNode", "Settings")
    m.contentArea.appendChild(m.settings)
    m.settings.observeField("itemSelected", "onSettingsItemSelected")
end sub

sub onSettingsItemSelected()
    idx = m.settings.itemSelected
    if idx = 0
        showPairing()
    end if
end sub

sub showPairing()
    m.pairing = createObject("roSGNode", "Pairing")
    m.top.appendChild(m.pairing)
    m.pairing.setFocus(true)
end sub

sub onMenuItemSelected()
    m.contentGrid.setFocus(true)
end sub

sub onContentSelected()
    ' Ao selecionar um canal ou filme, abrir o player
    m.videoPlayer.visible = true
    m.videoPlayer.setFocus(true)
    m.videoPlayer.control = "play"
end sub

sub loadChannels()
    ' Mock de canais
    content = createObject("roSGNode", "ContentNode")
    for i = 1 to 20
        node = content.createChild("ContentNode")
        node.hdPosterUrl = "https://picsum.photos/seed/channel" + i.toStr() + "/240/360"
        node.title = "Canal " + i.toStr()
    end for
    m.contentGrid.content = content
end sub

sub loadMovies()
    content = createObject("roSGNode", "ContentNode")
    for i = 1 to 20
        node = content.createChild("ContentNode")
        node.hdPosterUrl = "https://picsum.photos/seed/movie" + i.toStr() + "/240/360"
        node.title = "Filme " + i.toStr()
    end for
    m.contentGrid.content = content
end sub

sub loadSeries()
    content = createObject("roSGNode", "ContentNode")
    for i = 1 to 20
        node = content.createChild("ContentNode")
        node.hdPosterUrl = "https://picsum.photos/seed/series" + i.toStr() + "/240/360"
        node.title = "Série " + i.toStr()
    end for
    m.contentGrid.content = content
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press
        if key = "left"
            if m.contentGrid.hasFocus()
                m.menuList.setFocus(true)
                return true
            end if
        else if key = "back"
            if m.videoPlayer.visible
                m.videoPlayer.control = "stop"
                m.videoPlayer.visible = false
                m.contentGrid.setFocus(true)
                return true
            end if
        end if
    end if
    return false
end function
