sub init()
    m.settingsList = m.top.findNode("settingsList")
    
    m.items = ["Conectar via Código", "Idioma", "Tema: Azul + Rosa", "Limpar Cache", "Sair"]
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
    idx = m.settingsList.itemSelected
    if idx = 0
        ' Abrir tela de pareamento
    end if
end sub
