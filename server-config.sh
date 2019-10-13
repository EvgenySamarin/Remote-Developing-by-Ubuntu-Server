#!/bin/bash
#
# Скрипт разработан для систем Ubuntu
# Чтобы сделать файл исполняемым нужно выполнить команду: chmod +x ./имя_скрипта
# Скрипт следует выполнять на сервере, с правами суперпользователя: 
# sudo ./server-config.sh
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

# Изменение файла настроек sshd_config
# Запрещамем авторизацию под root
line_number=$(awk '/PermitRootLogin/{ print NR; exit }' /etc/ssh/sshd_config)
sed -i $line_number's/.*/PermitRootLogin no/' /etc/ssh/sshd_config 

# Меняем стандартный порт на нестандартный
echo ""
echo -n "Enter a new ssh port number by [49152-65535] range: "
read port_number
line_number=$(awk '/Port 22/{ print NR; exit }' /etc/ssh/sshd_config)
sed -i $line_number's/.*/Port '$port_number'/' /etc/ssh/sshd_config 

service ssh restart

# устанавливаем git
apt install git

# устанавливаем архиватор
apt install zip
apt install unzip

# устанавливаем JVM
apt-get install default-jdk

# устанавливаем переменные окружения

