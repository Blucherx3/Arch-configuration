#!/usr/bin/env bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CARD="$(light -L | grep 'backlight' | head -n1 | cut -d'/' -f3)"
INTERFACE="$(ip link | awk '/state UP/ {print $2}' | tr -d :)"
BAT="$(acpi -b)"
RFILE="$DIR/.module"

# Исправить подсветку и сетевые модули
fix_modules() {
	if [[ -z "$CARD" ]]; then
		sed -i -e 's/backlight/bna/g' "$DIR"/config.ini
	elif [[ "$CARD" != *"intel_"* ]]; then
		sed -i -e 's/backlight/brightness/g' "$DIR"/config.ini
	fi

	if [[ -z "$BAT" ]]; then
		sed -i -e 's/battery/btna/g' "$DIR"/config.ini
	fi

	if [[ "$INTERFACE" == e* ]]; then
		sed -i -e 's/network/ethernet/g' "$DIR"/config.ini
	fi
}

# Запустить бар
launch_bar() {
	# Прекращение уже работает
	killall -q polybar

	# Подождите, пока процессы не будут закрыты
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	# Запустить бар
	for mon in $(polybar --list-monitors | cut -d":" -f1); do
		MONITOR=$mon polybar -q main -c "$DIR"/config.ini &
		MONITOR=$mon polybar -q support -c "$DIR"/config.ini &
	done
}

# Выполнить функции
if [[ ! -f "$RFILE" ]]; then
	fix_modules
	touch "$RFILE"
fi	
launch_bar
