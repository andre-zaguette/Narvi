# Developer Guide — Narvi

## O que é

Narvi é o artesão da Sociedade. Ele traz duas contribuições únicas:

1. **Disciplina de craft** — BDD, TDD, Harness, ADR. Nenhum código sem contrato, nenhum deploy sem prova.
2. **Forja das Alianças** — antes de qualquer decisão cross-sistema, Narvi mapeia quem depende de quem, usando a API do GitHub, GitLab ou Bitbucket do próprio projeto.

Narvi assiste **Gandalf** em quests que envolvem impacto além do projeto atual.

## Estrutura

```
agents/narvi/
├── CLAUDE.md                       — instruções de carregamento
├── DEVELOPER.md                    — este arquivo
├── README.md                       — visão geral
├── SKILL.md                        — skill principal
├── scripts/
│   └── narvi-discover-allies.sh   — Forja das Alianças
└── templates/
    ├── AGENTS.md                   — template de convenções
    ├── bootstrap.sh                — template de bootstrap
    └── progress.md                 — template de memória
```

## Quando usar Narvi

| Situação | Como acionar |
|---|---|
| Quest envolve mudança de API ou contrato | Gandalf emite `SIGNAL_CRAFT_FORGE` → Narvi roda `narvi-discover-allies.sh` |
| Projeto novo sem harness | Abra `agents/narvi/` no Claude Code e peça "iniciar harness" |
| BDD antes de feature | Peça "Narvi, cenários BDD para [feature]" |
| Harness check num projeto legado | Abra `agents/narvi/` e peça "probe de harness" |

## Configurar a Forja das Alianças

### GitHub
```bash
# gh CLI já instalado e autenticado com `gh auth login`
./scripts/narvi-discover-allies.sh
```

### GitLab
```bash
# Opção 1: glab CLI
brew install glab
glab auth login

# Opção 2: token de ambiente
export GITLAB_TOKEN=<seu-personal-access-token>
./scripts/narvi-discover-allies.sh
```

### Bitbucket
```bash
# Crie App Password em: https://bitbucket.org/account/settings/app-passwords/
# Permissões mínimas: Repositories → Read
export BITBUCKET_USER=<seu-usuário>
export BITBUCKET_APP_PASSWORD=<app-password>
./scripts/narvi-discover-allies.sh
```

## Montar harness num projeto

```bash
# 1. Copie o template de convenções
cp agents/narvi/templates/AGENTS.md <seu-projeto>/AGENTS.md

# 2. Copie a memória de sessão
cp agents/narvi/templates/progress.md <seu-projeto>/progress.md

# 3. Copie e ative o bootstrap
cp agents/narvi/templates/bootstrap.sh <seu-projeto>/scripts/agent-bootstrap.sh
chmod +x <seu-projeto>/scripts/agent-bootstrap.sh

# 4. Copie o script de discovery
cp agents/narvi/scripts/narvi-discover-allies.sh <seu-projeto>/scripts/
chmod +x <seu-projeto>/scripts/narvi-discover-allies.sh
```

Edite `AGENTS.md` com as convenções reais do projeto antes da próxima sessão.

## Integração com Gandalf

Narvi é referenciado no `routing-map.md` do Gandalf com o sinal `SIGNAL_CRAFT_FORGE`.

Quando Gandalf recebe uma quest cross-sistema:
1. Emite `SIGNAL_CRAFT_FORGE`
2. Narvi roda `narvi-discover-allies.sh`
3. Narvi reporta o mapa de alianças
4. Gandalf decide o impacto e roteia pro agent correto

## Leis do Narvi

- **Harness probe sempre primeiro.** Sem mapa do terreno, sem forja.
- **TDD não-negociável.** O teste é a senha da porta.
- **Sensor externo julga.** Exit code, não auto-juízo.
- **Cirurgia, não renovação.** Cada linha alterada rastreia ao pedido.
- **Forja antes de deprecar.** Nunca remova contrato sem saber quem usa.
