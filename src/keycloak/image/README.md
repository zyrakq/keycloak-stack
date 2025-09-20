# Keycloak Custom Image

Custom Docker image for Keycloak with dynamic configuration generation based on environment variables.

## Quick Start

Build the custom Keycloak image:

```bash
cd src/keycloak/image
docker build -t keycloak .
docker tag keycloak localhost/keycloak
```
