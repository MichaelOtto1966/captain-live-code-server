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

# Kopieren Sie den gesamten Quellcode und das Startskript
COPY . /tmp/app_source/
COPY start.sh /tmp/app_source/start.sh

# Machen Sie das Startskript ausführbar
RUN chmod +x /tmp/app_source/start.sh

# Setzen Sie den dynamischen Startbefehl, der das Skript ausführt
# Das `start.sh`-Skript wird die App mit dem korrekten Verzeichnis starten.
CMD ["/tmp/app_source/start.sh"]





