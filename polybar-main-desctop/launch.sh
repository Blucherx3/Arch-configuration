#!/usr/bin/env bash

DIR="$HOME/.config/polybar"
CARD="$(light -L | grep 'backlight' | head -n1 | cut -d'/' -f3)"
INTERFACE="$(ip link | awk '/state UP/ {print $2}' | tr -d :)"

	# Прекращение уже работает
pkill polybar

	# Подождите, пока процессы не будут закрыты
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	# Запустить бар

polybar -q main -c "$DIR"/config.ini &
polybar -q support -c "$DIR"/config.ini &



