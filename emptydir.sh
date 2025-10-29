
#!/bin/bash

# Verzeichnis mit Pod-Daten
BASE_DIR="/var/lib/kubelet/pods"

# Alle Pod-Verzeichnisse durchgehen
for pod_dir in $BASE_DIR/*; do
    # Pod-UID extrahieren
    pod_uid=$(basename "$pod_dir")

    # Prüfen, ob der Pod noch existiert
    if ! crictl pods | grep -q "$pod_uid"; then
        # Verzeichnis für emptyDir-Volumes
        emptydir_path="$pod_dir/volumes/kubernetes.io~empty-dir"

        if [ -d "$emptydir_path" ]; then
            echo "Lösche verwaiste emptyDir-Daten für Pod $pod_uid..."
            rm -rf "$emptydir_path"
        fi
    fi

done

echo "Bereinigung abgeschlossen."
