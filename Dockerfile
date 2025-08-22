# Verwenden Sie das offizielle code-server-Image als Basis.
FROM ghcr.io/coder/code-server:latest

# Legen Sie den Standard-Port fest.
EXPOSE 8080

# Wechseln Sie zu einem Benutzer mit Root-Rechten.
USER root

# Aktualisieren Sie die Paketliste und installieren Sie die notwendigen Tools.
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Wechseln Sie zurück zum Standardbenutzer "coder"
USER coder

# Kopieren Sie alle Projektdateien in ein temporäres Verzeichnis.
# Dies stellt sicher, dass das persistente Volume unberührt bleibt.
COPY . /tmp/app_source/

# Setzen Sie den dynamischen Startbefehl.
# Dieser Befehl führt ein Startskript aus, das die App korrekt konfiguriert.
CMD ["/tmp/app_source/start.sh"]



