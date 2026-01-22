#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# Script de démarrage de la chaîne de services
# ═══════════════════════════════════════════════════════════════════════════════

cd "$(dirname "$0")/.."

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════════════╗"
echo "  ║   🚀 Démarrage de la chaîne de services       ║"
echo "  ╚═══════════════════════════════════════════════╝"
echo -e "${NC}"

# Vérifier Docker
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}✗ Docker n'est pas actif${NC}"
    echo "  Lancez Docker Desktop et réessayez"
    exit 1
fi

# Démarrer les services
echo -e "  ${CYAN}▸${NC} Démarrage des conteneurs..."
docker-compose up -d

# Attendre
echo -e "  ${CYAN}▸${NC} Attente de l'initialisation..."
sleep 5

# Afficher l'état
echo ""
docker-compose ps
echo ""

echo -e "${GREEN}  ✓ Services démarrés !${NC}"
echo ""
echo -e "  ${CYAN}Accès:${NC}"
echo -e "    • Chaîne complète:  ${GREEN}http://localhost:8080${NC}"
echo -e "    • Load Balancer:    ${GREEN}http://localhost:9090${NC}"
echo -e "    • Web Server:       ${GREEN}http://localhost:8081${NC}"
echo -e "    • HAProxy Stats:    ${GREEN}http://localhost:8404/stats${NC}"
echo ""
