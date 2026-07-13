# Changelog — Painel Diário AgroCore

Registro cronológico das mudanças **de engenharia/processo** neste projeto (workflows, regras da
rotina, estrutura/layout do painel, decisões de escopo). **Não** registra as atualizações diárias
de conteúdo em si (preços, notícias do dia) — essas já ficam no histórico de commits do
`agrocore-bot` e são renovadas todo dia útil; aqui só entra o que muda **como** o painel é mantido.

Formato de cada entrada: data, o que mudou, por quê (quando não for óbvio), commit(s) relacionado(s).
Para o "porquê" em prosa mais longa, ver o histórico completo em
`Claude\Projects\AgroCore (Corporativo)\09 - Painel Diario (Mercado, Macro e Agro)\05 - Historico de Decisoes\`.

> **Como manter este arquivo:** toda vez que uma mudança de engenharia/processo for feita (novo
> workflow, nova regra em `rotina-diaria.md`, mudança de layout, mudança de escopo), adicionar uma
> entrada nova no topo (mais recente primeiro), no mesmo commit que faz a mudança.

---

## 2026-07-13 — 3ª tentativa de disparo automático (05:42/07:38/08:47 BRT)

A pedido do usuário, ampliado de 2 para **3 tentativas diárias** de disparo automático:
`05:42`, `07:38` e `08:47` BRT (`08:42`, `10:38`, `11:47` UTC) — nenhuma no topo da hora. O guard
que já existia (pula se já houver commit do `agrocore-bot` datado de hoje) cobre as 3 tentativas
igualmente, então dias normais continuam gastando crédito de API só uma vez, mesmo com mais
horários configurados.
Commit: ver `.github/workflows/daily-update.yml`.

## 2026-07-13 — Cron de reserva no daily-update (2ª falha de disparo do schedule)

O `schedule` não disparou de novo (2ª vez — a 1ª foi em 10/07), mesmo com o cron já deslocado do
topo da hora. Investigado: workflow YAML íntegro, workflow "active", sem incidente óbvio no
GitHub Status. Conclusão: o gatilho `schedule` do GitHub Actions é mais instável do que o esperado
mesmo fora do topo da hora — offset sozinho não resolve. Corrigido com um **segundo horário de
disparo** (`38 10 * * 1-5` = 07:38 BRT, ~1h30 depois do principal) como reserva, mais um passo
"guard" que verifica se já existe commit do `agrocore-bot` datado de hoje: se sim, pula o resto do
job (evita rodar/gastar crédito em dobro num dia em que os dois cronjobs dispararem). O guard só
vale para o evento `schedule` — disparo manual (`workflow_dispatch`) sempre roda, mesmo que já
tenha rodado hoje. Corrigido painel do dia via disparo manual.
Commit: ver `.github/workflows/daily-update.yml`.

## 2026-07-12 — Cobertura de fim de semana/feriado na janela de pesquisa

A instrução original dizia "pesquise as últimas 24h", o que numa segunda-feira (ou 1º dia útil
após feriado) cobriria só a madrugada anterior — perdendo o pregão de sexta e qualquer fato
relevante de sábado/domingo (decisões de OPEP+ de fim de semana, geopolítica, clima/safra,
sanitário). Levantado pelo usuário antes da primeira segunda-feira real desta automação (o
pipeline só existe desde 09/07, uma quinta-feira). Regra reescrita: a janela agora é "desde a
última edição publicada" (verificando a data em "Atualizado em" no cabeçalho), com instrução
explícita de cobrir o fim de semana/feriado inteiro e usar a data certa do último pregão realmente
ocorrido.

**Validado em 13/07** (primeira segunda-feira real): o cabeçalho e o resumo executivo cobriram
corretamente "sexta (10/jul) a hoje, segunda-feira (13/jul)", usando o fechamento de sexta como
último pregão e trazendo fatos do fim de semana que teriam passado batido (WASDE de 10/jul, ameaça
de tarifa dos EUA sobre o Brasil com decisão esperada por volta de 15/jul).

## 2026-07-12 — Notícias: tabela → cards (mobile-first)

A tabela de 5 colunas da aba Notícias dificultava a leitura no celular. Reaproveitada a classe CSS
`.news-item` (existia, sem uso) no mesmo estilo de card já validado em Alertas/Briefing. Aplicado
também nas tabelas menores da aba (Maquinário, Top 5 temas). `rotina-diaria.md` atualizado para
manter esse formato dali em diante.
Commit: `0d47d59`

## 2026-07-10 — Tabela de UF: praça de referência por cultura

A praça mais representativa pode variar por cultura dentro do mesmo estado (ex.: TO — soja em
Pedro Afonso, milho em Porto Nacional, arroz em Lagoa da Confusão). Novo rótulo
`UF (sj: Cidade | mi: Cidade | ar: Cidade)` + CSS dedicado (`.uf-table`) + seção nova em
`rotina-diaria.md` com praças-padrão e regra de estabilidade. Diagnosticado que a maioria das
células fica "a confirmar" por bloqueio de scraping do Agrolink (limitação de fonte, não bug).
Commit: `68cfd5e`

## 2026-07-10 — Push concorrente derrubou um commit da rotina diária

Um push manual (ajuste de cron) coincidiu com o `git push` final de uma execução do
`daily-update.yml`, que falhou (non-fast-forward) e foi mascarado por `|| true` — o site publicou
certo, mas o commit não chegou ao repositório. Recuperado manualmente; workflow passou a tentar
rebase + retry automático e, se falhar mesmo assim, abre uma Issue de alerta.
Commits: `338101a`, `4e1d3e6`

## 2026-07-10 — Cron do daily-update: 07:07 → 06:08 BRT

Ajuste a pedido do usuário (cobre os fechamentos do dia anterior com folga e fica fora do horário
comercial de uso do Claude). Mesmo ajuste replicado no `weekly-review.yml`.
Commit: `338101a`

## 2026-07-10 — Descoberto: `schedule` do GitHub Actions não disparou

O cron original (`0 10 * * 1-5`, exatamente no topo da hora) não disparou em 10/07 — nenhum run
apareceu no horário esperado. Causa provável: o gatilho `schedule` do GitHub Actions é
*best-effort* (documentado pelo próprio GitHub) e horários exatos de hora cheia são os mais
congestionados. Crons deslocados para fora do `:00` (`daily-update` em `:08`, `weekly-review` em
`:12`) como mitigação parcial — **não elimina o risco, só reduz**.
Commit: `fc4fd0d`

## 2026-07-09 — PDCA semanal criado (`weekly-review.yml`)

Novo workflow (segundas, inicialmente 08:00 BRT): revisa os commits/logs da semana e abre uma
Issue com relatório Check/Act. Não edita nenhum arquivo sozinho — decisão de aplicar sugestões é
sempre humana. Primeira execução (Issue #1) já achou uma falha real mascarada (ver abaixo).
Commit: `e0dfaea`

## 2026-07-09 — Corrigida falha silenciosa no daily-update (Issue #1 do PDCA)

O `daily-update.yml` marcava sucesso mesmo quando o passo do Claude não fazia nenhuma alteração
(por falta de permissão de WebSearch/WebFetch, corrigido no mesmo dia — ver abaixo). Adicionada
checagem de `git status --porcelain -- index.html`: se nada mudou, é tratado como falha (não como
"dia sem novidade") e abre uma Issue de alerta. Também incorporadas 5 regras sugeridas pelo PDCA em
`rotina-diaria.md` (não fingir atualização com fontes indisponíveis, revisar ressalvas órfãs, seta
sempre com magnitude, "a confirmar" nunca leva seta/variação, rastrear idade de placeholders).
Commit: `e4b273d`

## 2026-07-09 — Migração para fonte única: Git + GitHub + GitHub Actions

Projeto migrado de arquivo local + publicação manual para: repositório GitHub
(`rschapo/agrocore-painel`, público) + 2 workflows (`deploy.yml`, `daily-update.yml`) + secrets
(`NETLIFY_AUTH_TOKEN`, `NETLIFY_SITE_ID`, `ANTHROPIC_API_KEY`). Tarefa agendada local (Claude Code)
desativada para não haver duas rotinas concorrentes. Três bugs encontrados e corrigidos no processo:
`GITHUB_TOKEN` só-leitura bloqueando commit, `claude -p` sem permissão de rede (`--allowedTools`
ausente), e um erro de indentação YAML introduzido e corrigido na mesma sessão.
Commits: `d32a30c`, `dfd9ead`, `d49b447`, `bb1aff7`

## 2026-07-07 — Entrega inicial e primeira publicação manual

Pacote inicial (`index.html`, `deploy.sh`, `rotina-diaria.md`, `README.md`) recebido de uma sessão
anterior do Claude Cowork. Primeira publicação manual no Netlify (site `velvety-torrone-71a5ac`
criado). Node.js e Netlify CLI instalados via `winget`.
