#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Script: deploy_firewall.sh
# Description: Déploiement du VNF Firewall (nginx comme reverse proxy)
# ═══════════════════════════════════════════════════════════════

echo "🔥 Déploiement du Firewall..."

# Créer le réseau s'il n'existe pas
docker network create net8552-chain 2>/dev/null || true

# Lancer le conteneur Firewall
docker run -d \
  --name vnf-firewall \
  --hostname vnf-firewall \
  --network net8552-chain \
  -p 8080:80 \
  -v "$(pwd)/configs/firewall/nginx.conf:/etc/nginx/nginx.conf:ro" \
  nginx:alpine

if [ $? -eq 0 ]; then
  echo "✅ Firewall déployé avec succès sur le port 8080"
else
  echo "❌ Erreur lors du déploiement du Firewall"
  exit 1
fi
