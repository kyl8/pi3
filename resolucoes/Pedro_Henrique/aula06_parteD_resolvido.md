# Consolidado — PI III — Aula 06 — Parte D — 2026-10-25
**Grupo:** APPA · **Solicitante:** Pedro Henrique · **Apoio:** Codex.
Preparação e execução automatizadas. Presenças, rodízio e concordância dos colegas não foram observados.

## 1. O que foi feito
- M7 — Rocchio com o gabarito do grupo
- M8 — Pseudo-realimentação em todas as consultas
- M9 — A decisão do grupo e o registro

No desenvolvimento, sem pseudo-feedback, MAP=0,585. Todos os valores positivos testados de $k$ pioraram o desenvolvimento, então uso `prf_k=0`. Os parâmetros Rocchio são $\alpha=1$, $\beta=0{,}75$, $\gamma=0{,}15$, com pesos negativos truncados em zero e centroide vazio tratado explicitamente. A avaliação residual retira todos os quatro documentos vistos do ranking e do gabarito; quando não sobra relevante, AP residual é indefinido, não zero.


| consulta | AP_antes | AP_depois | AP_residual_antes | AP_residual_depois |
|---|---|---|---|---|
| q01 | 0.0972850678733032 | 0.0717703349282297 | 0.132478632478632 | 0.0888888888888889 |
| q02 | 0.120055039559684 | 0.120055039559684 | 0.244444444444444 | 0.244444444444444 |
| q03 | 1 | 1 | NA | NA |
| q04 | 0.592619047619048 | 0.485272641062115 | 0.805555555555555 | 0.0781662781662782 |
| q05 | 0.657081807081807 | 0.588804713804714 | 0.861111111111111 | 0.27 |
| q06 | NA | NA | NA | NA |

| k | conjunto | AP |
|---|---|---|
| 0 | dev | 0.58478895831837 |
| 1 | dev | 0.526494178124613 |
| 2 | dev | 0.354908843305468 |
| 3 | dev | 0.275533573395416 |
| 5 | dev | 0.299759085136078 |
| 0 | teste_retrospectivo | 0.356337043589366 |
| 1 | teste_retrospectivo | 0.231883116883117 |
| 2 | teste_retrospectivo | 0.241388888888889 |
| 3 | teste_retrospectivo | 0.286671122994652 |
| 5 | teste_retrospectivo | 0.35536184522118 |

## 2. Como foi o trabalho — opinião da tutora
Eu preparei as resoluções e a aplicação computacional pedidas por Pedro. As decisões acima são
propostas registradas com evidência; não representam reunião ou desempenho individual inventados.
Os exemplos canônicos foram executados no R, com status por bloco e transcrição das saídas.

**Verificação final:** resolução preparada; aprendizagem individual e acordo dos integrantes não aferidos.

## 3. Observações para a frente
- **Produzido:** código `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R`, roteiros em
  `estrutura/codigos/guias/` e saídas em `estrutura/resultados/guias/`.
- **Ficha:** decisões e parâmetros atualizados em `consolidado/00_FICHA_PROJETO.md`.
- **Perguntas guardadas:** ampliar julgamentos, testar consultas inéditas e medir concordância humana.
- **Limite da evidência:** resultados sobre pool parcial e referência assistida; não equivalem a validação por três juízes humanos.
