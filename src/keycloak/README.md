# 🔑 Keycloak Service

A modular Docker Compose configuration system for Keycloak with PostgreSQL backend, realm import capabilities, and support for multiple environments.

## 🏗️ Project Structure

```sh
src/keycloak/
├── components/                              # Source compose components
│   ├── base/                               # Base components
│   │   ├── docker-compose.yml              # Main Keycloak + PostgreSQL services
│   │   └── .env.example                    # Base environment variables
│   └── environments/                       # Environment components
│       ├── devcontainer/
│       │   └── docker-compose.yml          # DevContainer environment
│       ├── forwarding/
│       │   └── docker-compose.yml          # Development with port forwarding
│       ├── letsencrypt/
│       │   ├── docker-compose.yml          # Let's Encrypt SSL
│       │   └── .env.example                # Let's Encrypt variables
│       └── step-ca/
│           ├── docker-compose.yml          # Step CA SSL
│           └── .env.example                # Step CA variables
│   └── extensions/                         # Extension components
│       ├── realm-import/
│       │   ├── docker-compose.yml          # Custom build with realm import
│       │   ├── Dockerfile                  # Custom Keycloak image
│       │   └── import/                     # Realm import directory
│       └── step-ca-trust/
│           ├── docker-compose.yml          # Step CA trust integration
│           └── .env.example                # Step CA trust variables
├── build/                        # Generated configurations (auto-generated)
│   ├── devcontainer/
│   │   ├── base/                 # DevContainer + base
│   │   ├── realm-import/         # DevContainer + realm import
│   │   ├── step-ca-trust/        # DevContainer + step-ca trust
│   │   └── realm-import+step-ca-trust/  # DevContainer + realm import + step-ca trust
│   ├── forwarding/
│   │   ├── base/                 # Development + base
│   │   ├── realm-import/         # Development + realm import
│   │   ├── step-ca-trust/        # Development + step-ca trust
│   │   └── realm-import+step-ca-trust/  # Development + realm import + step-ca trust
│   ├── letsencrypt/
│   │   ├── base/                 # Let's Encrypt + base
│   │   ├── realm-import/         # Let's Encrypt + realm import
│   │   ├── step-ca-trust/        # Let's Encrypt + step-ca trust
│   │   └── realm-import+step-ca-trust/  # Let's Encrypt + realm import + step-ca trust
│   └── step-ca/
│       ├── base/                 # Step CA + base
│       ├── realm-import/         # Step CA + realm import
│       ├── step-ca-trust/        # Step CA + step-ca trust
│       └── realm-import+step-ca-trust/  # Step CA + realm import + step-ca trust
├── build.sh                      # Build script
└── README.md                     # This file
```

## 🚀 Quick Start

### 1. Build Configurations

Run the build script to generate all possible combinations:

```bash
./build.sh
```

This will create all combinations in the `build/` directory.

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
docker-compose up -d
```

Access: `http://localhost:8080/admin` (for forwarding mode)

## 🔧 Available Configurations

### Environments

- **devcontainer**: Development environment with workspace network
- **forwarding**: Development environment with port forwarding (8080, 5432)
- **letsencrypt**: Production with Let's Encrypt SSL certificates
- **step-ca**: Production with Step CA SSL certificates

### Extensions

- **realm-import**: Custom Keycloak build with realm import capabilities
- **step-ca-trust**: Adds Step CA certificates to container's trusted certificate store

### Generated Combinations

Each environment can be combined with any extension:

- `devcontainer/base` - DevContainer development setup
- `devcontainer/realm-import` - DevContainer with realm import
- `devcontainer/step-ca-trust` - DevContainer with step-ca trust
- `devcontainer/realm-import+step-ca-trust` - DevContainer with realm import + step-ca trust
- `forwarding/base` - Development with port forwarding
- `forwarding/realm-import` - Development with realm import
- `forwarding/step-ca-trust` - Development with step-ca trust
- `forwarding/realm-import+step-ca-trust` - Development with realm import + step-ca trust
- `letsencrypt/base` - Production with Let's Encrypt SSL
- `letsencrypt/realm-import` - Production with Let's Encrypt + realm import
- `letsencrypt/step-ca-trust` - Production with Let's Encrypt + step-ca trust
- `letsencrypt/realm-import+step-ca-trust` - Production with Let's Encrypt + realm import + step-ca trust
- `step-ca/base` - Production with Step CA SSL
- `step-ca/realm-import` - Production with Step CA + realm import
- `step-ca/step-ca-trust` - Production with Step CA + step-ca trust
- `step-ca/realm-import+step-ca-trust` - Production with Step CA + realm import + step-ca trust

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
   ./build.sh
   cd build/forwarding/realm-import/  # or any other environment with realm-import
   # Place your realm-export.json in the import/ directory
   cp /path/to/realm-export.json import/
   docker-compose up -d --build
   ```

The `realm-import` extension automatically:

- Builds a custom Keycloak image with import capabilities
- Copies the `import/` directory into the container
- Adds the `--import-realm` flag to the startup command

## 🛠️ Development

### Adding New Environments

1. Create directory in `components/environments/` with `docker-compose.yml` and optional `.env.example` file
2. Run `./build.sh` to generate new combinations

### File Naming Convention

All component files follow the standard Docker Compose naming convention (`docker-compose.yml`) for:

- **VS Code compatibility**: Full support for Docker Compose language features and IntelliSense
- **IDE integration**: Proper syntax highlighting and validation in all major editors
- **Tool compatibility**: Works with Docker Compose plugins and extensions
- **Standard compliance**: Follows official Docker Compose file naming patterns

### Modifying Existing Components

1. Edit the component files in `components/`
2. Run `./build.sh` to regenerate configurations
3. The `build/` directory will be completely recreated

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

- Ensure `yq` is installed: <https://github.com/mikefarah/yq#install>
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
- Missing `.env.*` files for components are handled gracefully by the build script

## 🔄 Migration from Legacy Deploy Script

The legacy `deploy.sh` script is still available for compatibility, but the new build system is recommended:

**Legacy approach:**

```bash
./deploy.sh --forwarding
```

**New approach:**

```bash
./build.sh
cd build/forwarding/base/
cp .env.example .env
docker-compose up -d
