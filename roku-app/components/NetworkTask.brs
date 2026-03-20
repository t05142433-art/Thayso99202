sub init()
    m.top.functionName = "execute"
end sub

sub execute()
    if m.top.requestType = "generateCode"
        generateCode()
    else if m.top.requestType = "pollStatus"
        pollStatus()
    end if
end sub

sub generateCode()
    url = "https://ais-dev-4exy655xatecjqmeowfa4c-131905852071.us-east5.run.app/api/pair/generate"
    request = createObject("roUrlTransfer")
    request.setUrl(url)
    request.setCertificatesFile("common:/certs/ca-bundle.crt")
    request.initClientCertificates()
    
    response = request.getToString()
    if response <> ""
        m.top.response = parseJson(response)
    end if
end sub

sub pollStatus()
    code = m.top.params.code
    url = "https://ais-dev-4exy655xatecjqmeowfa4c-131905852071.us-east5.run.app/api/pair/status/" + code
    request = createObject("roUrlTransfer")
    request.setUrl(url)
    request.setCertificatesFile("common:/certs/ca-bundle.crt")
    request.initClientCertificates()
    
    response = request.getToString()
    if response <> ""
        m.top.response = parseJson(response)
    end if
end sub
