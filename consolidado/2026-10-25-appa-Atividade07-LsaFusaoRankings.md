# Atividade 07: LSA e fusão de rankings

A atividade aplica decomposição em valores singulares ao corpus APPA e combina LSA com BM25 por *reciprocal rank fusion* (RRF). O corpus usado contém 141 parágrafos sobre Santos FC, Portuguesa Santista e Jabaquara.

## Procedimento

O script transforma os textos em uma matriz TF-IDF, reduz a representação a 12 dimensões latentes e calcula três rankings para cada necessidade da Atividade 05: BM25, LSA e RRF. A comparação usa o qrels de referência inicial do projeto, portanto é uma verificação do pipeline, não uma avaliação humana definitiva.

## Resultado atual

| método | MAP |
|---|---:|
| BM25 | 0,085 |
| LSA | 0,155 |
| RRF | 0,105 |

No conjunto atual, LSA obteve a maior média. A conclusão é limitada pelo qrels inicial, pelo número de necessidades e pela coleta dinâmica do corpus.

## Arquivos

- `estrutura/codigos/2026-10-25-appa-Atividade07-LsaFusaoRankings.R`
- `estrutura/resultados/2026-10-25-appa-07-LsaRrfMetricas.csv`
- `estrutura/resultados/2026-10-25-appa-07-LsaRrfTop5.csv`
