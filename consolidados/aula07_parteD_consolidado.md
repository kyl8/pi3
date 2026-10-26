# Consolidado — PI III — Aula 07 — Parte D — 25/10/2026
*Guia versão 2 · apoio: ChatGPT · preparação da aplicação de grupo · motor07.*
**Grupo:** APPA · **Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana.

## 1. O que foi feito
- M7 — LSA no corpus congelado; em `q01`, três documentos em comum nos top-5;
  leitura de `d55` exclusivo do LSA e `d139` exclusivo do BM25, com termos compartilhados.
- M8 — candidatos medidos no desenvolvimento; híbrido com $k=20$ escolhido.
  MAP dev: BM25 $0,594298$, LSA $0,583712$,
  híbrido $0,653319$. Teste retrospectivo:
  BM25 $0,388607$, híbrido $0,242005$.
  Registramos a perda sem trocar a escolha. Três consultas dev válidas; `q06` excluída por $R=0$.
- M9 — `modelo="hibrido"`, `lsa_k=20`, `rrf_c=60`, `prf_k=0`.
  Ficha, os dois `config.R` e `ranking_motor` estão de acordo.

## 2. Como o grupo trabalhou — opinião da tutora
Organizamos o trabalho em três frentes: leitura dos textos recuperados, comparação dos modelos
no desenvolvimento e integração da configuração ao motor. Em `q01`, relacionamos os três documentos
em comum no top-5 aos casos exclusivos `d55` e `d139`, observando os termos compartilhados e o foco
de cada trecho. Depois, analisamos o ganho em `q05` e a perda em `q04`, além do MAP agregado.

Mantivemos o híbrido com `k=20`, escolhido pelo desenvolvimento, e registramos a queda no teste
retrospectivo sem reajustar a escolha a partir dele. No fechamento, alinhamos a ficha, os dois
`config.R` e `ranking_motor`. A análise considera a dimensão da pool e a origem assistida do gabarito.

**Verificação final:** decisão, parâmetros, comparação textual e placares consistentes entre os arquivos.

## 3. Observações para a frente
- **Para a Aula 08:** corpus e parâmetros congelados; medir o reordenador com o mesmo gabarito,
  ampliando julgamentos e consultas independentes antes de generalizar os resultados.
- **Perguntas guardadas:** reordenação, Aula 08; RAG, Aula 14; escala, Aula 15.
- **Produzido:** [resolução completa](../resolucoes/aula07_parteD_resolvido.md),
  código, notebook, CSVs, comparação textual, ficha e estados do R.
- **Ficha atualizada:** cabeçalho, identificação do grupo e seções 5, 6 e 7 revisados.

## Passos de fechamento do guia
1. Salvar `00_FICHA_PROJETO.md` e `aula07_parteD_consolidado.md` em UTF-8; os arquivos locais estão em `consolidados/`.
2. Se usar Colab, enviar os dois arquivos à sessão aberta e conferir os nomes exatos com `list.files()`.
3. Rodar `anexar_estado()` nos dois arquivos; nesta preparação, os estados reais foram gerados pelo R local.
4. Baixar os dois Markdown, `config.R` e o notebook como `aula07.ipynb` antes de fechar o Colab.
5. Enviar ficha e consolidado a `consolidados/`, e configuração e notebook a `estrutura/codigo/` do repositório.
6. Conferir que a ficha termina com “Estado do R” e a configuração contém `modelo`, `lsa_k` e `rrf_c`.
7. Conferir os mesmos valores na seção 6 da ficha e no `config.R`.
8. Os consolidados da teoria ficam diretamente em `consolidados/`; o desta aula está em `consolidados/aula07_consolidado.md`.

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
