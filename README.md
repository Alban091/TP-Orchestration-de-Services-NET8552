# 🔗 TP NET8552 - Orchestration de Services Réseau

> **Télécom SudParis** | Département Informatique & Réseaux | 2025-2026

## 📋 Architecture

```
                    ┌─────────────────────────────────────────────────┐
                    │              Service Chain (VNF)                │
                    └─────────────────────────────────────────────────┘
                                         │
     ┌───────────────┐    ┌───────────────┐    ┌───────────────┐
     │   FIREWALL    │───▶│ LOAD BALANCER │───▶│  WEB SERVER   │
     │  nginx:alpine │    │   haproxy     │    │  nginx:alpine │
     │    :8080      │    │    :9090      │    │    :8081      │
     └───────────────┘    └───────────────┘    └───────────────┘
           │                     │                    │
           └─────────────────────┴────────────────────┘
                         net8552-chain
                        (172.28.0.0/16)
```

## 🚀 Démarrage Rapide

```bash
# Démarrer
./scripts/start.sh

# Tester
./scripts/test.sh

# Arrêter
./scripts/stop.sh
```

## 🌐 Points d'accès

| Service | URL | Description |
|---------|-----|-------------|
| Chaîne complète | http://localhost:8080 | Via Firewall → LB → Web |
| Load Balancer | http://localhost:9090 | Accès direct |
| Web Server | http://localhost:8081 | Accès direct |
| HAProxy Stats | http://localhost:8404/stats | Dashboard |

## 📁 Structure du Projet

```
network-orchestration/
├── docker-compose.yml          # Configuration Docker
├── service-chain.yaml          # Modèle TOSCA
├── configs/
│   ├── firewall/
│   │   └── nginx.conf          # Config Firewall
│   ├── loadbalancer/
│   │   └── haproxy.cfg         # Config HAProxy
│   └── webserver/
│       ├── index.html          # Page web
│       └── style.css           # Styles
├── playbooks/
│   ├── deploy_firewall.yaml
│   ├── deploy_loadbalancer.yaml
│   └── deploy_webserver.yaml
├── scripts/
│   ├── start.sh
│   ├── stop.sh
│   ├── test.sh
│   └── logs.sh
└── screenshots/
```

## 🧪 Tests

```bash
# Test de la chaîne complète
curl http://localhost:8080

# Test du blocage firewall
curl -A "BadBot/1.0" http://localhost:8080  # → 403 Forbidden

# Vérifier les headers
curl -I http://localhost:8080
```

## 🎨 Workflow BPMN

1. Ouvrir **Camunda Modeler**
2. Créer un nouveau diagramme BPMN
3. Ajouter les éléments:
   - ⚪ Start Event
   - 📦 Service Task: Deploy Web Server
   - 📦 Service Task: Deploy Load Balancer
   - 📦 Service Task: Deploy Firewall
   - 📦 Service Task: Test Connectivity
   - ⚫ End Event
4. Sauvegarder: `network-service-chain.bpmn`

## 📝 Note sur xOpera

xOpera n'est pas compatible avec macOS ARM64 (Apple Silicon).
Docker Compose est utilisé comme alternative pour ce TP.

## 👨‍🏫 Encadrant

Pr. Walid GAALOUL
