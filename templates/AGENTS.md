# AGENTS.md (template)

> Este arquivo é **vivo**. Atualize quando o time aprender algo novo. Mantenha curto e útil. Arquivos longos demais ninguém lê — nem o time, nem o agente.

> Owner deste arquivo: **[nome / papel]**. Última atualização: **YYYY-MM-DD**.

---

## Sobre este projeto

[2-3 frases: o que é, pra quem, qual a coisa mais importante saber.]

## Stack

- **Linguagem:** [versão]
- **Framework:** [versão]
- **Database:** [versão]
- **Test runner:** [comando]
- **Linter:** [comando]
- **Type checker:** [comando]
- **Outros:** [só o relevante]

## Comandos comuns

```bash
# Setup
[comando de setup]

# Rodar local
[comando de dev]

# Testar
[comando de teste]

# Lint + types
[comandos de qualidade]

# Build
[comando de build]
```

## Convenções

### Nome de arquivos
- [Padrão usado no projeto]

### Estrutura de pastas
- [Onde vai cada coisa]

### Estilo de código
- [Particularidades do time, além do que o linter força]

### Padrões de teste
- [Onde testes vivem, padrão de nome, etc.]

### Padrões de commit
- [Formato adotado: conventional commits, etc.]

## Armadilhas conhecidas

> Coisas que **já mordemos** e queremos que o agente saiba.

- **[Armadilha 1]:** [descrição curta + o que fazer no lugar].
- **[Armadilha 2]:** [...]

## Decisões importantes (resumido)

> Pra contexto rápido. Decisões grandes têm ADR em `docs/adrs/`.

- **Por que [X] em vez de [Y]:** [1 linha de razão]
- **[Outra decisão notável]**

## O que NÃO fazer

- [Padrão que parece bom mas não usamos — e por quê]
- [Lib que parece útil mas evitamos — e por quê]

## Alianças externas (projetos que se comunicam com este)

> Gerado e atualizado por `./scripts/narvi-discover-allies.sh`.
> Atualize manualmente se o script não cobrir algum aliado conhecido.

- **[servico-a]:** [como se comunica — ex.: consome endpoint POST /auth]
- **[servico-b]:** [como se comunica — ex.: importa como dependência npm]

## Onde achar mais

- **Roadmap atual:** `progress.md`
- **Decisões arquiteturais:** `docs/adrs/`
- **Contratos da sprint:** `.harness/contracts/`

## Para o agente

- Sempre comece a sessão rodando `./scripts/agent-bootstrap.sh`.
- Atualize o `progress.md` antes de fechar a sessão.
- Se não conseguir entender uma convenção, **pergunte** em vez de inventar.
- Aplique as convenções acima rigorosamente em código novo.
- Para mudanças que parecem violar este arquivo: pare, escreva justificativa, espere humano aprovar.
