#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# Script de test de la chaîne de services
# ═══════════════════════════════════════════════════════════════════════════════

cd "$(dirname "$0")/.."

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo -e "${MAGENTA}"
echo "  ╔═══════════════════════════════════════════════╗"
echo "  ║   🧪 Tests de la chaîne de services           ║"
echo "  ╚═══════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Compteurs
PASSED=0
FAILED=0

run_test() {
    local name="$1"
    local cmd="$2"
    local expected="$3"
    
    echo -e "  ${CYAN}TEST:${NC} $name"
    
    result=$(eval "$cmd" 2>/dev/null)
    
    if [[ "$result" == *"$expected"* ]] || [[ "$expected" == "200" && "$result" == "200" ]]; then
        echo -e "  ${GREEN}✓ PASS${NC}"
        ((PASSED++))
    else
        echo -e "  ${RED}✗ FAIL${NC} (got: $result)"
        ((FAILED++))
    fi
    echo ""
}

# État des conteneurs
echo -e "${CYAN}  ▸ État des conteneurs${NC}"
echo ""
docker-compose ps
echo ""

# Tests
echo -e "${CYAN}  ▸ Tests de connectivité${NC}"
echo ""

run_test "Web Server direct (8081)" \
    "curl -s -o /dev/null -w '%{http_code}' http://localhost:8081" \
    "200"

run_test "Load Balancer (9090)" \
    "curl -s -o /dev/null -w '%{http_code}' http://localhost:9090" \
    "200"

run_test "Chaîne complète via Firewall (8080)" \
    "curl -s -o /dev/null -w '%{http_code}' http://localhost:8080" \
    "200"

run_test "HAProxy Stats (8404)" \
    "curl -s -o /dev/null -w '%{http_code}' http://localhost:8404/stats" \
    "200"

run_test "Blocage Firewall (User-Agent: BadBot)" \
    "curl -s -o /dev/null -w '%{http_code}' -A 'BadBot/1.0' http://localhost:8080" \
    "403"

run_test "Header X-Firewall-Status présent" \
    "curl -sI http://localhost:8080 | grep -i 'X-Firewall-Status'" \
    "PASSED"

# Résumé
echo -e "${MAGENTA}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${GREEN}✓ Réussis: $PASSED${NC}  ${RED}✗ Échoués: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "  ${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "  ${GREEN}║   ✅ Tous les tests sont passés !             ║${NC}"
    echo -e "  ${GREEN}╚═══════════════════════════════════════════════╝${NC}"
else
    echo -e "  ${YELLOW}⚠ Certains tests ont échoué${NC}"
fi

echo ""
echo -e "  🌐 Ouvrez dans votre navigateur: ${GREEN}http://localhost:8080${NC}"
echo ""
