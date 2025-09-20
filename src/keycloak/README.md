# 🔑 Keycloak Service

A modular Docker Compose configuration system for Keycloak with PostgreSQL backend, realm import capabilities, and support for multiple environments.

## 🚀 Quick Start

### 1. Build Configurations

Use stackbuilder to generate all configurations:

```bash
sb build
```

This will create all combinations in the `build/` directory based on [`stackbuilder.toml`](stackbuilder.toml).

### 2. Choose Your Configuration

Navigate to the desired configuration directory:

```bash
# For development with port forwarding
cd build/forwarding/base/

# For DevContainer environment  
cd build/devcontainer/base/

# For production with Let's Encrypt SSL
cd build/letsencrypt/base/

# For production with Step CA SSL
cd build/step-ca/base/
```

### 3. Configure Environment

Copy and edit the environment file:

```bash
cp .env.example .env
# Edit .env with your values
```

### 4. Deploy

Start the services:

```bash
docker compose up --build -d
```

Access: `http://localhost:8080/admin` (for forwarding mode)

## 📁 Directory Structure

- [`components/`](components/) - Source compose components
  - [`base/`](components/base/) - Base Keycloak + PostgreSQL configuration
  - [`environments/`](components/environments/) - Environment-specific configurations
  - [`extensions/`](components/extensions/) - Extension components (realm import, SSL trust)
- [`build/`](build/) - Generated configurations (auto-generated, ready to deploy)
- [`stackbuilder.toml`](stackbuilder.toml) - Build configuration for stackbuilder

## 🔧 Available Configurations

### Environments

- **devcontainer**: Development environment with workspace network
- **forwarding**: Development environment with port forwarding (8080, 5432)
- **letsencrypt**: Production with Let's Encrypt SSL certificates
- **step-ca**: Production with Step CA SSL certificates

### Extensions

- **realm-import**: Custom Keycloak build with realm import capabilities
- **step-ca-trust**: Adds Step CA certificates to container's trusted certificate store

## 🔧 Environment Variables

### Base Configuration

- `COMPOSE_PROJECT_NAME`: Project name for Docker Compose
- `POSTGRES_DB`: PostgreSQL database name
- `POSTGRES_USER`: PostgreSQL username
- `POSTGRES_PASSWORD`: PostgreSQL password
- `KEYCLOAK_ADMIN`: Keycloak admin username
- `KEYCLOAK_ADMIN_PASSWORD`: Keycloak admin password
- `POSTGRES_VERSION`: PostgreSQL version (default: 16.2)
- `KEYCLOAK_VERSION`: Keycloak version (default: 23.0)

### Let's Encrypt Configuration

- `VIRTUAL_PORT`: Port for nginx-proxy (default: 8080)
- `VIRTUAL_HOST`: Domain for nginx-proxy
- `LETSENCRYPT_HOST`: Domain for SSL certificate
- `LETSENCRYPT_EMAIL`: Email for certificate registration

### Step CA Configuration

- `VIRTUAL_PORT`: Port for nginx-proxy (default: 8080)
- `VIRTUAL_HOST`: Domain for nginx-proxy
- `LETSENCRYPT_HOST`: Domain for SSL certificate
- `LETSENCRYPT_EMAIL`: Email for certificate registration

### Step CA Trust Configuration

- `STEP_CA_URL`: Step CA server URL for certificate retrieval
- `STEP_CA_FINGERPRINT`: Step CA root certificate fingerprint for verification

## 📥 Realm Import

1. Export realm from Keycloak admin console
2. Place `realm-export.json` in the generated configuration's `import/` directory
3. Use a configuration with the `realm-import` extension:

   ```bash
   sb build
   cd build/forwarding/realm-import/
   # Place your realm-export.json in the import/ directory
   cp /path/to/realm-export.json import/
   docker compose up -d --build
   ```

The `realm-import` extension automatically:

- Builds a custom Keycloak image with import capabilities
- Copies the `import/` directory into the container
- Adds the `--import-realm` flag to the startup command

## 🌐 Networks

- **Development**: `keycloak-network` (internal)
- **DevContainer**: `keycloak-workspace-network` (external)
- **Let's Encrypt**: `letsencrypt-network` (external)
- **Step CA**: `step-ca-network` (external)

## 🔒 Security

⚠️ **Production Checklist:**

- Change default admin credentials
- Use strong database passwords
- Configure firewall rules
- Regular security updates

## 🆘 Troubleshooting

**Build Issues:**

- Ensure stackbuilder is installed: <https://github.com/zyrakq/stackbuilder>
- Check component file syntax
- Verify all required files exist

**Import Issues:**

- Check JSON validity
- Verify `--import-realm` flag in base component
- Review container logs: `docker logs keycloak`

**SSL Issues:**

- **Let's Encrypt**: Verify domain DNS and letsencrypt-manager
- **Step CA**: Check step-ca-manager and virtual network config

## 📝 Notes

- The `build/` directory is automatically generated and should not be edited manually
- Environment variables in generated files use `$VARIABLE_NAME` format for proper interpolation
- Each generated configuration includes a complete `docker-compose.yml` and `.env.example`
- Use `sb build` to regenerate all configurations after modifying components
