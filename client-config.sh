#!/bin/bash
#
# Скрипт разработан для систем Ubuntu
#
# Чтобы сделать файл исполняемым нужно выполнить команду: chmod +x ./имя_скрипта#
# Скрипт следует выполнять на клиенте, с правами суперпользователя: 
# sudo ./kotlin-config.sh
#
## Настройка подключения

echo "Сейчас будет сгенерирован ключ ssh, все пути оставь по умолчанию"
echo "Нажми любую клавишу, если понял"
read -n 1 -s -r -p "" 

ssh-keygen

echo "Введи порт для подключения к серверу: "
read port

echo "Введи имя пользователя сервера, под которым будешь подключаться: "
read user

echo "Введи ip адрес сервера: "
read server

echo "Копируем ключ на сервер $server:$port для пользователя $user"
ssh-copy-id -p $port $user@$server

echo "Настраиваем alias"
echo "Введи желаемый псевдоним сервера, под которым будешь подключаться: "
read name

echo "" >> ~/.ssh/config
echo "Host $name" >> ~/.ssh/config
echo "  HostName $server" >> ~/.ssh/config
echo "  Port $port" >> ~/.ssh/config
echo "  User $user" >> ~/.ssh/config
echo "  PasswordAuthentication no" >> ~/.ssh/config
echo "  IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config

exit 0
