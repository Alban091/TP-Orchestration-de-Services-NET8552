#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Script: test_flow.sh
# Description: Tests de la chaîne de services réseau
# ═══════════════════════════════════════════════════════════════

echo "═══════════════════════════════════════════════════════════"
echo "  🧪 Tests de la chaîne de services NET8552"
echo "═══════════════════════════════════════════════════════════"
echo ""

PASS=0
FAIL=0

# Test 1: Web Server
echo "Test 1: Web Server direct (port 8081)"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081)
if [ "$HTTP_CODE" == "200" ]; then
  echo "  ✅ PASS - HTTP $HTTP_CODE"
  ((PASS++))
else
  echo "  ❌ FAIL - HTTP $HTTP_CODE"
  ((FAIL++))
fi
echo ""

# Test 2: Load Balancer
echo "Test 2: Load Balancer (port 9090)"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9090)
if [ "$HTTP_CODE" == "200" ]; then
  echo "  ✅ PASS - HTTP $HTTP_CODE"
  ((PASS++))
else
  echo "  ❌ FAIL - HTTP $HTTP_CODE"
  ((FAIL++))
fi
echo ""

# Test 3: Chaîne complète via Firewall
echo "Test 3: Chaîne complète via Firewall (port 8080)"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
if [ "$HTTP_CODE" == "200" ]; then
  echo "  ✅ PASS - HTTP $HTTP_CODE"
  ((PASS++))
else
  echo "  ❌ FAIL - HTTP $HTTP_CODE"
  ((FAIL++))
fi
echo ""

# Test 4: HAProxy Stats
echo "Test 4: HAProxy Stats Dashboard (port 8404)"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8404/stats)
if [ "$HTTP_CODE" == "200" ]; then
  echo "  ✅ PASS - HTTP $HTTP_CODE"
  ((PASS++))
else
  echo "  ❌ FAIL - HTTP $HTTP_CODE"
  ((FAIL++))
fi
echo ""

# Test 5: Blocage Firewall
echo "Test 5: Blocage Firewall (User-Agent: BadBot)"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -A "BadBot/1.0" http://localhost:8080)
if [ "$HTTP_CODE" == "403" ]; then
  echo "  ✅ PASS - HTTP $HTTP_CODE (Bloqué correctement)"
  ((PASS++))
else
  echo "  ❌ FAIL - HTTP $HTTP_CODE (Devrait être 403)"
  ((FAIL++))
fi
echo ""

# Test 6: Header X-Firewall-Passed
echo "Test 6: Vérification Header X-Firewall-Passed"
HEADER=$(curl -sI http://localhost:8080 | grep -i "X-Firewall-Passed")
if [ -n "$HEADER" ]; then
  echo "  ✅ PASS - Header présent"
  ((PASS++))
else
  echo "  ❌ FAIL - Header absent"
  ((FAIL++))
fi
echo ""

# Résumé
echo "═══════════════════════════════════════════════════════════"
echo "  📊 Résultats: $PASS PASS / $FAIL FAIL"
echo "═══════════════════════════════════════════════════════════"

if [ $FAIL -eq 0 ]; then
  echo "  🎉 Tous les tests sont passés !"
  exit 0
else
  echo "  ⚠️ Certains tests ont échoué"
  exit 1
fi
