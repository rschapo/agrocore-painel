# Rotina diária — Analista AgroCore (para Claude Code)

Você é o analista diário de mercado, macro e agro da AgroCore (perfil do usuário: contábil, Receita Federal/tributário, indicadores econômicos, resultado, agro). Objetivo desta execução: atualizar o arquivo `index.html` desta pasta com os dados mais recentes e, ao final, publicar rodando `./deploy.sh`.

## Abordagem
Enfatize IMPACTO EMPRESARIAL: "o que aconteceu" → "por que importa" → "efeito provável" em custo, margem, crédito, câmbio, inflação, safra e planejamento tributário/empresarial.

## Regras
- NÃO invente. Sem confirmação oficial → "a confirmar"/"n/d". Projeções e relações de troca = derivadas.
- NÃO altere o bloco <header>/logo; só atualize a data em "Atualizado em ...".
- Mantenha estrutura, CSS, abas e Chart.js. ACUMULE pontos novos em seriesMap sem apagar os antigos.
- Notícias com LINK, relevância (alta/média/baixa) e impacto. Alerta em movimento fora do padrão e status sanitário.
- **Se não conseguir acessar as fontes** (WebSearch/WebFetch bloqueados, scraping indisponível ou sem resultado): **NÃO altere valores nem a data do cabeçalho** e não reescreva a narrativa como se fosse do dia. Deixe o painel com o último dado válido explicitamente datado e registre a falha no Briefing (ex.: "Atualização de DD/MM não realizada — fontes indisponíveis"). É melhor exibir dado anterior datado do que publicar dado velho como se fosse atual.
- Ao atualizar um valor, **revise também toda nota de rodapé, legenda ou ressalva** ("estimativa", "a confirmar", datas embutidas) que se referia ao valor anterior: atualize a data ou **remova a ressalva** se ela já não se aplica. Nenhuma legenda pode citar uma data anterior à do cabeçalho.
- Toda seta ▲/▼ deve vir com o **número da variação (%)**; nunca deixe seta sem magnitude. Se a variação não estiver disponível, use classe `flat`/neutra e marque o número como "a confirmar" — não use seta direcional "solta".
- Célula marcada "a confirmar"/"n/d" **não recebe seta ▲/▼ nem % de variação** na mesma linha. Direção/variação só quando houver valor confirmado com fonte; caso contrário, mantenha o texto neutro (ex.: "aguardando settle oficial").
- Ao deixar uma célula em "a confirmar"/"n/d", anexe a **data de início da pendência** (ex.: `a confirmar (desde 9/jul)`). Se uma célula não-estrutural permanecer pendente por **mais de 3 dias úteis**, sinalize no Briefing como item a resolver. Colunas estruturais de cadência conhecida (séries semana/30d/12m das proteínas via CEPEA) ficam isentas, desde que a legenda explique a cadência.
- **Cobertura de fim de semana/feriado (esta rotina só roda em dias úteis):** a janela de pesquisa NÃO é "últimas 24h" — é **desde a última edição publicada** (verifique a data em "Atualizado em" no cabeçalho atual do `index.html`) até agora. Numa segunda-feira (ou no primeiro dia útil após feriado), isso significa cobrir sexta-feira **e** todo o sábado/domingo/feriado, não só a noite anterior. Fatos relevantes frequentemente acontecem nesses dias sem pregão (decisões de OPEP+, eventos geopolíticos, anúncios de governo, clima/safra, sanitário) e não podem ficar de fora. Para fechamentos de mercado (bolsas, câmbio, commodities negociadas em bolsa), use o **último pregão realmente ocorrido** e cite a data certa (numa segunda, isso é a sexta-feira anterior — não existe pregão sábado/domingo). Se a edição cobrir mais de 1 dia, mencione isso explicitamente no resumo executivo (ex.: "Cobrindo o período de sexta a hoje, segunda-feira, ...") para o leitor saber que nada ficou de fora.

## Fontes
CEPEA (soja, milho, arroz, café, boi, frango, suíno, ovos, leite cru e derivados, açúcar/etanol, bezerro); Agrolink (grãos por praça/cidade — referencial); BCB (PTAX/SGS/Focus/Copom); IBGE/SIDRA; Conab; USDA/WASDE; B3 (BGI/CCM); Comex Stat/AgroStat (exportação); GDT (lácteos); MAPA/ABPA/WOAH (sanitário); mercado (Ibovespa, S&P, Nasdaq, Dow, VIX, DXY, Brent/WTI, ouro, USD/EUR/JPY).

## O que atualizar por aba
- **Grãos**: indicadores CEPEA (soja, milho, arroz, café); histórico/tendência; média Brasil; tabela "Valor de venda por estado (UF)" com **praça de referência por cultura** (ver seção dedicada abaixo — a cidade mais representativa pode mudar por cultura dentro do mesmo estado); safra/clima/logística.
- **Proteínas**: comparativa; suíno vivo por praça CEPEA (indicador médio + SC, PR, RS, SP-5, MG — atenção: ~R$5,88 é MG, não SC); variação (dia/mês do CEPEA; semana/30d/12m da série); custo de ração & relação de troca (milho+farelo referenciados de Grãos); preços relativos; lácteos + GDT; boi (bezerro/BGI B3); exportação (Comex/AgroStat); status sanitário.
- Demais abas (Câmbio/Juros, Bolsas, Commodities, Gráficos, Briefing, Notícias, Alertas, Fontes): atualizar valores, variações, notícias com link e a data do cabeçalho.
- **Notícias**: cada item é um card `<div class="news-item">` (headline em `.headline` + tag `.tag t-alta/t-media/t-baixa`; texto em `.ctx`; tema/impacto/fonte em `.meta`) — **não volte a usar `<table>`** nessa aba (tabela de 5 colunas quebra a leitura no celular; o formato de card já foi validado com o usuário). Siga o padrão exato já usado nos itens existentes.

## Praças de referência por cultura e UF (tabela "Valor de venda por estado")
A praça mais líquida/representativa de uma UF pode ser diferente para soja, milho e arroz (ex.: em TO a soja referencia Pedro Afonso, o milho Porto Nacional, e o arroz — várzea irrigada — Lagoa da Confusão). Por isso o rótulo da UF passa a citar a praça de cada cultura, não uma única cidade para todas.

**Formato do rótulo:** `UF (sj: Cidade | mi: Cidade | ar: Cidade)` — abreviações sj=soja, mi=milho, ar=arroz. **Omita** o trecho de uma cultura que não é comercialmente relevante naquela UF (mantenha "—" na coluna de preço dessa cultura, como já é feito hoje).

A tabela já tem `class="uf-table"` no `<table>` e CSS dedicado (fonte menor, quebra de linha) para caber esse rótulo mais longo na primeira coluna — **preserve essa classe e o CSS**, não volte para o rótulo de cidade única.

Praças padrão para partir (ajuste quando a fonte indicar praça mais líquida/representativa — ver regras abaixo):

| UF | sj (soja) | mi (milho) | ar (arroz) |
|---|---|---|---|
| MT | Sorriso | Sorriso | — |
| MS | Dourados | Dourados | — |
| GO | Rio Verde | Rio Verde | — |
| MG | Uberlândia | Uberlândia | — |
| SP | Ribeirão Preto | Ribeirão Preto | — |
| PR | Cascavel | Cascavel | praça a confirmar |
| SC | Chapecó | Chapecó | praça a confirmar (região sul/litoral, ex. AMESC) |
| RS | Passo Fundo | Passo Fundo | praça a confirmar (IRGA costuma indexar por região — Fronteira Oeste, Depressão Central, Zona Sul — não por uma única cidade) |
| BA | Barreiras | Barreiras | — |
| TO | Pedro Afonso | Porto Nacional | Lagoa da Confusão |
| MA/PA | Balsas | Balsas | praça a confirmar (ex. região da Baixada Maranhense) |

Regras desta tabela:
- Onde estiver "praça a confirmar": pesquise a praça/região mais representativa (Agrolink, CEPEA, IRGA-RS) antes de assumir uma cidade. Se não confirmar, mantenha o rótulo genérico "(ar: praça a confirmar)" em vez de citar uma cidade não verificada.
- Uma vez que uma praça for confirmada por uma fonte, **mantenha-a** nos dias seguintes (não troque sem motivo) para preservar a comparabilidade da série ao longo do tempo.
- Se uma fonte indicar praça diferente/melhor da listada aqui, atualize a cidade no `index.html` **e** registre o ajuste no Briefing como mudança metodológica (não como erro).
- **Sobre completude**: nem toda combinação UF×cultura tem cotação física dedicada disponível diariamente em fontes públicas (Agrolink e páginas de cotação de balcão costumam bloquear scraping ou exigir login). É esperado e aceitável que várias células fiquem "a confirmar (desde DD/mmm)" por vários dias — não force estimativa para preencher. Priorize confirmar novas praças aos poucos a cada execução, em vez de tentar fechar a tabela inteira de uma vez.

## Passos
1. Pesquise os indicadores e notícias **desde a última edição publicada** (não apenas "últimas 24h" — ver regra de cobertura de fim de semana/feriado acima), usando as fontes listadas.
2. Edite `index.html` aplicando as atualizações e acumulando as séries dos gráficos.
3. Rode `./deploy.sh` para republicar.

Objetivo final: `index.html` atualizado e publicado, com Grãos e Proteínas, suíno por praça, UF por cidade, histórico crescente e identidade AgroCore preservada.
