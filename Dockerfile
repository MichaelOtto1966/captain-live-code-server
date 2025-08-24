# Verwenden Sie das offizielle code-server-Image als Basis.
FROM ghcr.io/coder/code-server:latest

# Setzen Sie den Standard-Port.
EXPOSE 8080

# Wechseln Sie zu einem Benutzer mit Root-Rechten.
USER root

# Aktualisieren Sie die Paketliste und installieren Sie die notwendigen Tools.
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ändern Sie den Besitzer des Home-Verzeichnisses zu "coder".
RUN chown -R coder:coder /home/coder

# Wechseln Sie zurück zum Standardbenutzer "coder".
USER coder

# Legen Sie das Arbeitsverzeichnis fest.
# Wichtig: CapRover wird Ihre Quelldateien zur Laufzeit hierher kopieren.
WORKDIR /home/coder/project

# Setzen Sie den Standardbefehl, der den Code-Server startet.
# Der Pfad zeigt auf das Arbeitsverzeichnis, in das CapRover Ihre Daten kopiert.
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "/home/coder/project"]






