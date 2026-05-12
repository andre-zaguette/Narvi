# Narvi — Artesão de Khazad-dûm

> *"Im Narvi hain echant"* — eu, Narvi, as fiz.

Narvi é o ferreiro-engenheiro da Sociedade do Anel. Como o Anão que forjou as Portas de Durin ao lado de Celebrimbor — em ithildin que ainda brilha à luz da lua, depois de eras — Narvi assina cada obra que entrega e sabe exatamente quem atravessa cada porta.

Ele assiste **Gandalf** antes de decisões cross-sistema: mapeia o ecossistema ao redor do projeto e garante que nenhuma mudança quebre silenciosamente um aliado desconhecido.

## Domínio

| Capacidade | Descrição |
|---|---|
| **Disciplina de craft** | BDD, TDD, Harness, ADR — nenhum código sem contrato |
| **Forja das Alianças** | Descobre projetos que se comunicam com o projeto atual via GitHub, GitLab ou Bitbucket |
| **Harness check** | Avalia o nível de harness necessário e monta o mínimo: `AGENTS.md`, `progress.md`, `bootstrap.sh` |
| **Interrogatório Socrático** | Para antes de codar quando o pedido é ambíguo ou o terreno é desconhecido |

## Sinal

Gandalf aciona Narvi com **`SIGNAL_CRAFT_FORGE`** quando:
- Um quest envolve mudança de API, schema ou contrato
- O harness de um projeto precisa ser auditado ou montado
- O impacto cross-sistema é desconhecido antes de agir

## Estrutura

```
narvi/
├── CLAUDE.md                       — instruções de carregamento
├── DEVELOPER.md                    — guia de uso e configuração
├── README.md                       — este arquivo
├── SKILL.md                        — skill principal (guardrails, BDD, TDD, ADR, Forja das Alianças)
├── scripts/
│   └── narvi-discover-allies.sh   — detecta remote e busca projetos aliados
└── templates/
    ├── AGENTS.md                   — template de convenções do projeto
    ├── bootstrap.sh                — template de bootstrap de sessão
    └── progress.md                 — template de memória persistente
```

## Como usar

### Forja das Alianças — descobrir quem depende deste projeto

```bash
# GitHub (requer gh CLI autenticado)
./scripts/narvi-discover-allies.sh

# GitLab (requer glab CLI ou GITLAB_TOKEN)
export GITLAB_TOKEN=<token>
./scripts/narvi-discover-allies.sh

# Bitbucket (requer BITBUCKET_USER + BITBUCKET_APP_PASSWORD)
export BITBUCKET_USER=<usuario>
export BITBUCKET_APP_PASSWORD=<app-password>
./scripts/narvi-discover-allies.sh

# Com detalhes das etapas
./scripts/narvi-discover-allies.sh --verbose
```

### Montar harness num projeto

```bash
cp agents/narvi/templates/AGENTS.md       <seu-projeto>/AGENTS.md
cp agents/narvi/templates/progress.md     <seu-projeto>/progress.md
cp agents/narvi/templates/bootstrap.sh    <seu-projeto>/scripts/agent-bootstrap.sh
chmod +x <seu-projeto>/scripts/agent-bootstrap.sh
```

### Carregar Narvi no Claude Code

Abra `agents/narvi/` como diretório de trabalho no Claude Code. O `CLAUDE.md` carrega a skill e os caminhos do Palantír automaticamente.

## Integração com a Sociedade

```
Gandalf recebe quest cross-sistema
  → emite SIGNAL_CRAFT_FORGE
  → Narvi roda narvi-discover-allies.sh
  → Narvi reporta mapa de alianças
  → Gandalf avalia impacto e roteia ao agente correto
  → Boromir valida antes do merge
```

## Referências

- `SKILL.md` — skill completa com todos os guardrails e padrões embutidos
- `DEVELOPER.md` — configuração por plataforma e casos de uso detalhados
- [Middle-Earth-Agents](https://github.com/andre-zaguette/Middle-Earth-Agents) — repositório principal da fellowship
