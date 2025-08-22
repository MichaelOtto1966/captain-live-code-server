# Verwenden Sie das offizielle code-server-Image als Basis.
# Dieses Image enthält bereits Node.js, npm und Python.
FROM ghcr.io/coder/code-server:latest

# Setzen Sie den Arbeitsordner im Container.
# Alle nachfolgenden Befehle werden in diesem Verzeichnis ausgeführt.
WORKDIR /home/coder/

# Legen Sie den Standard-Port fest, auf dem die App lauscht.
# Wichtig: Dieser Port muss in CapRover in den App-Einstellungen auf 8080 gesetzt werden.
EXPOSE 8080

# Wechseln Sie zu einem Benutzer mit Root-Rechten, um Pakete zu installieren
USER root

# Aktualisieren Sie die Paketliste und installieren Sie Node.js, npm und das CapRover CLI
# Stellen Sie sicher, dass alles in einem einzigen RUN-Befehl ist, um die Image-Größe zu optimieren
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install -g caprover && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Wechseln Sie zurück zum Standardbenutzer "coder"
USER coder

# Erstellen des Startskripts direkt im Dockerfile mit einem "Here-Document"
# Dies ist eine viel robustere Methode als die Verwendung von "echo",
# da sie Probleme mit Escape-Zeichen und Zeilenumbrüchen vermeidet.
RUN cat << 'EOF' > /start.sh
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
EOF

# Machen Sie das Startskript ausführbar
RUN chmod +x /start.sh

# Kopieren des gesamten Quellcodes
COPY . /tmp/app_source/

# Setzen Sie den dynamischen Startbefehl, der das Skript ausführt
CMD ["/start.sh"]







