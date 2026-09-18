#!/bin/bash

# Script de Pull Automático no NAS Synology (A correr via Task Scheduler/Cron)
# Exemplo de configuração no Cron: 0 3 * * * /volume1/docker/pn-l-app/scripts/nas_autoupdate.sh >> /volume1/docker/pn-l-app/logs/cron.log 2>&1

# Definir a pasta raiz do projeto no NAS
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR" || exit 1

echo "🔄 [$(date +'%Y-%m-%d %H:%M:%S')] A iniciar verificação de atualizações no repositório..."

# Fazer fetch das últimas alterações do GitHub
git fetch origin

# Verificar se a branch local está atrás da origin/main
UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "✅ [$(date +'%Y-%m-%d %H:%M:%S')] O sistema já está atualizado. Nenhuma ação necessária."
elif [ "$LOCAL" = "$BASE" ]; then
    echo "⚠️ [$(date +'%Y-%m-%d %H:%M:%S')] Atualizações detetadas no GitHub. A puxar código..."
    
    # Executa o Pull e reconstrói as imagens
    git pull origin main
    
    echo "🔨 [$(date +'%Y-%m-%d %H:%M:%S')] A reconstruir contentores Docker (Frontend & Backend)..."
    docker-compose up -d --build
    
    # Limpa as imagens antigas para poupar espaço no NAS
    docker image prune -f
    
    echo "🎉 [$(date +'%Y-%m-%d %H:%M:%S')] Atualização concluída com sucesso! Os serviços foram reiniciados."
else
    echo "❌ [$(date +'%Y-%m-%d %H:%M:%S')] Conflito local detetado (Diverged). Por favor, resolve manualmente."
fi
