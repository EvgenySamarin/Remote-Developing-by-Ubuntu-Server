
#!/bin/bash
#
# Скрипт разработан для систем Ubuntu
#
# Чтобы сделать файл исполняемым нужно выполнить команду: chmod +x ./имя_скрипта
# Скрипт следует выполнять на сервере, с правами суперпользователя: 
# sudo ./gradle-config.sh
#
## Установка gradle
sdk install gradle

# Создаём swapfile для ускорения сборки
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Указываем gradle использовать фоновый процесс сборки приложений
mkdir ~/.gradle
echo 'org.gradle.daemon=true' >> ~/.gradle/gradle.properties

exit 0
