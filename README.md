# Paperless-ngx Helm Chart

Dieses Repository enthält ein Helm Chart für die Bereitstellung von [Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx) auf Kubernetes.

## Schnellstart

```bash
# Repository-Abhängigkeiten hinzufügen
make deps

# Standard-Installation
make install

# Oder direkt mit Helm
helm install paperless ./helm-chart
```

## Projektstruktur

```
├── helm-chart/              # Hauptverzeichnis des Helm Charts
│   ├── Chart.yaml          # Chart-Metadaten
│   ├── values.yaml         # Standard-Konfigurationswerte
│   ├── values-production.yaml # Produktions-Konfiguration
│   ├── templates/          # Kubernetes-Manifeste
│   └── README.md          # Detaillierte Dokumentation
├── Makefile               # Hilfsbefehle für einfache Verwaltung
└── README.md             # Diese Datei
```

## Verfügbare Make-Befehle

- `make install` - Installiert das Chart mit Standard-Werten
- `make install-prod` - Installiert mit Produktions-Konfiguration
- `make upgrade` - Aktualisiert die bestehende Installation
- `make uninstall` - Entfernt die Installation
- `make test` - Führt Helm-Tests aus
- `make lint` - Überprüft das Chart auf Fehler
- `make template` - Rendert die Templates lokal
- `make get-password` - Zeigt das Admin-Passwort an

Für eine vollständige Liste: `make help`

## Konfiguration

Das Chart bietet umfangreiche Konfigurationsmöglichkeiten:

- **Persistente Speicher** für Dokumente und Daten
- **Integrierte PostgreSQL und Redis** oder externe Services
- **Ingress-Konfiguration** für externen Zugriff
- **Autoscaling** für Produktionsumgebungen
- **Sicherheitskonfiguration** mit Non-Root-Containern

Siehe `helm-chart/README.md` für detaillierte Konfigurationsoptionen.

## Beispiel-Konfigurationen

### Lokale Entwicklung
```bash
helm install paperless ./helm-chart
```

### Produktion
```bash
helm install paperless ./helm-chart -f ./helm-chart/values-production.yaml
```

### Mit Custom Domain
```bash
helm install paperless ./helm-chart \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=paperless.example.com
```

## Sicherheit

- Standard-Admin-Passwort wird automatisch generiert
- Alle Container laufen als Non-Root-User
- Secrets werden sicher in Kubernetes Secrets gespeichert
- ReadOnlyRootFilesystem wo möglich aktiviert

## Support

Für Fragen und Probleme:
1. Überprüfen Sie die Logs: `make logs`
2. Testen Sie die Verbindung: `make test`
3. Konsultieren Sie die detaillierte Dokumentation in `helm-chart/README.md`

## Lizenz

Apache 2.0 License