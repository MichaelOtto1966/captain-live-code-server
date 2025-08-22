# Verwenden Sie das offizielle code-server-Image als Basis.
FROM ghcr.io/coder/code-server:latest

# Setzen Sie den Arbeitsordner im Container.
WORKDIR /home/coder/

# Legen Sie den Standard-Port fest.
EXPOSE 8080

# Wechseln Sie zu einem Benutzer mit Root-Rechten, um Pakete zu installieren
USER root

# Aktualisieren Sie die Paketliste und installieren Sie die notwendigen Tools.
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Wechseln Sie zurück zum Standardbenutzer "coder"
USER coder

# Kopieren Sie alle Projektdateien, einschließlich des Startskripts.
COPY . /app

# Setzen Sie den dynamischen Startbefehl.
# Dieser Befehl führt unser Startskript aus, das die App mit einem
# eindeutigen, dynamischen Verzeichnis startet.
CMD ["/app/start.sh"]

