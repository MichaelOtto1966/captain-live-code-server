#!/bin/sh

# Das Verzeichnis, das von CapRover persistent gemacht wird
PERSISTENT_DIR="/home/coder/$CAPTAIN_APP_NAME"
TEMP_SOURCE_DIR="/tmp/app_source"

echo "Erstelle persistentes Verzeichnis für $CAPTAIN_APP_NAME..."
mkdir -p "$PERSISTENT_DIR"

echo "Kopiere Anwendungsdateien in das persistente Verzeichnis..."
cp -r "$TEMP_SOURCE_DIR/." "$PERSISTENT_DIR"

echo "Starte Code-Server..."
code-server \
  --bind-addr 0.0.0.0:8080 \
  --auth none \
  --disable-telemetry \
  "$PERSISTENT_DIR"
