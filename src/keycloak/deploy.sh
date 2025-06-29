#!/bin/bash

# Keycloak Deployment Script
# Usage: ./deploy.sh [--development|--devcontainer|--production]

case "$1" in
    --development|-d)
        docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
        ;;
    --devcontainer|-dc)
        docker-compose -f docker-compose.yml -f docker-compose.devcontainer.yml up -d --build
        ;;
    --production|-p)
        docker-compose -f docker-compose.yml -f docker-compose.cert.yml up -d --build
        ;;
    --help|-h|*)
        echo "Usage: $0 [--development|--devcontainer|--production]"
        echo ""
        echo "  --development, -d     Development environment (ports 8080, 5432)"
        echo "  --devcontainer, -dc   DevContainer environment"
        echo "  --production, -p      Production environment (SSL)"
        ;;
esac