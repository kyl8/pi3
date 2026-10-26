# Consolidado — PI III — Aula 05b — Parte D — 2026-10-25
**Grupo:** APPA · **Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana · **Apoio:** ChatGPT.

## 1. O que foi feito
- M10 — Os gabaritos do grupo, os juízes e o limiar
- M11 — As métricas como funções; uma consulta, dois sistemas
- M12 — Todas as consultas, e o vencedor

As cinco medidas usam o mesmo limiar, ranking completo e gabarito: precisão no topo, AP, RR e nDCG binário e graduado. Não truncar AP em dez resultados evita transformar silenciosamente AP em AP@10. Documento não julgado vale zero por convenção de avaliação, sem afirmar irrelevância real. A consulta q06 não tem relevante de grau dois na pool e fica fora do MAP; ampliar a pool é necessário antes de concluir que o corpus não contém resposta.


| consulta | conjunto | modelo | R | P_at_k | AP | RR | nDCG_bin | nDCG_grad |
|---|---|---|---|---|---|---|---|---|
| q01 | dev | cosseno | 2 | 0 | 0.0972850678733032 | 0.0769230769230769 | 0.308083165755618 | 0.646196219904718 |
| q01 | dev | bm25 | 2 | 0 | 0.122377622377622 | 0.0909090909090909 | 0.332075909156926 | 0.684083637320824 |
| q02 | teste_retrospectivo | cosseno | 3 | 0 | 0.120055039559684 | 0.166666666666667 | 0.367231449488195 | 0.388026143749962 |
| q02 | teste_retrospectivo | bm25 | 3 | 0 | 0.0910225442834138 | 0.111111111111111 | 0.331210682898182 | 0.357689159690427 |
| q03 | dev | cosseno | 1 | 0.333333333333333 | 1 | 1 | 1 | 0.858094813471481 |
| q03 | dev | bm25 | 1 | 0.333333333333333 | 1 | 1 | 1 | 0.831871012159447 |
| q04 | teste_retrospectivo | cosseno | 5 | 0.666666666666667 | 0.592619047619048 | 0.5 | 0.734817979008813 | 0.86793175952524 |
| q04 | teste_retrospectivo | bm25 | 5 | 0.666666666666667 | 0.686190476190476 | 0.5 | 0.773893196484256 | 0.901317142320163 |
| q05 | dev | cosseno | 6 | 0.333333333333333 | 0.657081807081807 | 1 | 0.838123781444526 | 0.919020166299524 |
| q05 | dev | bm25 | 6 | 0.333333333333333 | 0.660515873015873 | 1 | 0.837409080026344 | 0.918369351440051 |
| q06 | dev | cosseno | 0 | 0 | NA | 0 | NA | 0.630929753571458 |
| q06 | dev | bm25 | 0 | 0 | NA | 0 | NA | 0.630929753571458 |

## 2. Como o grupo trabalhou — opinião da tutora
Organizamos a avaliação a partir do mesmo gabarito, limiar e ranking completo para os dois
modelos. Comparamos precisão no topo, AP, RR e as duas versões de nDCG, relacionando cada medida
à pergunta que ela responde. Conferimos o tratamento dos documentos não julgados e da consulta
q06, que não entra no MAP por não ter relevante no limiar adotado. Assim, a interpretação do placar
permanece vinculada à cobertura da pool e à definição das métricas.

**Verificação final:** medidas calculadas sobre a mesma referência e critérios de agregação explícitos.

## 3. Observações para a frente
- **Produzido:** código `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R`, roteiros em
  `estrutura/codigos/guias/` e saídas em `estrutura/resultados/guias/`.
- **Ficha:** decisões e parâmetros atualizados em `consolidados/00_FICHA_PROJETO.md`.
- **Perguntas guardadas:** ampliar julgamentos, testar consultas inéditas e medir concordância humana.
- **Limite da evidência:** resultados sobre pool parcial e referência assistida; não equivalem a validação por três juízes humanos.
