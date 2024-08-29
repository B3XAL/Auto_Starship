#!/bin/bash

#nano ~/.config/starship.toml
# Script para instalar Starship y configurar el archivo starship.toml

# Variables
STARSHIP_BIN="/usr/local/bin/starship"
CONFIG_DIR="$HOME/.config"
CONFIG_FILE="$CONFIG_DIR/starship.toml"

# Verificar si el script se ejecuta con permisos de superusuario
if [ "$(id -u)" -ne "0" ]; then
    echo "Este script necesita permisos de superusuario. Ejecuta con sudo."
    exit 1
fi

# Descargar e instalar Starship
echo "Descargando e instalando Starship..."
curl -fsSL https://starship.rs/install.sh | bash

# Verificar si la instalación fue exitosa
if [ ! -x "$STARSHIP_BIN" ]; then
    echo "La instalación de Starship falló."
    exit 1
fi

# Crear el directorio de configuración si no existe
echo "Creando directorio de configuración..."
mkdir -p "$CONFIG_DIR"

# Crear y escribir la configuración en el archivo starship.toml
echo "Creando configuración de Starship en $CONFIG_FILE..."
cat <<EOL > "$CONFIG_FILE"
# ~/.config/starship.toml

# Añade una nueva línea después del prompt para mejorar la legibilidad
add_newline = true

format = """\
[👤 $username](fg:#7DF9AA)\
[$time](fg:#FFFFFF)\
[📁](fg:#1C3A5E)\
$directory\
$cmd_duration\
$character\
"""

[directory]
format = "[ $path ]($style)"
style = "fg:#E4E4E4"

[username]
style_user = "fg:#00FF00"
show_always = true

[git_branch]
format = '[ $symbol$branch(:$remote_branch) ]($style)'
symbol = "  "
style = "fg:#1C3A5E"

[git_status]
format = '[$all_status]($style)'
style = "fg:#1C3A5E"

[git_metrics]
format = "([+$added]($added_style))[]($added_style)"
added_style = "fg:#1C3A5E"
deleted_style = "fg:bright-red"
disabled = false

[hg_branch]
format = "[ $symbol$branch ]($style)"
symbol = " "

[cmd_duration]
format = "[  $duration ]($style)"
style = "fg:bright-white"

[character]
success_symbol = '[ ✓](bold green) '
error_symbol = '[ ✗](#E84D44) '

[time]
disabled = false
time_format = "%R" # Hour:Minute Format
style = "fg:#FFFFFF" # White color
format = '[[ $time ](fg:#FFFFFF)]($style)'
EOL

# Verificar si la configuración se creó correctamente
if [ -f "$CONFIG_FILE" ]; then
    echo "La configuración de Starship se creó correctamente en $CONFIG_FILE."
else
    echo "No se pudo crear el archivo de configuración de Starship."
    exit 1
fi

# Instrucciones adicionales para el usuario
echo "Para que Starship se ejecute, añade la siguiente línea a tu archivo de perfil (e.g., ~/.bashrc o ~/.bash_profile):"
echo 'eval "$(starship init bash)"'

echo "Instalación y configuración de Starship completadas."
