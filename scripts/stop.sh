#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# Script d'arrêt de la chaîne de services
# ═══════════════════════════════════════════════════════════════════════════════

cd "$(dirname "$0")/.."

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${RED}"
echo "  ╔═══════════════════════════════════════════════╗"
echo "  ║   🛑 Arrêt de la chaîne de services           ║"
echo "  ╚═══════════════════════════════════════════════╝"
echo -e "${NC}"

docker-compose down

echo ""
echo -e "${GREEN}  ✓ Services arrêtés${NC}"
echo ""
