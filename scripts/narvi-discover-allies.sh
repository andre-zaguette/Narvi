#!/usr/bin/env bash
# narvi-discover-allies.sh — mapeia projetos que se comunicam com este repositório
#
# Narvi examina o remote git (GitHub, GitLab, Bitbucket) e busca outros
# projetos da mesma org/workspace que referenciam este — via package.json,
# go.mod, requirements.txt, docker-compose.yml e afins.
#
# Como as Portas de Durin: antes de abrirmos, Narvi sabe quem atravessa.
#
# Uso:
#   ./scripts/narvi-discover-allies.sh              # discovery padrão
#   ./scripts/narvi-discover-allies.sh --verbose    # mostra etapas internas
#
# Requisitos:
#   GitHub:    gh CLI autenticado (https://cli.github.com)
#   GitLab:    glab CLI autenticado OU variável GITLAB_TOKEN
#   Bitbucket: variáveis BITBUCKET_USER + BITBUCKET_APP_PASSWORD

set -euo pipefail

VERBOSE=false
for arg in "$@"; do
  case "$arg" in
    --verbose|-v) VERBOSE=true ;;
  esac
done

log_v() { [ "$VERBOSE" = true ] && echo "[narvi] $*" >&2; return 0; }

# ── 1. Detectar remote ──────────────────────────────────────────────────────
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [ -z "$REMOTE_URL" ]; then
  echo "⚠️  Narvi não encontrou remote 'origin'. Não há portas a mapear."
  echo "   Adicione um remote com: git remote add origin <url>"
  exit 0
fi

log_v "remote: $REMOTE_URL"

# ── 2. Identificar plataforma ───────────────────────────────────────────────
PLATFORM=""
OWNER=""
REPO=""

if echo "$REMOTE_URL" | grep -q "github\.com"; then
  PLATFORM="github"
  OWNER=$(echo "$REMOTE_URL" | sed -E 's|.*github\.com[:/]([^/]+)/.*|\1|')
  REPO=$(echo "$REMOTE_URL" | sed -E 's|.*github\.com[:/][^/]+/([^/.]+)(\.git)?$|\1|')
fi

if echo "$REMOTE_URL" | grep -q "gitlab\.com"; then
  PLATFORM="gitlab"
  OWNER=$(echo "$REMOTE_URL" | sed -E 's|.*gitlab\.com[:/]([^/]+)/.*|\1|')
  REPO=$(echo "$REMOTE_URL" | sed -E 's|.*gitlab\.com[:/][^/]+/([^/.]+)(\.git)?$|\1|')
fi

if echo "$REMOTE_URL" | grep -q "bitbucket\.org"; then
  PLATFORM="bitbucket"
  OWNER=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/]([^/]+)/.*|\1|')
  REPO=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/][^/]+/([^/.]+)(\.git)?$|\1|')
fi

if [ -z "$PLATFORM" ]; then
  echo "⚠️  Remote não reconhecido como GitHub, GitLab ou Bitbucket."
  echo "   Remote: $REMOTE_URL"
  echo "   Adicione suporte no script ou mapeie manualmente."
  exit 0
fi

log_v "platform=$PLATFORM owner=$OWNER repo=$REPO"

# ── 3. Detectar nome do pacote ──────────────────────────────────────────────
PACKAGE_NAME=""

if [ -f package.json ]; then
  PACKAGE_NAME=$(python3 -c "
import json, sys
try:
  d = json.load(open('package.json'))
  print(d.get('name', ''))
except: pass
" 2>/dev/null || true)
  log_v "package.json name: $PACKAGE_NAME"
fi

if [ -z "$PACKAGE_NAME" ] && [ -f go.mod ]; then
  PACKAGE_NAME=$(head -1 go.mod | sed 's/^module //')
  log_v "go.mod module: $PACKAGE_NAME"
fi

if [ -z "$PACKAGE_NAME" ] && [ -f pyproject.toml ]; then
  PACKAGE_NAME=$(grep -E '^name\s*=' pyproject.toml | head -1 | sed -E 's/name\s*=\s*"?([^"]+)"?/\1/' | tr -d ' ' || true)
  log_v "pyproject.toml name: $PACKAGE_NAME"
fi

if [ -z "$PACKAGE_NAME" ]; then
  PACKAGE_NAME="$REPO"
fi

log_v "searching as: '$PACKAGE_NAME' and '$REPO'"

# ── 4. Header ───────────────────────────────────────────────────────────────
echo ""
echo "================================================================"
echo "  NARVI — FORJA DAS ALIANÇAS"
echo "  Projeto : $OWNER/$REPO ($PLATFORM)"
echo "  Pacote  : $PACKAGE_NAME"
echo "  Data    : $(date -u '+%Y-%m-%d %H:%M UTC')"
echo "================================================================"
echo ""

# ── 5. Discovery por plataforma ─────────────────────────────────────────────
case "$PLATFORM" in

  github)
    if ! command -v gh >/dev/null 2>&1; then
      echo "⚠️  gh CLI não encontrado. Instale em: https://cli.github.com"
      exit 0
    fi

    # Arquivos de dependência onde buscar referências
    FILENAMES="package.json OR requirements.txt OR go.mod OR go.sum OR Cargo.toml OR pom.xml OR build.gradle OR docker-compose.yml OR docker-compose.yaml"

    echo "=== Repositórios que referenciam '$PACKAGE_NAME' na org '$OWNER' ==="
    echo ""

    FOUND=""
    for TERM in "$PACKAGE_NAME" "$REPO"; do
      [ "$TERM" = "$PACKAGE_NAME" ] || [ "$TERM" != "$PACKAGE_NAME" ] && true
      ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$TERM org:$OWNER $FILENAMES'))" 2>/dev/null || true)
      if [ -z "$ENCODED" ]; then
        log_v "python3 not available for URL encoding, skipping search for: $TERM"
        continue
      fi

      log_v "github search: $TERM in org $OWNER"
      RAW=$(gh api "search/code?q=${ENCODED}&per_page=20" \
        --jq '.items[] | "\(.repository.full_name)|\(.path)|\(.repository.description // "")"' \
        2>/dev/null || true)

      while IFS='|' read -r full_name path desc; do
        [ -z "$full_name" ] && continue
        [ "$full_name" = "$OWNER/$REPO" ] && continue
        LINE="  $full_name — $path"
        [ -n "$desc" ] && LINE="$LINE (${desc})"
        FOUND="${FOUND}${LINE}"$'\n'
      done <<< "$RAW"
    done

    if [ -z "$FOUND" ]; then
      echo "  (nenhum aliado encontrado na org '$OWNER')"
      echo "  Dica: verifique se o projeto usa nomes diferentes, ou se é privado."
    else
      echo "$FOUND" | sort -u | grep -v '^$'
    fi

    echo ""
    echo "=== Todos os repositórios em '$OWNER' ==="
    echo ""
    gh api "orgs/$OWNER/repos?per_page=50&sort=updated&type=all" \
      --jq '.[] | "  \(.name) — \(.description // "(sem descrição)")"' \
      2>/dev/null || \
    gh api "users/$OWNER/repos?per_page=50&sort=updated&type=owner" \
      --jq '.[] | "  \(.name) — \(.description // "(sem descrição)")"' \
      2>/dev/null || \
    echo "  (não foi possível listar — verifique permissões do gh CLI)"
    ;;

  gitlab)
    echo "=== Projetos no namespace '$OWNER' ==="
    echo ""

    if command -v glab >/dev/null 2>&1; then
      log_v "usando glab CLI"
      glab api "groups/$OWNER/projects?per_page=50&order_by=last_activity_at" \
        2>/dev/null | python3 -c "
import sys, json
try:
  projects = json.load(sys.stdin)
  for p in projects:
    name = p.get('path_with_namespace','')
    desc = p.get('description','') or '(sem descrição)'
    print(f'  {name} — {desc}')
except Exception as e:
  print(f'  (erro ao parsear resposta: {e})')
" 2>/dev/null || echo "  (não foi possível listar — verifique autenticação glab)"

    elif [ -n "${GITLAB_TOKEN:-}" ]; then
      log_v "usando GITLAB_TOKEN"
      ENCODED_OWNER=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$OWNER'))" 2>/dev/null || echo "$OWNER")
      curl -sf "https://gitlab.com/api/v4/groups/${ENCODED_OWNER}/projects?per_page=50&order_by=last_activity_at" \
        -H "Authorization: Bearer $GITLAB_TOKEN" \
        2>/dev/null | python3 -c "
import sys, json
try:
  projects = json.load(sys.stdin)
  for p in projects:
    name = p.get('path_with_namespace','')
    desc = p.get('description','') or '(sem descrição)'
    print(f'  {name} — {desc}')
except Exception as e:
  print(f'  (erro ao parsear resposta: {e})')
" 2>/dev/null || echo "  (não foi possível listar repositórios)"

    else
      echo "  ⚠️  Instale glab CLI (https://gitlab.com/gitlab-org/cli)"
      echo "      ou defina a variável: export GITLAB_TOKEN=<seu-token>"
    fi

    echo ""
    echo "  Nota: busca por referências cruzadas no GitLab requer acesso à API de busca."
    echo "  Para busca avançada: glab api '/search?scope=blobs&search=$PACKAGE_NAME'"
    ;;

  bitbucket)
    echo "=== Repositórios no workspace '$OWNER' ==="
    echo ""

    if [ -n "${BITBUCKET_USER:-}" ] && [ -n "${BITBUCKET_APP_PASSWORD:-}" ]; then
      log_v "usando BITBUCKET_USER + BITBUCKET_APP_PASSWORD"
      curl -sf "https://api.bitbucket.org/2.0/repositories/$OWNER?pagelen=50&sort=-updated_on" \
        -u "$BITBUCKET_USER:$BITBUCKET_APP_PASSWORD" \
        2>/dev/null | python3 -c "
import sys, json
try:
  data = json.load(sys.stdin)
  for r in data.get('values', []):
    name = r.get('full_name','')
    desc = r.get('description','') or '(sem descrição)'
    print(f'  {name} — {desc}')
except Exception as e:
  print(f'  (erro ao parsear resposta: {e})')
" 2>/dev/null || echo "  (não foi possível listar repositórios)"

    else
      echo "  ⚠️  Defina as variáveis de ambiente:"
      echo "      export BITBUCKET_USER=<seu-usuário>"
      echo "      export BITBUCKET_APP_PASSWORD=<app-password>"
      echo "  Crie o App Password em: https://bitbucket.org/account/settings/app-passwords/"
    fi
    ;;
esac

echo ""
echo "================================================================"
echo "  Im Narvi. Hain echant — o mapa das alianças foi gravado."
echo "================================================================"
echo ""
