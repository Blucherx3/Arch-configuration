#!/bin/bash

# Директория с обоями
wallpapers_dir="$HOME/Pictures/wallpapers"

# Получаем текущие обои для каждого монитора
current_wallpaper_0=$(grep -m1 '^file=' ~/.config/nitrogen/bg-saved.cfg | cut -d'=' -f2)
current_wallpaper_1=$(grep -m2 '^file=' ~/.config/nitrogen/bg-saved.cfg | tail -n1 | cut -d'=' -f2)

# Функция для выбора новых обоев
select_new_wallpaper() {
  # Получаем список всех обоев, исключая текущие
  available_wallpapers=$(ls "$wallpapers_dir" | grep .png | grep -v -e "^$(basename "$current_wallpaper_0")$" -e "^$(basename "$current_wallpaper_1")$")

  # Выбираем случайные обои из доступных
  new_wallpaper=$(printf "%s\n" "$available_wallpapers" | shuf -n1)

  # Если доступных обоев нет, используем все обои
  if [ -z "$new_wallpaper" ]; then
    new_wallpaper=$(ls "$wallpapers_dir" | grep .png | shuf -n1)
  fi

  echo "$wallpapers_dir/$new_wallpaper"
}

# Выбираем новые обои
new_wallpaper=$(select_new_wallpaper)

# Устанавливаем новые обои для каждого монитора
nitrogen --head=0 --save --set-zoom-fill "$new_wallpaper"
if ![ $? -eq 0 ]; then
  nitrogen --head=0 --save --set-zoom-fill "$new_wallpaper"
fi
nitrogen --head=1 --save --set-zoom-fill "$new_wallpaper"
if ![ $? -eq 0 ]; then
  nitrogen --head=1 --save --set-zoom-fill "$new_wallpaper"
fi