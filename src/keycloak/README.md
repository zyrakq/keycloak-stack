# Keycloak Service

Keycloak Identity and Access Management server with PostgreSQL backend and realm import capabilities.

## Overview

This Keycloak deployment includes:

- Keycloak 23.0 server
- PostgreSQL 16.2 database
- Custom Docker image with realm import support
- Development and production configurations
- SSL certificate integration for production

## Quick Start

### Development Deployment

```bash
./deploy.sh --development
```

This starts Keycloak with:

- HTTP access on `localhost:8080`
- PostgreSQL exposed on `localhost:5432`
- Admin console at `http://localhost:8080/admin`

### DevContainer Deployment

```bash
./deploy.sh --devcontainer
```

This starts Keycloak for VS Code devcontainer integration with external workspace network.

### Production Deployment

```bash
./deploy.sh --production
```

This starts Keycloak with:

- SSL certificate management
- Production-ready configuration
- No exposed database ports

## Configuration

### Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
```

**Database Configuration:**

- `POSTGRES_DB=keycloakdb` - Database name
- `POSTGRES_USER=postgres` - Database username
- `POSTGRES_PASSWORD=postgres` - Database password

**Keycloak Admin:**

- `KEYCLOAK_ADMIN=admin` - Admin username
- `KEYCLOAK_ADMIN_PASSWORD=admin` - Admin password

**Version Configuration:**

- `POSTGRES_VERSION=16.2` - PostgreSQL version
- `KEYCLOAK_VERSION=23.0` - Keycloak version

**Production SSL (for production deployment):**

- `VIRTUAL_HOST=sso.example.com` - Your domain
- `LETSENCRYPT_HOST=sso.example.com` - SSL certificate domain
- `LETSENCRYPT_EMAIL=john-smith@example.com` - Let's Encrypt email

## Realm Import

### Custom Dockerfile

The included `Dockerfile` extends the official Keycloak image to support automatic realm import with configurable version:

```dockerfile
ARG KEYCLOAK_VERSION=23.0
FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}

COPY import/* /opt/keycloak/data/import/
```

This copies all files from the `import/` directory to Keycloak's import location. The Keycloak version can be configured via the `KEYCLOAK_VERSION` environment variable.

### Importing Realms

To import pre-configured realms with users and settings:

1. **Export your realm** from an existing Keycloak instance:
   - Go to Admin Console → Realm Settings → Action → Partial Export
   - Or use Full Export for complete realm backup
   - Save as `realm-export.json`

2. **Add the export file** to the import directory:

   ```bash
   cp realm-export.json src/keycloak/import/
   ```

3. **Enable import in docker-compose.yml** by uncommenting the import flag:

   ```yaml
   command:
     - "start"
     - "--http-port=8080"
     - "--proxy=edge"
     - "--import-realm"  # Uncomment this line
   ```

4. **Enable custom build** (optional) by switching to the custom image in `docker-compose.yml`:

   ```yaml
   keycloak:
     container_name: keycloak
     # image: quay.io/keycloak/keycloak:${KEYCLOAK_VERSION:-23.0}
     image: keycloak
     build:
       context: .
       args:
         KEYCLOAK_VERSION: ${KEYCLOAK_VERSION:-23.0}
   ```

5. **Rebuild and restart** the containers:

   ```bash
   ./deploy.sh --development  # or ./deploy.sh --production
   ```

### Import Directory Structure

```sh
import/
├── .gitkeep                    # Keeps directory in git
├── realm-export.json          # Your realm configuration (add this)
├── users-export.json          # Additional user exports (optional)
└── client-configs.json        # Client configurations (optional)
```

### Example Realm Export

A typical realm export includes:

- Realm settings and themes
- Client configurations (OIDC/SAML)
- User accounts and credentials
- Roles and role mappings
- Identity providers
- Authentication flows

## Docker Compose Files

### Deployment Script (`deploy.sh`)

Unified deployment script that replaces individual environment scripts:

```bash
./deploy.sh --development   # Development environment
./deploy.sh --devcontainer  # DevContainer environment
./deploy.sh --production    # Production environment
```

### Base Configuration (`docker-compose.yml`)

- Keycloak and PostgreSQL services
- Internal networking
- Health checks
- Environment variable configuration

### Development Override (`docker-compose.dev.yml`)

- Exposes ports for local access
- Keycloak: `8080:8080`
- PostgreSQL: `5432:5432`

### DevContainer Override (`docker-compose.devcontainer.yml`)

- External workspace network integration
- VS Code devcontainer support

### Production Override (`docker-compose.cert.yml`)

- SSL certificate integration
- External network connection for nginx-proxy
- Production environment variables

## Networking

### Development

- `keycloak-network` - Internal bridge network
- Exposed ports for direct access

### Production  

- `keycloak-network` - Internal services
- `cert-network` - External SSL proxy integration

## Troubleshooting

### Import Issues

- Ensure realm export files are valid JSON
- Check container logs: `docker logs keycloak`
- Verify import directory permissions
- Confirm `--import-realm` flag is enabled

### Database Connection

- Check PostgreSQL health: `docker logs keycloak-db`
- Verify environment variables match
- Ensure database is ready before Keycloak starts

### SSL Certificate Issues

- Verify cert-manager is running first
- Check domain DNS configuration
- Review nginx-proxy logs
- Confirm LETSENCRYPT_EMAIL is valid

## Security Notes

⚠️ **Important for Production:**

- Change default admin credentials
- Use strong database passwords
- Configure proper firewall rules
- Regularly update container images
- Review realm security settings after import

## Admin Access

- **Development**: `http://localhost:8080/admin`
- **Production**: `https://your-domain.com/admin`
- **Default Credentials**: admin/admin (change immediately)
