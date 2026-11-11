# Aula 08 — Parte D — APPA

**Apoio:** ChatGPT. O motor usa BM25 e LSA combinados por RRF; a reordenação por proximidade examina pares de termos na ordem da consulta.

Aplicamos a grade de profundidade 3, 5 e 10 e janela 2, 3 e 5 nas consultas de desenvolvimento. A referência é o julgamento assistido `claude_leitura`, com 152 pares; não são votos humanos. A maior média de AP foi 0,368550 com profundidade 10 e janela 2 (empatada com janelas 3 e 5), contra 0,312995 sem reordenar.

Os documentos não julgados são tratados como não relevantes no cálculo das métricas; isso limita a interpretação de AP, pois o pool não cobre todos os pares possíveis.

No teste retrospectivo, q02 ficou em 0,572876 antes e depois; q04 caiu de 0,352333 para 0,337181. O teste e o gabarito já eram conhecidos; não constituem uma validação inédita. A decisão é experimental: manter a configuração anterior do motor até ampliar consultas e obter julgamentos humanos.

Os resultados completos estão em `estrutura/resultados/aula08-grade-dev.csv` e `estrutura/resultados/aula08-avaliacao-assistida.csv`; execução: `Rscript estrutura/codigo/aula08.R`.

## Leitura de exemplos

Em q01, `d1` sobe de 9º para 1º. O parágrafo identifica o Santos e sua fundação e atende à necessidade histórica; sua proximidade lexical com a consulta ajuda. Entretanto, `d137` também sobe de 4º para 2º: ele trata da história de outro clube e menciona o Santos principalmente como destino de jogadores. A proximidade não distingue essa relação.

Em q04, `d131`, que identifica o Jabaquara e sua fundação, sobe de 3º para 2º. Porém `d108`, que apresenta principalmente a Portuguesa e apenas menciona o Jabaquara, sobe de 4º para 3º; `d133`, que relata a fundação do antigo Hespanha, cai de 2º para 4º. A mudança contribui para a queda do AP assistido nessa consulta. Os textos e posições estão em `estrutura/resultados/aula08-comparacao-textos.csv`.

Em q06, `d135` descreve o estádio Antonio Alonso construído no Macuco e atende à busca por estádio; `d140` descreve campo e instalações na Caneleira, embora o trecho não nomeie estádio e contenha medida suspeita na fonte. O grau 2 atribuído a ambos pela leitura assistida é plausível para informações de estádio/campo, mas `d140` é ambíguo e precisa de revisão humana. O zero do gabarito anterior decorre de cobertura diferente, não de uma ausência comprovada de documentos relevantes.

O motor oferece a opção `rerank_k`, com janela configurável; o valor persistido é zero (desligado), pois o ganho no desenvolvimento assistido é concentrado em q01 e o teste conhecido inclui uma perda. Ativar 10 e janela 2 é uma experiência, não uma nova escolha validada em teste independente. Quando ligado, a ordem devolvida reflete a proximidade, mas os valores numéricos continuam sendo os escores do primeiro estágio e podem não estar em ordem decrescente.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-11 01:03 · R version 4.6.1 (2026-06-24 ucrt) · motor08 v2 2026-10-22 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `MOTOR_VERSAO` | character | 1 | motor08 v2 2026-10-22 |
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
| `cfg$rerank_k` | integer | 1 | 0 |
| `cfg$janela` | integer | 1 | 2 |
| `cfg$grupo` | character | 1 | APPA |
| `choice` | data.frame | 1 × 3 | colunas: k, janela, AP |
| `dev` | data.frame | 10 × 3 | colunas: k, janela, AP |
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
| `nec` | data.frame | 6 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `qrels` | data.frame | 152 × 7 | colunas: consulta, documento, grau, juiz, timestamp, segundos, metodo |
| `tab` | data.frame | 44 × 5 | colunas: consulta, conjunto, k, janela, AP |

### Funções definidas

`proximidade`, `reordenar_appa`
<!-- estado-R:fim -->
