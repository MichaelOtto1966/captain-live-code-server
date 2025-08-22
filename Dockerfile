# Phase 1: Der "Builder" - Erstellt das Startskript
# Wir verwenden ein einfaches Alpine-Image, um das Skript zu erstellen
FROM alpine:3.18 as builder

WORKDIR /app

# Erstelle das Startskript mit printf
# Diese Methode ist robuster, da sie keine Probleme mit Here-Documents hat
# und das Skript unabhängig von Zeilenumbrüchen oder unsichtbaren Zeichen
# auf der Host-Maschine korrekt erstellt.
RUN printf '#!/bin/sh\n\n' > start.sh && \
    printf 'PERSISTENT_DIR="/home/coder/$CAPTAIN_APP_NAME"\n' >> start.sh && \
    printf 'TEMP_SOURCE_DIR="/tmp/app_source"\n\n' >> start.sh && \
    printf 'echo "Erstelle persistentes Verzeichnis für $CAPTAIN_APP_NAME..."\n' >> start.sh && \
    printf 'mkdir -p "$PERSISTENT_DIR"\n\n' >> start.sh && \
    printf 'echo "Kopiere Anwendungsdateien in das persistente Verzeichnis..."\n' >> start.sh && \
    printf 'cp -r "$TEMP_SOURCE_DIR/." "$PERSISTENT_DIR"\n\n' >> start.sh && \
    printf 'echo "Starte Code-Server..."\n' >> start.sh && \
    printf 'code-server \\\n' >> start.sh && \
    printf '  --bind-addr 0.0.0.0:8080 \\\n' >> start.sh && \
    printf '  --auth none \\\n' >> start.sh && \
    printf '  --disable-telemetry \\\n' >> start.sh && \
    printf '  "$PERSISTENT_DIR"\n' >> start.sh && \
    chmod +x start.sh

# Phase 2: Das finale Image
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

# Kopieren Sie das Startskript aus dem Builder-Image
COPY --from=builder /app/start.sh /start.sh

# Kopieren des gesamten Quellcodes
COPY . /tmp/app_source/

# Setzen Sie den dynamischen Startbefehl, der das Skript ausführt
CMD ["/start.sh"]









