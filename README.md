# 🔐 Keycloak Stack

Complete Docker-based Keycloak deployment with SSL certificate management for production and development environments.

## 📦 Components

### 🔑 [Keycloak Service](src/keycloak/)

Identity and Access Management server with PostgreSQL backend, realm import capabilities, and multiple deployment modes.

### 🌐 [Let's Encrypt Manager](src/letsencrypt-manager/)

Automatic SSL certificate generation and renewal using Let's Encrypt for production deployments with internet access.

### 🔒 [Step CA Manager](src/step-ca-manager/)

Self-signed trusted certificate authority for virtual Docker networks without internet access. Automatically manages and distributes CA certificates within isolated environments.

## 🚀 Quick Start

Each component has its own README with detailed setup instructions. Choose the certificate management solution that fits your deployment scenario.

## 📋 Requirements

- Docker & Docker Compose
- Domain name (for production deployments)
- Email address (for Let's Encrypt)

## 📄 License

This project is dual-licensed under:

- [Apache License 2.0](LICENSE-APACHE)
- [MIT License](LICENSE-MIT)
