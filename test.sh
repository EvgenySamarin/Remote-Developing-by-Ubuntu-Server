#!/bin/bash
# Тестовый скрипт для проверки работы с файлами
echo -n "Введи новый порт в диапазоне [1-143]: "
read port

var=$(awk '/Port/{ print NR; exit }' testfile)

sed -i $var's/.*/Port '$port'/' testfile

echo "Новый файл:"
cat testfile | grep Port

echo "export JAVA_HOME=\$JAVA_HOME:/usr/lib/jvm/default-java/" >> testfile
echo "export PATH=/usr/lib/jvm/default-java/bin:\$PATH" >> testfile
