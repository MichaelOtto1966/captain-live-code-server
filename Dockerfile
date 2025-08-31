# Stage 1: Temporärer Container zum Extrahieren der vsda-Dateien.
# Wir nutzen denselben Basistyp, um Kompatibilität sicherzustellen.
FROM ghcr.io/coder/code-server:latest as vsda-extractor

# Stage 2: Dies ist der Haupt-Build-Prozess für Ihre App.
FROM ghcr.io/coder/code-server:latest

# Setzen Sie den Standard-Port.
EXPOSE 8080

# Wechseln Sie zu einem Benutzer mit Root-Rechten.
USER root

# Kopieren Sie die vsda-Dateien aus der temporären Stage in das endgültige Image.
# Dies behebt das Problem mit den fehlenden Dateien, die der Support gemeldet hat.
COPY --from=vsda-extractor /usr/lib/code-server/lib/vscode/out/vs/workbench/contrib/local/browser/vsda_bg.wasm /usr/lib/code-server/lib/vscode/out/vs/workbench/contrib/local/browser/vsda_bg.wasm
COPY --from=vsda-extractor /usr/lib/code-server/lib/vscode/out/vs/workbench/contrib/local/browser/vsda.js /usr/lib/code-server/lib/vscode/out/vs/workbench/contrib/local/browser/vsda.js

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
# Fügen Sie hier die ID der Erweiterung ein, die Sie persistent installieren möchten.
# Beispiel: RUN code-server --install-extension roonie007.hide-files
RUN code-server --install-extension sguerri.simple-hide-files

# NEU: Setzen Sie die Umgebungsvariable NODE_OPTIONS, um den Speicher zu begrenzen.
# --max-old-space-size ist die korrekte Option für Node.js.
# Hier auf 2 Gigabyte gesetzt (2048 MB).
ENV NODE_OPTIONS=--max-old-space-size=2048

# Setzen Sie den Standardbefehl, der den Code-Server startet.
# Entfernen Sie die nicht-existierende --max-memory Option.
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "/home/coder/project"]
