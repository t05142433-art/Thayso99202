sub init()
    m.codeLabel = m.top.findNode("codeLabel")
    m.urlLabel = m.top.findNode("urlLabel")
    m.checkTimer = m.top.findNode("checkTimer")
    
    generateCode()
end sub

sub generateCode()
    ' Em app real, faria requisição ao servidor Node
    ' Aqui simulamos um código
    m.code = "123456"
    m.codeLabel.text = m.code
    m.checkTimer.control = "start"
    m.checkTimer.observeField("fire", "checkStatus")
end sub

sub checkStatus()
    ' Consultar /api/pair/status/123456
    ' Se status = connected, salvar playlist e voltar
end sub
