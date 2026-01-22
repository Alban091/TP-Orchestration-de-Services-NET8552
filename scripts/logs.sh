#!/bin/bash
# Afficher les logs de tous les services
cd "$(dirname "$0")/.."
docker-compose logs -f --tail=50
