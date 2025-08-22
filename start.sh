#!/bin/sh

# Das Verzeichnis, das Sie in CapRover als persistenten Pfad einstellen.
# CapRover garantiert die Eindeutigkeit dieses Pfades pro App.
PERSISTENT_DIR="/home/coder/app_data"

# Das temporäre Verzeichnis, in das die Dockerfile die Quelldaten kopiert.
SOURCE_DIR="/tmp/app_source"

echo "Überprüfe, ob das persistente Verzeichnis leer ist..."

# Überprüfen Sie, ob das persistente Verzeichnis leer ist,
# indem Sie eine leere Liste von Dateien abfragen.
if [ -z "$(ls -A "$PERSISTENT_DIR")" ]; then
   echo "Das persistente Verzeichnis ist leer. Kopiere initiale Anwendungsdateien..."
   
   # Kopiere alle Dateien außer den Deployment-Dateien.
   find "$SOURCE_DIR" -maxdepth 1 -mindepth 1 -not -name "Dockerfile" -not -name "start.sh" -not -name "captain-definition" -exec cp -r {} "$PERSISTENT_DIR" \;
else
   echo "Das persistente Verzeichnis enthält bereits Daten. Überspringe Kopiervorgang."
fi

# Starte den Code-Server mit dem persistenten Verzeichnis als Arbeitsbereich.
echo "Starte Code-Server..."
code-server \
  --bind-addr 0.0.0.0:8080 \
  --auth none \
  --disable-telemetry \
  "$PERSISTENT_DIR"
