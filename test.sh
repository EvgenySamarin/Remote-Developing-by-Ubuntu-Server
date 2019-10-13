#!/bin/bash
# Тестовый скрипт для проверки работы с файлами
echo -n "Введи новый порт в диапазоне [1-143]: "
read port

var=$(awk '/Port/{ print NR; exit }' testfile)

sed -i $var's/.*/Port '$port'/' testfile

echo "Новый файл:"
cat testfile | grep Port
