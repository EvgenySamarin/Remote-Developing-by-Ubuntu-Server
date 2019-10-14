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

# Устанавливаем kotlin
sdk install kotlin

## Устанавливаем android
cd ~; wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz

# распаковываем архив
tar xf android-sdk*-linux.tgz

# удаляем более не нужный архив
rm android-sdk_r24.4.1-linux.tgz

# запускаем обновление компонентов, с параллельной установкой актуального sdk:
cd android-sdk-linux/tools; ./android update sdk --all --no-ui --filter $(seq -s, 29)

# прописываем необходимые переменне окружения
echo 'export ANDROID_HOME=$HOME/android-sdk-linux' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools' >> ~/.bashrc

source ~/.bashrc

# Добавляем в систему возможность исполнять i386 файлы
dpkg --add-architecture i386
apt-get update
apt-get install -y libc6:i386 libstdc++6:i386 zlib1g:i386


