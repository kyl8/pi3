# Ficha do Projeto — Motor de Busca
*criada na Aula 01 · última atualização: Aula 07 Parte D, 25/10/2026, motor07*

## 1. Identificação do Projeto, Repositório e Equipe
- **Nome do Grupo:** APPA
- **Integrantes:** Arthur Galvão, Pedro Henrique, Ailana
- **Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana
- **Apoio:** ChatGPT
- **Repositório GitHub:** `https://github.com/kyl8/pi3`
- **Branch Principal:** `main`
- **Ambiente de Desenvolvimento:** R 4.6.1 (local Windows / Google Colab R Runtime)

## 2. Tema, Usuário e Necessidade de Informação
- **Tema:** Clubes Tradicionais de Futebol da Baixada Santista.
- **Vínculo Regional:** Baixada Santista (Santos, Vila Belmiro, Ulrico Mursa, Caneleira). Abrange a história, títulos, estádios e patrimônio do Santos Futebol Clube, Associação Atlética Portuguesa (Briosa) e Jabaquara Atlético Clube.
- **Público-Alvo / Usuário:** Historiadores esportivos, jornalistas, pesquisadores regionais, estudantes e torcedores interessados na memória do futebol santista.
- **Três Perguntas Canônicas de Busca:**
  1. *Quando foi fundado o Santos Futebol Clube e quais foram seus primeiros títulos?*
  2. *Qual é o estádio e quais são as cores tradicionais da Portuguesa Santista?*
  3. *Qual a trajetória e importância histórica do Jabaquara Atlético Clube em Santos?*

## 3. Fonte dos Dados, Licença e Critério de Documento
- **Fonte:** Wikipédia em Língua Portuguesa via API oficial (`https://pt.wikipedia.org/w/api.php`, parâmetros `action=query&prop=extracts&explaintext=1`).
- **Licença de Uso:** Creative Commons Atribuição-CompartilhaIgual 4.0 Internacional (CC BY-SA 4.0).
- **Páginas Coletadas (Títulos Exatos):**
  - `Santos Futebol Clube`
  - `Associação Atlética Portuguesa (Santos)`
  - `Jabaquara Atlético Clube`
- **Unidade Documental (O que é um documento):** Parágrafo (`\n+`). Justificativa: o parágrafo constitui a menor unidade textual semanticamente autocontida capaz de responder pontualmente a uma necessidade de busca, evitando a diluição informacional de artigos completos e a fragmentação excessiva de sentenças isoladas.
- **Critério de Retenção:** Parágrafos com mais de `cfg$minimo` caracteres (50 caracteres) para preservar notas históricas concisas sobre a Briosa e o Jabaquara.

## 4. Características do Corpus e Estatísticas Textuais
- **Total de Documentos (N):** 141 documentos.
- **Distribuição por Artigo de Origem:**
  - `Santos FC`: 107 documentos
  - `Portuguesa Santista`: 23 documentos
  - `Jabaquara`: 11 documentos
- **Estatísticas de Tokens por Documento:**
  - Mínimo: 9 tokens
  - Máximo: 331 tokens
  - Média: 86 tokens
- **Vocabulário Bruto:** 3.073 termos únicos.
- **Observações Textuais e Diagnóstico de Ruído:**
  - Pontuação grudada e vírgulas isoladas figurando entre os termos mais frequentes (ex.: vírgula aparece 301 vezes, além de `santos,`, `clube.`).
  - Presença maciça de stopwords gramaticais no top 10 (`o`: 604, `de`: 567, `a`: 412, `e`: 292, `em`: 278, `do`: 277, `da`: 172, `no`: 171). O único termo informativo temático no top 10 é `santos` (160 ocorrências).
  - Termos com acentuação diversa mantidos como tokens distintos (ex.: `pelé` com 18 ocorrências).
  - Preservação deliberada do texto bruto nesta etapa para servir de base experimental comparativa às etapas de normalização e filtragem da Aula 03.

## 5. Estado dos módulos
| Etapa | Situação | Evidência |
|---|---|---|
| 00–01 | exemplos executados e corpus preservado | `estrutura/resultados/guias/teoria/` |
| 02 | cosseno e normalização executados | `aula02_04_top5_com_textos.csv` |
| 03 | limpeza, stopwords, stemming e índice | 1902 termos preparados |
| 04 | BM25 e grade de parâmetros executados | `aula04_exploracao_bm25.csv` |
| 05 | corpus congelado; pool e julgamento assistido completos | 66 pares; votos humanos ainda ausentes |
| 05b | métricas no ranking completo | `aula05b_metricas_grupo.csv` |
| 06 | realimentação explícita e residual; PRF desligado | `prf_k=0`; candidatos no desenvolvimento |
| 07 | LSA e busca híbrida; guias v2 completos | `estrutura/codigo/aula07.ipynb`; `modelo=hibrido`, `lsa_k=20`, `rrf_c=60` |

## 6. Decisões e parâmetros
- Fonte canônica das avaliações: CSV congelado da Aula 05; não recoletar páginas para recalcular estas métricas.
- Limpeza: transliteração, stopwords explícitas e Snowball português; mesma função para corpus e consulta.
- $k_1=1{,}5$, $b=0{,}75$, limiar de relevância $2$; juiz de referência `codex_assistido`.
- Qrels assistido separado da referência antiga e das planilhas humanas. Nenhum kappa humano foi inventado.
- Relevantes por consulta no pool: q01: 2, q02: 3, q03: 1, q04: 5, q05: 6, q06: 0; q06 sai do MAP no limiar dois.
- Desenvolvimento: q01, q03, q05, q06; teste retrospectivo: q02, q04. Não é teste historicamente intocado.
- Pseudo-feedback não usado: `prf_k=0`; pesos Rocchio $(1;0{,}75;0{,}15)$; negativos truncados em zero.
- Híbrido $k=20$ escolhido no desenvolvimento; piora no teste retrospectivo registrada, sem retocar a seleção.

- Aula 07, guias v2: modelo do motor `hibrido`, $k=20$, $c=60$;
  MAP dev BM25 $0,594298$, LSA $0,583712$, híbrido $0,653319$;
  teste retrospectivo BM25 $0,388607\to 0,242005$, sem reajuste.
  Apenas a configuração escolhida e BM25 são medidos no teste pela execução atual.
  Leitura de `q01`: três em comum nos top-5; LSA inclui o hino do Santos (`d55`),
  BM25 inclui o confronto do Jabaquara (`d139`) por quatro termos coincidentes.
  Ganho lido em `q05`; perda em `q04`, por aproximar textos da Portuguesa à consulta sobre Jabaquara.

## 7. Diário de bordo
- 2026-10-02 — fundação do corpus APPA, histórico preservado nas entregas anteriores.
- 2026-10-25 — sincronização com Danilo `677788d`; guias 00–06 resolvidos, exemplos executados e
  aplicações ao corpus congelado; Aula 07 refeita com candidatos de dimensão e configuração persistida.
- Documentação do grupo APPA com apoio de ChatGPT: resoluções, código, resultados e configuração
  organizados para revisão e continuidade. Julgamentos humanos permanecem pendentes.

- 25/10/2026 — guias da Aula 07 v2 incorporados; teoria e tarefa individual executadas, Partes D e notebooks preparados; estados reais anexados por R.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-25 22:01 · R version 4.6.1 (2026-06-24 ucrt) · motor07 v1 2026-10-15 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `MOTOR_VERSAO` | character | 1 | motor07 v1 2026-10-15 |
| `cfg$corpus_dir` | character | 1 | estrutura/corpus |
| `cfg$resultados_dir` | character | 1 | estrutura/resultados |
| `cfg$minimo` | numeric | 1 | 50 |
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | translit |
| `cfg$stopwords` | character | 17 | a, o, e, de, do, da, ... |
| `cfg$stemming` | logical | 1 | TRUE |
| `cfg$k1` | numeric | 1 | 1.5 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$limiar` | integer | 1 | 2 |
| `cfg$juizes` | character | 1 | codex_assistido |
| `cfg$prf_k` | integer | 1 | 0 |
| `cfg$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `cfg$modelo` | character | 1 | hibrido |
| `cfg$lsa_k` | integer | 1 | 20 |
| `cfg$rrf_c` | numeric | 1 | 60 |
| `cfg$grupo` | character | 1 | APPA |
| `docs` | character, nomeado | 141 | d1 Santos Futebol Clube , mais..., d2 O Santos tornou-se no futeb..., d3 Ao longo de sua história, o..., d4 O Santos foi eleito pela FI..., d5 O Santos Futebol Clube foi ..., d6 As cores iniciais do Santos..., ... |
| `escolha` | data.frame | 1 × 3 | colunas: modelo, k, AP |
| `graus$q01` | integer, nomeado | 13 | d1 2, d110 0, d137 0, d4 1, d40 1, d5 2, ... |
| `graus$q02` | integer, nomeado | 11 | d107 0, d137 0, d26 0, d36 0, d68 2, d70 0, ... |
| `graus$q03` | integer, nomeado | 10 | d108 1, d109 0, d114 0, d115 0, d116 0, d118 0, ... |
| `graus$q04` | integer, nomeado | 10 | d108 1, d110 1, d114 1, d115 0, d131 2, d133 2, ... |
| `graus$q05` | integer, nomeado | 12 | d107 2, d137 0, d26 0, d36 0, d48 1, d68 2, ... |
| `graus$q06` | integer, nomeado | 10 | d108 0, d110 0, d114 0, d115 0, d131 1, d133 0, ... |
| `ix$tokens` | list | 141 | elementos: d1, d2, d3, d4, d5, d6, d7, d8, ... |
| `ix$vocab` | character | 1902 | 0, 000, 068, 1, 10, 100, ... |
| `ix$tf` | matrix | 1902 × 141 | linhas: 0, 000, 068, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$N` | integer | 1 | 141 |
| `ix$df` | numeric, nomeado | 1902 | 0 13, 000 3, 068 1, 1 28, 10 8, 100 1, ... |
| `ix$idf_tfidf` | numeric, nomeado | 1902 | 0 2.384, 000 3.85, 068 4.949, 1 1.617, 10 2.869, 100 4.949, ... |
| `ix$w` | matrix | 1902 × 141 | linhas: 0, 000, 068, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$wn` | matrix | 1902 × 141 | linhas: 0, 000, 068, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$postings` | list | 1902 | elementos: sant, futebol, club, mais, conhec, apen, com, poliesport, ... |
| `ix$dl` | numeric, nomeado | 141 | d1 77, d2 71, d3 99, d4 75, d5 64, d6 28, ... |
| `ix$avgdl` | numeric | 1 | 56.92 |
| `ix$idf_bm25` | numeric, nomeado | 1902 | 0 2.353, 000 3.703, 068 4.55, 1 1.606, 10 2.816, 100 4.55, ... |
| `modelo_teste$U` | matrix | 1902 × 20 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `modelo_teste$D` | matrix | 141 × 20 | linhas: d1, d2, d3, ... \| colunas: (sem nomes) |
| `nec` | data.frame | 6 × 6 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto, id |
| `placar` | data.frame | 5 × 3 | colunas: conjunto, modelo, AP |
| `tab_dev` | data.frame | 18 × 3 | colunas: modelo, k, AP |

### Funções definidas

`ap_modelo`, `lsa`, `ranking_lsa`, `ranking_modelo`, `ranking_motor`, `rrf`
<!-- estado-R:fim -->
