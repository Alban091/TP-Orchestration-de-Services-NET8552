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
# Démarrer les services
docker-compose up -d

# Vérifier l'état des conteneurs
docker ps

# Voir les logs
docker-compose logs -f

# Arrêter les services
docker-compose down
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
├── network-service-chain.bpmn  # Workflow BPMN
├── playbooks/
│   ├── deploy_firewall.yaml
│   ├── deploy_loadbalancer.yaml
│   └── deploy_webserver.yaml
└── screenshots/
    ├── docker_ps.png
    ├── curl_tests.png
    └── workflow_bpmn.png
```

## 🧪 Tests

```bash
# Test de la chaîne complète
curl http://localhost:8080

# Test du Load Balancer
curl http://localhost:9090

# Test du Web Server direct
curl http://localhost:8081

# Test du blocage firewall
curl -A "BadBot/1.0" http://localhost:8080  # → 403 Forbidden

# Vérifier les headers
curl -I http://localhost:8080
```

## 🎨 Workflow BPMN

Le fichier `network-service-chain.bpmn` contient le workflow de déploiement :

```
⚪ Start → [Deploy Web Server] → [Deploy Load Balancer] → [Deploy Firewall] → [Test Network Flow] → ⚫ End
```

Pour visualiser : ouvrir avec **Camunda Modeler**

## 📝 Note sur xOpera

xOpera n'est pas compatible avec macOS ARM64 (Apple Silicon).
Docker Compose est utilisé comme alternative pour ce TP.

## 👨‍🏫 Encadrant

Pr. Walid GAALOUL
