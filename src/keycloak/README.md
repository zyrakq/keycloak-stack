# 🔑 Keycloak Service

Keycloak Identity and Access Management server with PostgreSQL backend and realm import capabilities.

## 🚀 Quick Start

### 🔧 Development

```bash
./deploy.sh --forwarding
```

Access: `http://localhost:8080/admin`

### 🌐 Production (Let's Encrypt)

```bash
./deploy.sh --letsencrypt
```

Requires internet access and valid domain.

### 🔒 Virtual Network (Step CA)

```bash
./deploy.sh --step-ca
```

For isolated Docker networks with self-signed trusted certificates.

### 📦 DevContainer

```bash
./deploy.sh --devcontainer
```

VS Code devcontainer integration.

## ⚙️ Configuration

Copy and edit environment file:

```bash
cp .env.example .env
```

**Key Variables:**

- `KEYCLOAK_ADMIN` / `KEYCLOAK_ADMIN_PASSWORD` - Admin credentials
- `POSTGRES_*` - Database configuration
- `VIRTUAL_HOST` - Your domain (production)
- `LETSENCRYPT_EMAIL` - Email for SSL certificates

## 📥 Realm Import

1. Export realm from Keycloak admin console
2. Place `realm-export.json` in `import/` directory
3. Enable import in `docker-compose.yml`:

   ```yaml
   command:
     - "start"
     - "--http-port=8080"
     - "--proxy=edge"
     - "--import-realm"  # Uncomment this
   ```

4. Redeploy with your chosen mode

## 🔧 Available Commands

- `./deploy.sh --forwarding` - Development with port forwarding
- `./deploy.sh --devcontainer` - DevContainer environment
- `./deploy.sh --letsencrypt` - Production with Let's Encrypt SSL
- `./deploy.sh --step-ca` - Production with Step CA SSL

## 🌐 Networks

- **Development**: `keycloak-network` (internal)
- **Let's Encrypt**: `letsencrypt-network` (external)
- **Step CA**: `step-ca-network` (external)

## 🔒 Security

⚠️ **Production Checklist:**

- Change default admin credentials
- Use strong database passwords
- Configure firewall rules
- Regular security updates

## 🆘 Troubleshooting

**Import Issues:**

- Check JSON validity
- Verify `--import-realm` flag
- Review container logs: `docker logs keycloak`

**SSL Issues:**

- **Let's Encrypt**: Verify domain DNS and letsencrypt-manager
- **Step CA**: Check step-ca-manager and virtual network config
