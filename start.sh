#!/bin/sh

# Das Verzeichnis, das von CapRover persistent gemacht wird.
PERSISTENT_DIR="/home/coder/persistent-data"

# Erstellen Sie ein temporäres, eindeutiges Verzeichnis für diese App-Instanz.
# CapRover garantiert die Eindeutigkeit des persistenten Volumes, auf das
# dieses temporäre Verzeichnis gemountet wird.
APP_DIR="/home/coder/app-instance-$CAPTAIN_APP_NAME"
TEMP_SOURCE_DIR="/app_temp"

echo "Erstelle temporäres Verzeichnis für $CAPTAIN_APP_NAME..."
mkdir -p "$APP_DIR"

echo "Kopiere Anwendungsdateien in das temporäre Verzeichnis..."
# Die -n Option verhindert, dass das Kopieren fehlschlägt, falls das Verzeichnis bereits existiert.
cp -rn "$TEMP_SOURCE_DIR/." "$APP_DIR"

echo "Starte Code-Server..."
code-server \
  --bind-addr 0.0.0.0:8080 \
  --auth none \
  --disable-telemetry \
  "$APP_DIR"
