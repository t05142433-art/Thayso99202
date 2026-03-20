#!/bin/bash

# Configurações da sua TV Roku
ROKU_IP=192.168.1.4
PASS=1234

echo "--- Iniciando Deploy para Roku ---"

# Limpa build anterior
rm -f app.zip

# Zippando arquivos
echo "Zippando arquivos..."
cd roku-app
zip -r ../app.zip .
cd ..

# Instalando na TV
echo "Instalando na TV em $ROKU_IP..."
curl --user "rokudev:$PASS" --digest -F "archive=@app.zip" -F "mysubmit=Install" http://$ROKU_IP/plugin_install

echo ""
echo "--- Deploy Concluído! ---"
