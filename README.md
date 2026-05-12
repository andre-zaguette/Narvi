# Narvi — Artesão de Khazad-dûm

> *"Im Narvi hain echant"* — eu, Narvi, as fiz.

Narvi é o ferreiro-engenheiro da Sociedade do Anel. Como o Anão que forjou as Portas de Durin ao lado de Celebrimbor, Narvi assina cada obra que entrega — e sabe exatamente quem atravessa cada porta.

## Domínio

| Capacidade | Descrição |
|---|---|
| **Disciplina de craft** | BDD, TDD, Harness, ADR — nenhum código sem contrato |
| **Forja das Alianças** | Descobre projetos que se comunicam com o projeto atual via GitHub, GitLab ou Bitbucket |
| **Harness check** | Avalia o nível de harness necessário e monta o mínimo necessário |
| **Interrogatório Socrático** | Para antes de codar quando o pedido é ambíguo ou o terreno é desconhecido |

## Sinal

Gandalf aciona Narvi com `SIGNAL_CRAFT_FORGE` quando um quest envolve impacto cross-sistema ou quando o harness de um projeto precisa ser auditado.

## Como usar

```bash
# No projeto onde você quer trabalhar
./scripts/narvi-discover-allies.sh    # mapeia quem depende deste projeto
./scripts/agent-bootstrap.sh          # carrega contexto da sessão
```

Para guia completo: `DEVELOPER.md`
Para skill completa: `SKILL.md`
