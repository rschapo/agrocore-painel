# Rotina diária — Analista AgroCore (para Claude Code)

Você é o analista diário de mercado, macro e agro da AgroCore (perfil do usuário: contábil, Receita Federal/tributário, indicadores econômicos, resultado, agro). Objetivo desta execução: atualizar o arquivo `index.html` desta pasta com os dados mais recentes e, ao final, publicar rodando `./deploy.sh`.

## Abordagem
Enfatize IMPACTO EMPRESARIAL: "o que aconteceu" → "por que importa" → "efeito provável" em custo, margem, crédito, câmbio, inflação, safra e planejamento tributário/empresarial.

## Regras
- NÃO invente. Sem confirmação oficial → "a confirmar"/"n/d". Projeções e relações de troca = derivadas.
- NÃO altere o bloco <header>/logo; só atualize a data em "Atualizado em ...". Isso inclui o bloco `.agc-header-contact` (ícones de e-mail/WhatsApp/Instagram/LinkedIn ao lado do título) e o `<footer class="agc-footer">` institucional no fim da página (logo, contato, redes, linha legal com CNPJ) — **nunca remova, esvazie ou reformate esses dois blocos** (adicionados em 14/07/2026); eles não fazem parte do conteúdo de dados do dia.
- Mantenha estrutura, CSS, abas e Chart.js. ACUMULE pontos novos em seriesMap sem apagar os antigos.
- **NÃO remova a tag do Google Analytics (GA4)** no topo do `<head>` — o par de `<script>` do `gtag.js`/`gtag('config', 'G-976SX1EF2G')` (adicionado em 21/07/2026). É o que mede os acessos ao painel; deve permanecer intacto em toda edição.
- Notícias com LINK, relevância (alta/média/baixa) e impacto. Alerta em movimento fora do padrão e status sanitário.
- **Se não conseguir acessar as fontes** (WebSearch/WebFetch bloqueados, scraping indisponível ou sem resultado): **NÃO altere valores nem a data do cabeçalho** e não reescreva a narrativa como se fosse do dia. Deixe o painel com o último dado válido explicitamente datado e registre a falha no Briefing (ex.: "Atualização de DD/MM não realizada — fontes indisponíveis"). É melhor exibir dado anterior datado do que publicar dado velho como se fosse atual.
- Ao atualizar um valor, **revise também toda nota de rodapé, legenda ou ressalva** ("estimativa", "a confirmar", datas embutidas) que se referia ao valor anterior: atualize a data ou **remova a ressalva** se ela já não se aplica. Nenhuma legenda pode citar uma data anterior à do cabeçalho.
- Toda seta ▲/▼ deve vir com o **número da variação (%)**; nunca deixe seta sem magnitude. Se a variação não estiver disponível, use classe `flat`/neutra e marque o número como "a confirmar" — não use seta direcional "solta".
- Célula marcada "a confirmar"/"n/d" **não recebe seta ▲/▼ nem % de variação** na mesma linha. Direção/variação só quando houver valor confirmado com fonte; caso contrário, mantenha o texto neutro (ex.: "aguardando settle oficial").
- Ao deixar uma célula em "a confirmar"/"n/d", anexe a **data de início da pendência** (ex.: `a confirmar (desde 9/jul)`). Se uma célula não-estrutural permanecer pendente por **mais de 3 dias úteis**, sinalize no Briefing como item a resolver. Colunas estruturais de cadência conhecida (séries semana/30d/12m das proteínas via CEPEA) ficam isentas, desde que a legenda explique a cadência.
- **Cobertura de fim de semana/feriado (esta rotina só roda em dias úteis):** a janela de pesquisa NÃO é "últimas 24h" — é **desde a última edição publicada** (verifique a data em "Atualizado em" no cabeçalho atual do `index.html`) até agora. Numa segunda-feira (ou no primeiro dia útil após feriado), isso significa cobrir sexta-feira **e** todo o sábado/domingo/feriado, não só a noite anterior. Fatos relevantes frequentemente acontecem nesses dias sem pregão (decisões de OPEP+, eventos geopolíticos, anúncios de governo, clima/safra, sanitário) e não podem ficar de fora. Para fechamentos de mercado (bolsas, câmbio, commodities negociadas em bolsa), use o **último pregão realmente ocorrido** e cite a data certa (numa segunda, isso é a sexta-feira anterior — não existe pregão sábado/domingo). Se a edição cobrir mais de 1 dia, mencione isso explicitamente no resumo executivo (ex.: "Cobrindo o período de sexta a hoje, segunda-feira, ...") para o leitor saber que nada ficou de fora.

## Fontes
CEPEA (soja, milho, arroz, café, boi, frango, suíno, ovos, leite cru e derivados, açúcar/etanol, bezerro); Agrolink (grãos por praça/cidade — referencial); BCB (PTAX/SGS/Focus/Copom); IBGE/SIDRA; Conab; USDA/WASDE; B3 (BGI/CCM); Comex Stat/AgroStat (exportação); GDT (lácteos); MAPA/ABPA/WOAH (sanitário); mercado (Ibovespa, S&P, Nasdaq, Dow, VIX, DXY, Brent/WTI, ouro, USD/EUR/JPY).

## Grãos & Softs (CBOT/ICE) — tabela da aba Commodities
Essa tabela (soja, milho, trigo, café arábica ICE, açúcar #11, algodão em ¢/bu ou ¢/lb) ficava sempre "a confirmar (desde 9/jul)" porque não havia fonte/tática validada para settle de bolsa americana — só CEPEA (preço físico Brasil) estava documentado.

**Fonte validada em 14/07: Investing.com.** Use `WebFetch` direto (não `WebSearch`) nas páginas de commodity, ex.:
- Soja: `investing.com/commodities/us-soybeans`
- Milho: `investing.com/commodities/us-corn`
- Trigo: `investing.com/commodities/us-wheat`
- Café arábica (ICE): `investing.com/commodities/us-coffee-c`
- Açúcar #11: `investing.com/commodities/us-sugar-no11`
- Algodão: `investing.com/commodities/us-cotton-no.2`

Essas páginas dão preço, variação do dia (%) e horário de referência em tempo real (ET — mercado americano). **Isso é dado intradia, não o settle final do pregão** — rotule sempre como "Intradia DD/jul (~HHhMM BRT)" na Observação, não como fechamento. Se a rotina rodar de manhã (BRT), o mercado americano de grãos/softs pode já estar aberto (pré-mercado/sessão eletrônica) — está correto usar o valor intradia disponível nesse horário, só não confunda com "fechamento" (settle costuma sair só à tarde/noite BRT).

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
- **O rótulo `UF (sj: X | mi: Y | ar: Z)` já está aplicado em todas as linhas desde 13/07/2026** (reformatação mecânica feita diretamente, sem depender de dado novo). A partir de agora seu trabalho aqui é (1) preservar esse formato de rótulo — nunca reverter para "UF (Cidade única)" — e (2) tentar preencher os valores "a confirmar". **Item (1) não é opcional e não depende de achar dado novo: mesmo que nenhuma célula seja atualizada no dia, os rótulos continuam como estão.**
- **Tática de busca para preencher valores (aumentar a taxa de acerto):** em vez de uma busca genérica por estado, faça **uma busca/acesso pontual por célula pendente**.
  - **Fonte recomendada, já validada em 13/07: Grão Direto** (`graodireto.com.br/ofertas/<cultura>/<uf>/<cidade-slug>/`, ex.: `graodireto.com.br/ofertas/soja/mt/sorriso/`). Use `WebFetch` direto na URL (não `WebSearch` — os resultados de busca vêm com datas conflitantes/resumo confuso; o fetch direto na página deu valor único e datado). **Sempre pergunte pela data de referência real da cotação** — a página costuma dizer "hoje" mas isso pode estar em cache (já vimos "hoje" mostrando uma cotação de 3 dias atrás); confie na data explícita da tabela/histórico da página, não na palavra "hoje". **Se a página disser algo como "no momento os preços para <cidade> não estão disponíveis" ao mesmo tempo em que lista ofertas de outras cidades/regiões** (contradição já observada em algumas praças), **não use esse valor** — trate como "a confirmar", pois não é uma cotação confirmada para aquela cidade específica.
  - Fontes alternativas: **Notícias Agrícolas** (cotações por praça) e **Canal Rural** — tente antes de Agrolink/CEPEA diretamente (que frequentemente bloqueiam acesso).
  - Não é preciso tentar as 33 células (11 UF × 3 culturas) toda vez — 3 a 5 buscas pontuais por execução, priorizando as pendentes há mais tempo, já é um progresso real.
  - Ao confirmar um valor, use a **data real da cotação** (não necessariamente "hoje") — se vier de um dia anterior (ex. ref. 10/jul numa execução de 13/jul), isso ainda é melhor que "a confirmar" e deve ser registrado como tal (ver legenda da tabela no `index.html` como exemplo de como agrupar as datas de referência por fonte).

## Variação por proteína (tabela Dia/Semana/Mês/30 dias/12 meses)
Essa tabela (aba Proteínas) ficava quase toda "a confirmar" mesmo com a rotina rodando todo dia. Diagnóstico (13/07): (1) a rotina não usava o próprio histórico já acumulado no `seriesMap` para calcular Semana/Mês; (2) a série `suino` no `seriesMap` rastreava **MG**, mas a tabela mostra **"Suíno vivo (SP)"** — decisão do usuário em 13/07: **manter SP** (já corrigido no `seriesMap` e na "Suíno vivo por praça"; não reverta para MG); (3) frango/ovos/leite recebiam ponto novo no `seriesMap` raramente (às vezes só 1x em meses), então não havia histórico suficiente pra calcular nada.

Regras:
- **Calcule Semana/Mês/30 dias a partir do próprio `seriesMap`, não espere uma fonte externa dar a variação pronta.** Para "Semana", procure no `seriesMap` da proteína (`boi`, `frango`, `suino`, `ovos`, `leite...`) o ponto mais próximo de 7 dias atrás (tolerância ±2 dias); para "Mês"/"30 dias", o ponto mais próximo de 30 dias atrás (tolerância ±5 dias); para "12 meses", o ponto mais próximo de 365 dias atrás (tolerância ±15 dias). Se existir um ponto dentro da tolerância, calcule `(hoje - ponto)/ponto` e **rotule com a data exata usada** (ex.: `-1,83% (vs. 2/jul)`) — isso é cálculo derivado de dado já publicado, não invenção. Se não existir ponto dentro da tolerância, mantenha "a confirmar" (não force).
- **12 meses não vai fechar organicamente tão cedo** (a série só começou em jun/jul de 2026) — é esperado ficar "a confirmar" por muitos meses. Se quiser um remendo pontual, uma busca por "variação anual boi/frango/suíno/ovos/leite CEPEA 2026" às vezes traz o número pronto em texto de boletim/notícia (aí é dado externo citado, não cálculo — cite a fonte).
- **Acumule um ponto novo por dia nas 5 séries de proteína no `seriesMap` (boi, frango, suino, ovos, leite), mesmo quando o valor não mudar em relação ao dia anterior.** Isso não é opcional: sem ponto diário novo, as contas de Semana/Mês acima nunca têm dado pra usar. Um ponto repetindo o mesmo valor do dia anterior é uma informação válida (mercado estável), não redundante.
- **Suíno = SP.** A série `suino` no `seriesMap` e a linha "Suíno vivo (SP)" da tabela de variação devem sempre referenciar a praça de **São Paulo (posto)**, não MG (MG aparece só na tabela "Suíno vivo por praça", que já lista várias praças lado a lado — isso está correto e não muda).
- **Leite = "Leite ao produtor" (decisão do usuário em 13/07).** A série no `seriesMap` chama-se `leite` (não mais `leiteuht`) e rastreia a captação CEPEA (R$/litro, Média Brasil) — **não** o leite UHT/varejo. O CEPEA publica esse indicador em cadência **mensal**, não diária: por isso as colunas "Dia" e "Semana" da linha "Leite (produtor)" ficam como **"n/d"** (não se aplica), não "a confirmar" — "a confirmar" implica pendente/vai chegar, o que não é o caso aqui. Só "Mês"/"30 dias"/"12 meses" fazem sentido para essa métrica, e seguem a mesma regra de cálculo via `seriesMap` acima. Ao acumular ponto novo mensal, use a data de referência do CEPEA (normalmente fim de mês), não a data da execução.

## Passos
1. Pesquise os indicadores e notícias **desde a última edição publicada** (não apenas "últimas 24h" — ver regra de cobertura de fim de semana/feriado acima), usando as fontes listadas.
2. Edite `index.html` aplicando as atualizações e acumulando as séries dos gráficos.
3. Rode `./deploy.sh` para republicar.

Objetivo final: `index.html` atualizado e publicado, com Grãos e Proteínas, suíno por praça, UF por cidade, histórico crescente e identidade AgroCore preservada.
