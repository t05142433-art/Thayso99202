sub init()
    m.settingsList = m.top.findNode("settingsList")
    
    m.items = ["CONECTAR VIA CÓDIGO", "IDIOMA", "TEMA: NEON PINK", "LIMPAR CACHE", "SAIR"]
    m.settingsList.content = createSettingsContent()
    
    m.settingsList.observeField("itemSelected", "onItemSelected")
    m.settingsList.setFocus(true)
end sub

function createSettingsContent() as Object
    content = createObject("roSGNode", "ContentNode")
    for each item in m.items
        node = content.createChild("ContentNode")
        node.title = item
    end for
    return content
end function

sub onItemSelected()
    m.top.itemSelected = m.settingsList.itemSelected
end sub
