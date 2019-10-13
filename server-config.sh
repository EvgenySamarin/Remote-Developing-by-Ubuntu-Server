#!/bin/bash
#
# Скрипт разработан для систем Ubuntu
# Чтобы сделать файл исполняемым нужно выполнить команду: chmod +x ./имя_скрипта
# Скрипт следует выполнять с правами суперпользователя: sudo ./server-config.sh
#
## первичная конфигурация сервера

# Обновление репозитория
apt-get update && apt-get upgrade

# Создание нового пользователя и выдача ему прав суперпользователя
echo ""
echo -n "Enter new username: "
read username

echo "Add user $username"
adduser $username

echo "add $username to sudo group"
gpasswd -a $username sudo

#Изменение файла настроек sshd_config
cat /etc/ssh/ssh_config 




