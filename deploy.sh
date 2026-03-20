#!/bin/bash

# Script de Compilação e Deploy para Roku (Termux Ready)
# Thayson & Thayla IPTV

# Configurações da TV
ROKU_IP="192.168.1.100" # Mude para o IP da sua TV
USER="rokudev"
PASS="1234" # Mude para sua senha de desenvolvedor

echo "--- Iniciando Deploy para Roku ---"

# Limpar build anterior
rm -rf build_roku
rm -f app.zip

# Criar estrutura de build
mkdir build_roku
cp -r roku-app/* build_roku/

# Empacotar
echo "Zippando arquivos..."
cd build_roku
zip -r ../app.zip .
cd ..

# Instalar na Roku via cURL (Digest Auth)
echo "Instalando na TV em $ROKU_IP..."
curl --user "$USER:$PASS" --digest \
     -F "archive=@app.zip" \
     -F "mysubmit=Install" \
     http://$ROKU_IP/plugin_install

echo ""
echo "--- Processo Concluído ---"
echo "Se o cURL retornou sucesso, o app já deve estar abrindo na sua TV!"
