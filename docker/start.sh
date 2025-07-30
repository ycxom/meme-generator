#! /usr/bin/env bash

CONFIG_DIR=~/.config/meme_generator
CONFIG_FILE=$CONFIG_DIR/config.toml

mkdir -p "$CONFIG_DIR"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found. Creating a new one from template..."
    envsubst < /app/config.toml.template > "$CONFIG_FILE"
fi

exec python -m meme_generator.app