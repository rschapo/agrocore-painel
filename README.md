# Painel AgroCore — Mercado · Macro · Grãos · Proteínas

Pacote para PUBLICAR o painel online e mantê-lo atualizado a partir do Claude Code.

## Conteúdo
- `index.html` — o painel completo (autocontido: HTML + CSS + gráficos + logo em base64). **Fonte única de verdade.**
- `logo-agrocore.png` — arte-fonte do logo.
- `deploy.sh` — publicação no Netlify.
- `rotina-diaria.md` — prompt da rotina diária, pronto para o Claude Code.

## Abas do painel (11)
Visão geral · Câmbio & Juros · Bolsas · Commodities · Gráficos · **Grãos** (soja, milho, arroz, café; média Brasil; por UF/praça-cidade via Agrolink) · **Proteínas** (boi, frango, suíno por praça SC/PR/RS/SP/MG, ovos, leite/lácteos + GDT; margem/relação de troca; exportação; sanitário) · Briefing (por impacto empresarial) · Notícias · Alertas · Fontes.

## IMPORTANTE — fonte única (evitar duas versões)
- Enquanto você usa o **Cowork**, quem atualiza o painel é a tarefa diária do Cowork (o artifact "painel-mercado"). Este `index.html` é uma cópia fiel do estado atual.
- Ao migrar para o **Claude Code + deploy online**, o Code passa a ser o ÚNICO dono: ele atualiza este `index.html` e publica. Nesse momento, **desative a tarefa diária do Cowork** (peça ao assistente do Cowork, ou remova em Scheduled) para não haver duas rotinas mexendo em paralelo.
- Regra do logo: nunca troque o bloco `<header>`/logo; só atualize a data em "Atualizado em ...".

## Pré-requisitos (uma vez)
1. Node.js (https://nodejs.org).
2. Conta gratuita no Netlify (https://www.netlify.com).
3. `npm install -g netlify-cli` e `netlify login`.

## Publicar (primeira vez)
Dentro desta pasta:
```bash
netlify deploy --prod --dir=.
```
Confirme a criação do site; ao final aparece a URL pública (ex.: `agrocore-painel.netlify.app`). Renomeie o subdomínio em Site configuration se quiser.

## Republicar após atualizar
```bash
./deploy.sh
```

## Atualização automática diária (Code como dono único)
Agende (cron no Linux/Mac; Agendador de Tarefas no Windows) dias úteis às 7h:
```bash
0 7 * * 1-5  cd /caminho/AgroCore-Painel && claude -p "$(cat rotina-diaria.md)" && ./deploy.sh
```
- A máquina precisa estar ligada no horário (ou use GitHub Actions — peça e eu incluo o workflow).
- A rotina edita `index.html` (dados, datas, séries dos gráficos) e o `deploy.sh` republica.

## Fontes por bloco
CEPEA (preços de proteínas e grãos) · Agrolink (grãos por praça/cidade, referencial) · B3 (futuros) · Comex Stat/AgroStat (exportação) · BCB/PTAX (câmbio) · IBGE/SIDRA (inflação, produção física) · Conab (safra) · USDA/WASDE (global) · GDT (lácteos) · MAPA/ABPA (sanitário).

## Metodologia / avisos
Não inventar: dados não confirmados ficam "a confirmar/n/d". Projeções e relações de troca são derivadas. Agrolink é referencial (não auditado); CEPEA é indicador oficial. Conteúdo informativo, não é recomendação de investimento.

## Deploy automático na nuvem (GitHub Actions)
Dois workflows já incluídos em `.github/workflows/`:
- `deploy.yml` — publica no Netlify a cada push na `main` (ou manualmente em Actions → Run workflow). **Confiável, é o núcleo.**
- `daily-update.yml` — dias úteis às 07:00 BRT: atualiza o `index.html` com o Claude Code, faz commit e publica. **Avançado/opcional** (depende de acesso a web/fontes no runner).

### Como ativar
1. Suba esta pasta para um repositório no GitHub (branch `main`) e habilite Actions.
2. Em GitHub → Settings → Secrets and variables → Actions → New repository secret, cadastre:
   - `NETLIFY_AUTH_TOKEN` — Netlify → User settings → Applications → Personal access tokens → New token.
   - `NETLIFY_SITE_ID` — Netlify → Site → Site configuration → General → Site details → **API ID** (ou o campo `siteId` em `.netlify/state.json`).
   - `ANTHROPIC_API_KEY` — console.anthropic.com (necessário só para o `daily-update.yml`).
3. Pronto: o `deploy.yml` publica a cada push; o `daily-update.yml` roda sozinho nos dias úteis.

Observação: com o deploy diário no GitHub Actions rodando, o Code/CI é o dono do processo — **desative a tarefa diária do Cowork** para não haver duas rotinas atualizando em paralelo.
