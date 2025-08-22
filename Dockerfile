# Verwenden Sie das offizielle code-server-Image als Basis.
# Dieses Image enthält bereits Node.js, npm und Python.
FROM ghcr.io/coder/code-server:latest

# Setzen Sie den Arbeitsordner im Container.
# Alle nachfolgenden Befehle werden in diesem Verzeichnis ausgeführt.
WORKDIR /home/coder/project

# Legen Sie den Standard-Port fest, auf dem die App lauscht.
# Wichtig: Dieser Port muss in CapRover in den App-Einstellungen auf 8080 gesetzt werden.
EXPOSE 8080

# Dieser VOLUME-Befehl ist eine Best-Practice. Er markiert das Verzeichnis
# als Speicherort für persistente Daten. CapRover behandelt dies als
# ein persistentes Verzeichnis, wenn Sie es in der App-Oberfläche festlegen.
# Sie müssen in CapRover das interne Verzeichnis auf /home/coder/project setzen.
VOLUME /home/coder/project

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

# Standardbefehl zum Starten des code-servers.
# --bind-addr 0.0.0.0:8080 stellt sicher, dass der Server auf allen
# Netzwerkschnittstellen erreichbar ist, was für Docker und CapRover wichtig ist.
# /home/coder/project ist das Standard-Arbeitsverzeichnis, das in der VS Code-Oberfläche
# angezeigt wird.
CMD ["/usr/bin/dumb-init", "code-server", "--bind-addr", "0.0.0.0:8080", "/home/coder/project"]



