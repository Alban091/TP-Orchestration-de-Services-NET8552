#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Script: deploy_loadbalancer.sh
# Description: Déploiement du VNF Load Balancer (HAProxy)
# ═══════════════════════════════════════════════════════════════

echo "⚖️ Déploiement du Load Balancer..."

# Créer le réseau s'il n'existe pas
docker network create net8552-chain 2>/dev/null || true

# Lancer le conteneur Load Balancer
docker run -d \
  --name vnf-lb \
  --hostname vnf-lb \
  --network net8552-chain \
  -p 9090:80 \
  -p 8404:8404 \
  -v "$(pwd)/configs/loadbalancer/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro" \
  haproxytech/haproxy-alpine:latest

if [ $? -eq 0 ]; then
  echo "✅ Load Balancer déployé avec succès sur le port 9090"
  echo "📊 Dashboard HAProxy disponible sur http://localhost:8404/stats"
else
  echo "❌ Erreur lors du déploiement du Load Balancer"
  exit 1
fi
