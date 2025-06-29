# Keycloak Stack

A complete Docker-based Keycloak deployment stack with PostgreSQL database, SSL certificate management, and realm import capabilities.

## Overview

This project provides a production-ready Keycloak Identity and Access Management solution with:

- **Keycloak 23.0** - Identity and Access Management server
- **PostgreSQL 16.2** - Database backend
- **Nginx Proxy** - Reverse proxy with automatic SSL certificates
- **Let's Encrypt** - Automatic SSL certificate generation and renewal
- **Realm Import** - Pre-configured realm and user import functionality

## Project Structure

```sh
├── src/
│   ├── keycloak/          # Keycloak service configuration
│   │   ├── import/        # Realm export files for import
│   │   ├── Dockerfile     # Custom Keycloak image with import support
│   │   └── README.md      # Keycloak-specific documentation
│   └── cert-manager/      # SSL certificate management
│       └── README.md      # Certificate manager documentation
```

## Quick Start

### Development Environment

1. Clone the repository
2. Navigate to the keycloak directory:

   ```bash
   cd src/keycloak
   ```

3. Copy environment configuration:

   ```bash
   cp .env.example .env
   ```

4. Start development environment:

   ```bash
   ./docker-dev.sh
   ```

Keycloak will be available at `http://localhost:8080`

### Production Environment

1. Set up SSL certificate manager:

   ```bash
   cd src/cert-manager
   docker-compose up -d
   ```

2. Configure production environment:

   ```bash
   cd ../keycloak
   cp .env.example .env
   # Edit .env with your production settings
   ```

3. Deploy Keycloak with SSL:

   ```bash
   ./docker-prod.sh
   ```

## Configuration

### Environment Variables

Key environment variables in `.env`:

- `POSTGRES_DB` - PostgreSQL database name
- `POSTGRES_USER` - PostgreSQL username
- `POSTGRES_PASSWORD` - PostgreSQL password
- `KEYCLOAK_ADMIN` - Keycloak admin username
- `KEYCLOAK_ADMIN_PASSWORD` - Keycloak admin password
- `POSTGRES_VERSION` - PostgreSQL version (default: 16.2)
- `KEYCLOAK_VERSION` - Keycloak version (default: 23.0)
- `VIRTUAL_HOST` - Domain for SSL certificate (production)
- `LETSENCRYPT_EMAIL` - Email for Let's Encrypt certificates

### Realm Import

To import pre-configured realms and users:

1. Export your realm configuration from Keycloak admin console
2. Place the `realm-export.json` file in `src/keycloak/import/`
3. Rebuild and restart the containers

The custom Dockerfile automatically copies import files to the appropriate location for Keycloak to process during startup.

## Services

### Keycloak

- **Port**: 8080 (development), 443 (production with SSL)
- **Admin Console**: `/admin`
- **Default Admin**: admin/admin (change in production)

### PostgreSQL

- **Port**: 5432 (development only)
- **Database**: keycloakdb
- **Health Check**: Automatic readiness probe

### SSL Certificate Manager

- **Nginx Proxy**: Automatic reverse proxy configuration
- **Let's Encrypt**: Automatic SSL certificate generation
- **Auto-renewal**: Certificates automatically renewed

## Development

### Available Scripts

- `./docker-dev.sh` - Start development environment
- `./docker-prod.sh` - Start production environment with SSL

### Docker Compose Files

- `docker-compose.yml` - Base configuration
- `docker-compose.dev.yml` - Development overrides (port exposure)
- `docker-compose.cert.yml` - Production SSL configuration

## Security Considerations

- Change default admin credentials in production
- Use strong passwords for database and admin accounts
- Configure proper firewall rules for production deployment
- Regularly update container images for security patches

## License

This project is dual-licensed under:

- Apache License 2.0
- MIT License

See `LICENSE-APACHE` and `LICENSE-MIT` for details.
