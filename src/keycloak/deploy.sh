#!/bin/bash

# Keycloak Deployment Script
# Usage: ./deploy.sh [--forwarding|--devcontainer|--letsencrypt|--step-ca]

case "$1" in
    --forwarding|-f)
        docker-compose -f docker-compose.yml -f docker-compose.forwarding.yml up -d --build
        ;;
    --devcontainer|-dc)
        docker-compose -f docker-compose.yml -f docker-compose.devcontainer.yml up -d --build
        ;;
    --letsencrypt|-le)
        docker-compose -f docker-compose.yml -f docker-compose.letsencrypt.yml up -d --build
        ;;
    --step-ca|-sc)
        docker-compose -f docker-compose.yml -f docker-compose.step-ca.yml up -d --build
        ;;
    --help|-h|*)
        echo "Usage: $0 [--forwarding|--devcontainer|--letsencrypt|--step-ca]"
        echo ""
        echo "  --forwarding, -f      Development environment (ports 8080, 5432)"
        echo "  --devcontainer, -dc   DevContainer environment"
        echo "  --letsencrypt, -le    Production environment with Let's Encrypt SSL"
        echo "  --step-ca, -sc        Production environment with Step CA SSL"
        ;;
esac