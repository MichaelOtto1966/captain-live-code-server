#!/bin/sh

# Das Verzeichnis, das von CapRover persistent gemacht wird.
# CapRover garantiert, dass dieses Verzeichnis für jede App eindeutig ist.
PERSISTENT_DIR="/home/coder/persistent-data"
TEMP_SOURCE_DIR="/app"

echo "Erstelle persistentes Verzeichnis für $CAPTAIN_APP_NAME..."
mkdir -p "$PERSISTENT_DIR"

echo "Kopiere Anwendungsdateien in das persistente Verzeichnis..."
# Die -n Option verhindert, dass das Kopieren fehlschlägt, falls das Verzeichnis bereits existiert.
cp -rn "$TEMP_SOURCE_DIR/." "$PERSISTENT_DIR"

echo "Starte Code-Server..."
code-server \
  --bind-addr 0.0.0.0:8080 \
  --auth none \
  --disable-telemetry \
  "$PERSISTENT_DIR"
