Você é meu assistente de engenharia. Trabalhe na pasta atual: o projeto "AgroCore-Painel", um painel diário de mercado, macro e agro (arquivo `index.html`, autocontido — HTML + CSS + Chart.js + logo em base64). Objetivo: publicar este painel online no Netlify e configurar o deploy automático diário via GitHub Actions, mantendo UMA única versão (sem duplicar).

CONTEXTO DA PASTA
- `index.html` — o painel completo e autocontido (fonte única de verdade). Tem 11 abas: Visão geral, Câmbio & Juros, Bolsas, Commodities, Gráficos, Grãos, Proteínas, Briefing, Notícias, Alertas, Fontes.
- `logo-agrocore.png` — arte-fonte do logo (o logo já está embutido em base64 no index.html).
- `deploy.sh` — publica no Netlify (`netlify deploy --prod --dir=.`).
- `rotina-diaria.md` — o prompt da rotina diária de atualização do painel (dados de CEPEA, Agrolink, BCB, IBGE, Conab, B3, Comex Stat, GDT, MAPA/ABPA).
- `.github/workflows/deploy.yml` — publica a cada push na main (núcleo confiável).
- `.github/workflows/daily-update.yml` — dias úteis 07:00 BRT (10:00 UTC): atualiza o index.html com o Claude Code, faz commit e publica (avançado/opcional).
- `.netlify/state.json` — o site Netlify já está vinculado. Site ID: 8b74da47-1374-45b5-b184-ff2abff582fc.

O QUE FAZER (passo a passo)
1. Verifique se é um repositório git; se não, inicialize (`git init`, branch `main`) e faça o primeiro commit de tudo.
2. Crie um repositório no GitHub e faça push (use `gh repo create` se o GitHub CLI estiver disponível; senão, me diga os comandos exatos para eu criar o remote e dar push). Não suba segredos — confira que só `.netlify/state.json` (contém apenas o siteId, não é segredo) e os arquivos do projeto vão para o repo.
3. Publique manualmente uma vez para validar: `./deploy.sh` (ou `netlify deploy --prod --dir=.`). O site já está vinculado; se pedir login, me avise. Ao final, me devolva a URL pública.
4. Confirme que os dois workflows em `.github/workflows/` estão corretos e habilite o GitHub Actions no repo.
5. Liste para mim, de forma clara, os secrets que eu preciso cadastrar em GitHub → Settings → Secrets and variables → Actions:
   - `NETLIFY_AUTH_TOKEN` — personal access token do Netlify (User settings → Applications).
   - `NETLIFY_SITE_ID` — 8b74da47-1374-45b5-b184-ff2abff582fc
   - `ANTHROPIC_API_KEY` — necessário só para o daily-update.yml.
6. Depois de tudo, faça um push de teste e confirme que o `deploy.yml` publicou (mostre o log/resultado).

REGRAS IMPORTANTES
- NÃO altere o bloco `<header>` nem o logo do index.html; em atualizações de dados, mude apenas os valores, textos, notícias e a data em "Atualizado em ...".
- Ao atualizar dados, siga o `rotina-diaria.md` e a regra de NÃO inventar: dados sem confirmação da fonte oficial ficam como "a confirmar/n/d". Projeções e relações de troca são derivadas (interpretação). Agrolink é referencial (não auditado); CEPEA é indicador oficial.
- FONTE ÚNICA: a partir de agora, este repositório/deploy é o dono do painel. (Eu vou desativar a tarefa diária que roda no Cowork para não haver duas versões.)
- Preserve estrutura, CSS, abas e o Chart.js; nas séries dos gráficos (seriesMap), acumule pontos novos sem apagar os antigos.

Comece pelo passo 1 e me pergunte só o que for imprescindível (ex.: nome do repositório, público/privado). Prossiga com o resto sozinho.
