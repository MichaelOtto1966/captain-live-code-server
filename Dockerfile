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

# Kopieren Sie den gesamten Quellcode in ein temporäres Verzeichnis
COPY . /tmp/app_source/

# Setzen Sie den dynamischen Startbefehl
# Der Code-Server wird mit einem dynamischen Arbeitsverzeichnis gestartet, das den App-Namen enthält.
# --auth none erlaubt den Zugriff ohne Passwort
# --disable-telemetry deaktiviert die Datenerfassung
# `$$CAPTAIN_APP_NAME$$` wird von CapRover während des Deployments ersetzt
# Die Dateien aus /tmp/app_source werden in das neue Verzeichnis kopiert
#
# Wichtiger Hinweis: Je nach Ihrem tatsächlichen Basis-Image
# müssen Sie den genauen Startbefehl für den VS Code Server anpassen.
# Überprüfen Sie die Dokumentation Ihres Images für den korrekten Befehl.
CMD mkdir -p /home/coder/$$CAPTAIN_APP_NAME$$ && \
    cp -r /tmp/app_source/. /home/coder/$$CAPTAIN_APP_NAME$$ && \
    code-server --bind-addr 0.0.0.0:8080 --auth none --disable-telemetry /home/coder/$$CAPTAIN_APP_NAME$$




