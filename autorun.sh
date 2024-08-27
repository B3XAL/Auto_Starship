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

# Configura la apariencia del usuario y el host
[username]
style_user = "bold green"
show_always = true

# Configura el directorio actual
[directory]
truncation_length = 7  # Muestra solo los últimos 3 directorios
truncation_symbol = "…/"

# Configura la rama de Git
[git_branch]
symbol = "🌿 "  # Utiliza un icono de rama
style = "bold yellow"

# Configura el estado de Git
[git_status]
disabled = false  # Activa el estado de Git
style = "bold red"

# Configura el tiempo de ejecución del comando
[time]
format = "[$duration] "
style = "bold cyan"

# Configura el prompt de comandos
[character]
success_symbol = "[➜ ](bold green) "
error_symbol = "[✖ ](bold red) "
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
