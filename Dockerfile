# Verwenden Sie das offizielle code-server-Image als Basis.
FROM ghcr.io/coder/code-server:latest

# Setzen Sie den Standard-Port.
EXPOSE 8080

# Wechseln Sie zu einem Benutzer mit Root-Rechten.
USER root

# Aktualisieren Sie die Paketliste und installieren Sie die notwendigen Tools.
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install -g caprover && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ändern Sie den Besitzer des Home-Verzeichnisses zu "coder".
RUN chown -R coder:coder /home/coder

# Wechseln Sie zurück zum Standardbenutzer "coder".
USER coder

# Legen Sie das Arbeitsverzeichnis fest.
# Wichtig: CapRover wird Ihre Quelldateien zur Laufzeit hierher kopieren.
WORKDIR /home/coder/project

# Installieren Sie die VS Code-Erweiterungen.
RUN code-server --install-extension sguerri.simple-hide-files

# NEU: Kopieren Sie vsda-Dateien an den korrekten Ort, um den Absturz zu beheben.
# Diese Dateien sind nur in den node_modules verfügbar und müssen manuell kopiert werden.
RUN cp /usr/lib/code-server/lib/vscode/node_modules/vsda/rust/web/vsda.js /usr/lib/code-server/lib/vscode/node_modules/vsda/rust/web/vsda.js && \
    cp /usr/lib/code-server/lib/vscode/node_modules/vsda/rust/web/vsda_bg.wasm /usr/lib/code-server/lib/vscode/node_modules/vsda/rust/web/vsda_bg.wasm

# NEU: Setzen Sie die Umgebungsvariable NODE_OPTIONS, um den Speicher zu begrenzen.
ENV NODE_OPTIONS=--max-old-space-size=2048

# Setzen Sie den Standardbefehl, der den Code-Server startet.
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "/home/coder/project"]
