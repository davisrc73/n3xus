#!/bin/bash

# Script de sincronização automática com o GitHub

echo "🔍 A verificar alterações no projeto..."

if [[ -z $(git status -s) ]]; then
  echo "✅ Nenhuma alteração detetada. O repositório está atualizado."
  exit 0
fi

echo "⚠️ Alterações detetadas. A preparar sincronização..."

# Opcional: pedir mensagem de commit ao utilizador
read -p "📝 Introduz a mensagem do commit (ou deixa em branco para uma mensagem automática): " commit_msg

if [ -z "$commit_msg" ]; then
  # Se vazio, usa um timestamp e mensagem automática
  commit_msg="Atualização automática de desenvolvimento - $(date +'%Y-%m-%d %H:%M:%S')"
fi

echo "📦 A adicionar alterações..."
git add .

echo "💾 A registar commit: '$commit_msg'"
git commit -m "$commit_msg"

echo "🚀 A empurrar para o GitHub (origin main)..."
git push origin main

echo "🎉 Sincronização concluída com sucesso!"
