#!/usr/bin/env bash
# agent-bootstrap.sh — carrega contexto rápido pro agente no início da sessão
#
# Uso: ./scripts/agent-bootstrap.sh
#
# Saída pode ser pipada pra ferramentas (claude, cursor, etc.) ou
# lida pelo dev antes de começar a sessão.
#
# Mantém output <500 linhas — agente que lê muito perde tokens em vez de codar.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

echo "================================================================"
echo "  AGENT BOOTSTRAP — $(date -u '+%Y-%m-%d %H:%M UTC')"
echo "================================================================"

# 1. PROGRESS — onde estamos no projeto
echo ""
echo "===== PROGRESS ====="
if [[ -f progress.md ]]; then
  cat progress.md
else
  echo "(sem progress.md — crie a partir de agents/narvi/templates/progress.md)"
fi

# 2. AGENTS / CLAUDE — convenções vivas do projeto
echo ""
echo "===== AGENTS.md / CLAUDE.md (convenções) ====="
if [[ -f AGENTS.md ]]; then
  cat AGENTS.md
elif [[ -f CLAUDE.md ]]; then
  cat CLAUDE.md
else
  echo "(sem AGENTS.md/CLAUDE.md — crie a partir de agents/narvi/templates/AGENTS.md)"
fi

# 3. BRANCH & GIT STATE — onde está o código
echo ""
echo "===== GIT STATE ====="
echo "Branch: $(git branch --show-current 2>/dev/null || echo 'detached HEAD')"
echo "Last 5 commits:"
git log --oneline -5 2>/dev/null || true
echo ""
echo "Diff vs main (stat only):"
git diff main --stat 2>/dev/null | tail -20 || \
git diff origin/main --stat 2>/dev/null | tail -20 || \
echo "(sem branch main como referência)"

# 4. LAST SENSORS RUN — estado de qualidade
echo ""
echo "===== ÚLTIMA RUN DOS SENSORS ====="
if [[ -f .harness/last-run.json ]]; then
  cat .harness/last-run.json
else
  echo "(sem run recente — rode npm test / pytest / go test antes de começar)"
fi

# 5. CONTRATO ATIVO — se há sprint em execução
echo ""
echo "===== CONTRATO DA SPRINT ATUAL (se houver) ====="
if compgen -G ".harness/contracts/active-*.md" > /dev/null 2>&1; then
  cat .harness/contracts/active-*.md
elif compgen -G ".harness/contracts/sprint-*.md" > /dev/null 2>&1; then
  echo "(múltiplos sprints — verifique progress.md pra o ativo)"
  ls .harness/contracts/
else
  echo "(sem contrato ativo — projeto não está em modo multi-agente)"
fi

# 6. ADRs RECENTES — decisões que afetam código
echo ""
echo "===== ADRs RECENTES ====="
if [[ -d docs/adrs ]]; then
  echo "Últimas 3 ADRs:"
  ls -t docs/adrs/*.md 2>/dev/null | head -3 | while read -r f; do
    echo "  - $f"
    head -5 "$f" | sed 's/^/      /'
  done
else
  echo "(sem docs/adrs)"
fi

# 7. FORJA DAS ALIANÇAS — projetos relacionados (se script disponível)
echo ""
echo "===== ALIANÇAS (projetos que se comunicam com este) ====="
if [[ -x scripts/narvi-discover-allies.sh ]]; then
  echo "(rode './scripts/narvi-discover-allies.sh' pra mapear alianças)"
elif grep -q "Alianças externas" AGENTS.md 2>/dev/null; then
  grep -A 10 "Alianças externas" AGENTS.md | tail -n +2 | head -5
else
  echo "(sem mapeamento de alianças — rode narvi-discover-allies.sh)"
fi

echo ""
echo "================================================================"
echo "  INSTRUÇÕES"
echo "================================================================"
echo "Antes de começar:"
echo "  1. Leia o estado acima."
echo "  2. Confirme em uma frase qual task vai atacar."
echo "  3. Atualize progress.md antes de fechar a sessão."
echo ""
echo "Em caso de dúvida:"
echo "  - Confira AGENTS.md primeiro."
echo "  - Se não cobrir, pergunte em vez de inventar."
echo "================================================================"
