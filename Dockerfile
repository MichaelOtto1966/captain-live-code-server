# Beginnen Sie mit dem offiziellen code-server Image
FROM ghcr.io/coder/code-server:latest

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

# Festlegen des Arbeitsverzeichnisses
WORKDIR /home/coder/project

# Kopieren der aktuellen Dateien in das Arbeitsverzeichnis des Images
# Dies ist nur für den initialen Build relevant
COPY . .

# Deklarieren eines Volumes für das Arbeitsverzeichnis
# Dies stellt sicher, dass alle Daten in diesem Verzeichnis
# bei Container-Neustarts oder -Ersetzungen erhalten bleiben.
VOLUME /home/coder/project

# Exponieren des Standard-Ports von Code-Server
EXPOSE 8080

# Befehl zum Starten des Servers
CMD ["/usr/bin/dumb-init", "code-server", "--bind-addr", "0.0.0.0:8080", "/home/coder/project"]
