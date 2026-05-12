# progress.md (template)

> **Memória persistente entre sessões.** Atualize antes de fechar a sessão.
> Sem isso, próxima sessão começa do zero.

> Owner: o time. Atualização: a cada sessão que mexer no projeto.

---

## Estado atual

**Sprint:** [N]
**Branch:** `feature/...`
**Última atualização:** YYYY-MM-DD HH:MM
**Quem trabalhou na última sessão:** [pessoa + agente, se aplicável]

## Sprint atual — [nome]

**Objetivo:** [1-2 frases sobre o que essa sprint entrega]

**Contrato:** `.harness/contracts/sprint-N.md`

### Tasks

- [x] [task 1] — concluída em YYYY-MM-DD
- [ ] [task 2] — **em andamento** ([quem], desde YYYY-MM-DD)
- [ ] [task 3]

### Decisões da última sessão

- [Decisão tomada + 1 linha de razão]

### Issues conhecidas

- [Issue aberta / TODO sabido]

## Próximo passo (se a sessão for interrompida)

> **Se outra pessoa pegar o projeto agora, ela faz isto.**

[Frase curta e específica. Ex.: "Implementar o handler de POST /signup em src/auth/handlers/signup.ts, seguindo o padrão de src/auth/handlers/login.ts. Teste em tests/integration/auth/signup.test.ts já existe e está vermelho."]

## Alianças mapeadas (última Forja)

> Atualizado por `./scripts/narvi-discover-allies.sh`.

- **[servico-a]:** referencia em package.json como dependência
- **[servico-b]:** chama endpoint POST /api/v1/... (visto em docker-compose.yml)

## Sprints anteriores (resumo)

### Sprint N-1 — [nome] — concluída YYYY-MM-DD

**Entregue:**
- [resumo em bullets]

**Aprendizado:**
- [o que ficou pra próxima]

---

## Log de sessões (últimas 5)

### Sessão YYYY-MM-DD HH:MM — [pessoa]

- **Trabalhou em:** [task]
- **Concluiu:** [o que]
- **Próximo:** [o que]
- **Decisões:** [se houver]
- **Alianças mapeadas:** [repos descobertos, se rodou narvi-discover-allies]

---

## Como atualizar

Antes de fechar a sessão:
1. Atualize **Estado atual** (data, quem).
2. Marque tasks com `[x]` e data.
3. Escreva **Próximo passo** pra que a próxima sessão comece sem fricção.
4. Adicione entrada no **Log de sessões**.
5. Se rodou narvi-discover-allies.sh, atualize **Alianças mapeadas**.
