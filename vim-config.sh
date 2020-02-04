#!/bin/bash
#
# Скрипт разработан для систем Ubuntu
#
# Для корректной работы скрипта необходимо также наличие скачанного файла .vimrc, он находится в той же диретории, что и скрипты
#
# Чтобы сделать файл исполняемым нужно выполнить команду: chmod +x ./имя_скрипта
# Скрипт следует выполнять на сервере, с правами суперпользователя: 
# sudo ./vim-config.sh
#
## Настраивам Vim и устанавливаем базовые плагины

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cat .vimrc >> ~/.vimrc

# Устанавливаем YCM и переходим в его диреторию
apt install build-essential cmake python3-dev
cd ~/.vim/plugged/YouCompleteMe

# Настраиваем компилятор Java
python3 install.py --java-completer

exit 0
