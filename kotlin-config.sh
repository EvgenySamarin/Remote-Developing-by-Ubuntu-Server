#!/bin/bash
#
# Скрипт разработан для систем Ubuntu
#
# Чтобы сделать файл исполняемым нужно выполнить команду: chmod +x ./имя_скрипта
# Скрипт следует выполнять на сервере, с правами суперпользователя: 
# sudo ./kotlin-config.sh
#
## Установка kotlin

# Устанавливаем менеджер sdk пакетов
wget -O sdk.install.sh "https://get.sdkman.io"

bash sdk.install.sh

source ~/.sdkman/bin/sdkman-init.sh

sdk install kotlin
