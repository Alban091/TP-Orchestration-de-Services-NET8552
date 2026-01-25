#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Script: deploy_webserver.sh
# Description: Déploiement du VNF Web Server (Nginx)
# ═══════════════════════════════════════════════════════════════

echo "🌐 Déploiement du Web Server..."

# Créer le réseau s'il n'existe pas
docker network create net8552-chain 2>/dev/null || true

# Lancer le conteneur Web Server
docker run -d \
  --name vnf-web \
  --hostname vnf-web \
  --network net8552-chain \
  -p 8081:80 \
  -v "$(pwd)/configs/webserver/index.html:/usr/share/nginx/html/index.html:ro" \
  -v "$(pwd)/configs/webserver/style.css:/usr/share/nginx/html/style.css:ro" \
  nginx:alpine

if [ $? -eq 0 ]; then
  echo "✅ Web Server déployé avec succès sur le port 8081"
else
  echo "❌ Erreur lors du déploiement du Web Server"
  exit 1
fi
