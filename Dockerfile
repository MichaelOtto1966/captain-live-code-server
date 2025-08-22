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

# Erstellen des Startskripts direkt im Dockerfile
# Dadurch werden Probleme mit Dateirechten und Zeilenumbrüchen vermieden
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'PERSISTENT_DIR="/home/coder/$CAPTAIN_APP_NAME"' >> /start.sh && \
    echo 'TEMP_SOURCE_DIR="/tmp/app_source"' >> /start.sh && \
    echo 'mkdir -p "$PERSISTENT_DIR"' >> /start.sh && \
    echo 'cp -r "$TEMP_SOURCE_DIR/." "$PERSISTENT_DIR"' >> /start.sh && \
    echo 'code-server \\' >> /start.sh && \
    echo '--bind-addr 0.0.0.0:8080 \\' >> /start.sh && \
    echo '--auth none \\' >> /start.sh && \
    echo '--disable-telemetry \\' >> /start.sh && \
    echo '"$PERSISTENT_DIR"' >> /start.sh && \
    chmod +x /start.sh

# Kopieren des gesamten Quellcodes
COPY . /tmp/app_source/

# Setzen Sie den dynamischen Startbefehl, der das Skript ausführt
CMD ["/start.sh"]






