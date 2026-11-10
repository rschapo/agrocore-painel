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

# Trava de seguranca: nunca publicar um arquivo com marcadores de conflito de merge
# nao resolvidos (ja aconteceu de um merge malfeito ir parar no site publicado).
if grep -qE '^(<{7}|={7}|>{7})' index.html; then
  echo "ERRO: index.html tem marcadores de conflito de merge (<<<<<<< / ======= / >>>>>>>) nao resolvidos." >&2
  echo "Resolva o conflito antes de publicar. Deploy cancelado." >&2
  exit 1
fi

# Publica so a pagina e o logo (desde 10/11/2026); README, prompts e scripts
# do repositorio nao vao para o site.
SITE="$(mktemp -d)"
trap 'rm -rf "$SITE"' EXIT
cp index.html logo-agrocore.png "$SITE/"

echo "Publicando painel AgroCore no Netlify..."
netlify deploy --prod --dir="$SITE" --message "Atualizacao painel AgroCore $(date +%Y-%m-%d)"
echo "Concluido. A URL publica foi exibida acima."
