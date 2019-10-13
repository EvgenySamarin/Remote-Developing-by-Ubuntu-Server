#!/bin/bash
# Тестовый скрипт для проверки работы с файлами

cat testfile | while read line; do
  IFS=$' '
  change_param=0
  for word in $line; do
      if [ $word = "line_7" ]; then
        change_param=1
        echo "Мы нашли $word"
      elif [ $change_param = 1 ]; then
        echo "Меняем параметр $word на no"
        break
      fi
  done
  if [ $change_param = 1 ]; then
    break
  fi
done
