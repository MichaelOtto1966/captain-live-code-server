# Verwenden Sie das offizielle code-server-Image als Basis.
FROM ghcr.io/coder/code-server:latest

# Setzen Sie den Arbeitsordner im Container.
WORKDIR /home/coder/

# Legen Sie den Standard-Port fest.
EXPOSE 8080

# Wechseln Sie zu einem Benutzer mit Root-Rechten, um Pakete zu installieren
USER root

# Aktualisieren Sie die Paketliste und installieren Sie Node.js, npm und das CapRover CLI
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install -g caprover && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Wechseln Sie zurück zum Standardbenutzer "coder"
USER coder

# Kopieren Sie den gesamten Quellcode in ein festes, statisches Verzeichnis
# Dieses Verzeichnis wird für die Persistenz verwendet
COPY . /home/coder/app

# Starten Sie den Code-Server und verwenden Sie das statische Verzeichnis als Arbeitsbereich.
# Das `-P` Flag stellt sicher, dass der Port richtig gemappt wird.
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "--disable-telemetry", "/home/coder/app"]
