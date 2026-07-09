#!/usr/bin/env bash
# Deploy do Painel AgroCore no Netlify.
# Pre-requisitos (uma vez):
#   npm install -g netlify-cli
#   netlify login
# Uso: ./deploy.sh
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# O Netlify serve index.html na raiz. Se o painel estiver como painel-mercado.html,
# garante uma copia atualizada como index.html:
if [ -f painel-mercado.html ]; then
  cp -f painel-mercado.html index.html
fi

echo "Publicando painel AgroCore no Netlify..."
netlify deploy --prod --dir="$DIR" --message "Atualizacao painel AgroCore $(date +%Y-%m-%d)"
echo "Concluido. A URL publica foi exibida acima."
