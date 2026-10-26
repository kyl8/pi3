# Consolidado — PI III — Aula 07 — 25/10/2026
*Guia versão 2 · apoio: ChatGPT · estudo teórico e aplicação · motor07.*
**Aluno:** Pedro Henrique · **Grupo:** APPA.
**Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana.

## 1. O que foi passado
- M1 — descasamento de vocabulário: “busca”, “ranqueamento”, “buscar”.
- M2 — esparso e denso; `d1` usa sete das $45$ coordenadas.
- M3 — $W=U\Sigma V^\top$; energia aproximada de $0{,}323$ com $k=2$.
- M4 — consulta dobrada, ranking LSA e escolha de $k$ no desenvolvimento.
- M5 — ganho e ruído do LSA no mesmo mecanismo de compressão.
- M6 — RRF por posições; cálculo manual e comparação das cinco métricas.

## 2. Como foi o aprendizado — opinião da tutora
A resolução conecta a matriz TF-IDF à decomposição SVD, à projeção da consulta e ao ranking LSA. Os exemplos comparam o ganho de aproximação semântica com o ruído da compressão. Na fusão RRF, a conta usa posições; a escolha de `k` usa o desenvolvimento, com os resultados de teste registrados separadamente.

**Teste final:** seis questões resolvidas para revisão.

## 3. Observações para a frente
- **Revisar antes da Aula 08:** dimensões do produto $U_k^\top q_0$, energia e diferença entre posição e escore.
- **Para a próxima tutora:** retomar os checkpoints e conferir a justificativa de cada resposta.
- **Perguntas guardadas:** reordenação do topo, Aula 08; RAG, Aula 14; busca em escala, Aula 15.
- **Produzido:** funções, seis checkpoints, teste, consulta individual “busca”, notebook, CSVs e figura dos oito pontos.
- **Parte D:** aplicação ao APPA documentada em `consolidados/aula07_parteD_consolidado.md`.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-25 22:01 · R version 4.6.1 (2026-06-24 ucrt) · motor07 v1 2026-10-15 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `MOTOR_VERSAO` | character | 1 | motor07 v1 2026-10-15 |
| `busca$cosseno` | numeric, nomeado | 8 | d5 0.2697, d7 0.2649, d1 0, d2 0, d3 0, d4 0, ... |
| `busca$lsa2` | numeric, nomeado | 8 | d4 0.9985, d7 0.9822, d1 0.967, d5 0.9418, d6 0.5661, d2 0.1487, ... |
| `busca$lsa4` | numeric, nomeado | 8 | d5 0.7626, d7 0.7523, d4 0.7237, d1 0.6332, d6 0.4385, d8 0.08229, ... |
| `busca$rrf2` | numeric, nomeado | 8 | d7 0.03226, d5 0.03202, d1 0.03175, d4 0.03154, d2 0.03078, d3 0.03031, ... |
| `busca$rrf4` | numeric, nomeado | 8 | d5 0.03279, d7 0.03226, d1 0.0315, d4 0.03102, d2 0.03055, d6 0.03031, ... |
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | manter |
| `cfg$stopwords` | character | 0 |  |
| `cfg$k1` | numeric | 1 | 1.2 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$limiar` | numeric | 1 | 2 |
| `cfg$prf_k` | numeric | 1 | 0 |
| `cfg$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `ix$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$N` | integer | 1 | 8 |
| `ix$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$postings` | list | 45 | elementos: recuperacao, de, informacao, ordena, documentos, por, relevancia, o, ... |
| `ix$dl` | numeric, nomeado | 8 | d1 7, d2 9, d3 9, d4 6, d5 9, d6 8, ... |
| `ix$avgdl` | numeric | 1 | 8 |
| `ix$idf_bm25` | numeric, nomeado | 45 | a 0.6931, acelera 1.792, aprendizado 1.792, avaliacao 1.792, bm25 1.792, busca 1.281, ... |
| `m2$U` | matrix | 45 × 2 | linhas: a, acelera, aprendizado, ... \| colunas: (sem nomes) |
| `m2$S` | numeric | 2 | 5.602, 5.313 |
| `m2$D` | matrix | 8 × 2 | linhas: d1, d2, d3, ... \| colunas: (sem nomes) |
| `m4$U` | matrix | 45 × 4 | linhas: a, acelera, aprendizado, ... \| colunas: (sem nomes) |
| `m4$S` | numeric | 4 | 5.602, 5.313, 5.022, 4.783 |
| `m4$D` | matrix | 8 × 4 | linhas: d1, d2, d3, ... \| colunas: (sem nomes) |
| `out` | character | 1 | estrutura/resultados/guias/... |
| `q0` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `qk` | numeric | 2 | -0.3702, 0.4445 |
| `r2` | numeric, nomeado | 8 | d2 1, d3 0.9596, d8 0.9596, d6 0.8999, d5 0.4736, d1 0.3971, ... |
| `rb` | numeric, nomeado | 8 | d3 1.873, d1 1.869, d2 1.687, d4 1.427, d8 0.519, d6 0.4925, ... |
| `rc` | numeric, nomeado | 8 | d1 0.2539, d3 0.2327, d4 0.2148, d2 0.2078, d6 0.02485, d8 0.02295, ... |
| `rh` | numeric, nomeado | 8 | d3 0.03252, d2 0.03227, d1 0.03128, d8 0.03126, d6 0.03078, d4 0.03055, ... |
| `s$d` | numeric | 8 | 5.602, 5.313, 5.022, 4.783, 4.672, 4.522, ... |
| `s$u` | matrix | 45 × 8 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `s$v` | matrix | 8 × 8 | linhas: (sem nomes) \| colunas: (sem nomes) |

### Funções definidas

`anexar_estado`, `ap`, `ap_modelo`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_modelo`, `ranking_motor`, `ranking_vetor`, `recall_k`, `relevancia`, `residual`, `rocchio`, `rr`, `rrf`, `salvar`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->
