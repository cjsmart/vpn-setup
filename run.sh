#!/bin/bash
set -euo pipefail

# Функция для вывода usage
usage() {
  echo "Usage: $0 -u <username> -h <host>"
  echo "  -u  Имя пользователя для подключения к удалённой машине"
  echo "  -h  Адрес удалённой машины (IP или доменное имя)"
  exit 1
}

# Проверка количества аргументов
if [ $# -eq 0 ]; then
  usage
fi

# Парсинг аргументов командной строки
while getopts ":u:h:" opt; do
  case $opt in
    u) USERNAME="$OPTARG" ;;
    h) HOST="$OPTARG" ;;
    *) usage ;;
  esac
done

# Проверка, что оба параметра указаны
if [ -z "$USERNAME" ] || [ -z "$HOST" ]; then
  echo "Ошибка: Необходимо указать имя пользователя и адрес удалённой машины."
  usage
fi

# Выполнение Ansible-плейбуков
echo "Запуск bootstrap.yml с пользователем $USERNAME на хосте $HOST..."
ansible-playbook -i "$HOST," -u "$USERNAME" bootstrap.yml

if [ $? -eq 0 ]; then
  echo "bootstrap.yml выполнен успешно."
else
  echo "Ошибка при выполнении bootstrap.yml."
  exit 1
fi

echo "Запуск playbook.yml с пользователем $USERNAME на хосте $HOST..."
ansible-playbook -i "$HOST," playbook.yml

if [ $? -eq 0 ]; then
  echo "playbook.yml выполнен успешно."
else
  echo "Ошибка при выполнении playbook.yml."
  exit 1
fi

echo "Все плейбуки выполнены успешно."
exit 0