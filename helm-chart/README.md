# Paperless-ngx Helm Chart

This Helm chart deploys [Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx), a modern document management system, on a Kubernetes cluster.

## Features

- Complete Paperless-ngx deployment with PostgreSQL and Redis
- Configurable persistent storage for documents and data
- Optional external database and Redis support
- Ingress configuration for external access
- Horizontal Pod Autoscaling support
- Security-focused configuration with non-root containers
- Email configuration support

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Installing the Chart

To install the chart with the release name `paperless`:

```bash
# Add Bitnami repository for dependencies
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install the chart
helm install paperless ./helm-chart
```

## Uninstalling the Chart

To uninstall/delete the `paperless` deployment:

```bash
helm delete paperless
```

## Configuration

The following table lists the configurable parameters of the Paperless-ngx chart and their default values.

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of Paperless-ngx replicas | `1` |
| `image.repository` | Paperless-ngx image repository | `ghcr.io/paperless-ngx/paperless-ngx` |
| `image.tag` | Paperless-ngx image tag | `2.12.1` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |

### Paperless-ngx Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `paperless.admin.username` | Admin username | `admin` |
| `paperless.admin.email` | Admin email | `admin@example.com` |
| `paperless.admin.password` | Admin password (auto-generated if empty) | `""` |
| `paperless.config.timezone` | Application timezone | `Europe/Berlin` |
| `paperless.config.allowedHosts` | Allowed hosts | `*` |
| `paperless.config.ocrLanguages` | OCR languages | `deu+eng` |

### Persistence

| Parameter | Description | Default |
|-----------|-------------|---------|
| `paperless.persistence.enabled` | Enable persistence | `true` |
| `paperless.persistence.size` | Data volume size | `10Gi` |
| `paperless.persistence.mediaSize` | Media volume size | `20Gi` |
| `paperless.persistence.storageClass` | Storage class | `""` |

### Database (PostgreSQL)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `postgresql.enabled` | Enable PostgreSQL | `true` |
| `postgresql.auth.database` | Database name | `paperless` |
| `postgresql.auth.username` | Database username | `paperless` |
| `postgresql.auth.password` | Database password | `paperless` |

### Cache (Redis)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `redis.enabled` | Enable Redis | `true` |
| `redis.auth.enabled` | Enable Redis authentication | `false` |

### Ingress

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.hosts[0].host` | Hostname | `paperless.local` |

## Usage Examples

### Basic Installation

```bash
helm install paperless ./helm-chart
```

### Installation with Custom Values

```bash
helm install paperless ./helm-chart \
  --set paperless.admin.password=mysecretpassword \
  --set paperless.config.timezone=America/New_York \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=paperless.example.com
```

### Installation with External Database

```bash
helm install paperless ./helm-chart \
  --set postgresql.enabled=false \
  --set externalDatabase.host=my-postgres.example.com \
  --set externalDatabase.username=paperless \
  --set externalDatabase.password=mypassword \
  --set externalDatabase.database=paperless
```

### Values File Example

Create a `values.yaml` file:

```yaml
paperless:
  admin:
    username: admin
    email: admin@company.com
    password: "secure-password"
  config:
    timezone: "Europe/Berlin"
    ocrLanguages: "deu+eng+fra"
  persistence:
    size: 50Gi
    mediaSize: 100Gi

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: paperless.company.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: paperless-tls
      hosts:
        - paperless.company.com

resources:
  requests:
    cpu: 1000m
    memory: 2Gi
  limits:
    cpu: 2000m
    memory: 4Gi
```

Then install with:

```bash
helm install paperless ./helm-chart -f values.yaml
```

## Upgrading

To upgrade the chart:

```bash
helm upgrade paperless ./helm-chart
```

## Backup and Restore

### Backup

1. Stop the application:
   ```bash
   kubectl scale deployment paperless-paperless-ngx --replicas=0
   ```

2. Backup the persistent volumes and database

3. Restart the application:
   ```bash
   kubectl scale deployment paperless-paperless-ngx --replicas=1
   ```

### Restore

Follow the same process but restore the data before restarting.

## Troubleshooting

### Common Issues

1. **Pod fails to start**: Check logs with `kubectl logs deployment/paperless-paperless-ngx`
2. **Database connection issues**: Verify database credentials and connectivity
3. **Storage issues**: Ensure PVC is bound and storage class is available

### Useful Commands

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=paperless-ngx

# View logs
kubectl logs -f deployment/paperless-paperless-ngx

# Test connection
helm test paperless

# Access shell in pod
kubectl exec -it deployment/paperless-paperless-ngx -- /bin/bash
```

## Security Considerations

- Change default admin password
- Use external secrets for sensitive data
- Configure proper network policies
- Enable TLS for ingress
- Regular security updates

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This chart is licensed under the Apache 2.0 License.