# Atualização — PI III — 25/10/2026

Referência: [Danilo, PI III](https://github.com/danilopradooficial/projetointegrador3), commit `677788d2e1edb4bfe950427b6dd501e2da026487`.

| Conteúdo da referência | Entrega APPA |
|---|---|
| 00, introdução ao R | oito teorias resolvidas, cadernos e 99 blocos executados em `estrutura/resultados/guias/teoria-status.csv` |
| 01a, corpus e frequências | corpus congelado, `estrutura/banco-de-dados/coletar.R` e Parte D da Aula 01 |
| 01b, Shannon | `consolidado/2026-10-25-appa-Atividade01b-Shannon.md` e pesos por termo |
| 02, TF-IDF e cosseno | `estrutura/codigo/aula02.R`, top-5 e contribuição por termo |
| 03, limpeza e índice | Parte D, lista de stopwords, Snowball e índice com 1.902 radicais |
| 04, BM25 | grade de saturação e comprimento, rankings e consolidados |
| 05a, pool e concordância | 66 julgamentos assistidos com justificativa; exercício didático de kappa; formulários humanos preservados |
| 05b, métricas | cinco métricas em rankings completos e gabarito assistido separado |
| 06, Rocchio | feedback completo/residual; PRF comparado no desenvolvimento e desligado |
| 07, LSA e RRF | seis dimensões candidatas, escolha no dev, relato retrospectivo e config persistido |
| Todos os guias | `tutoras/`, `resolucoes/Pedro_Henrique/`, `consolidados/` e notebooks em `estrutura/codigo/` |
| Enunciado e modelos | `entregas/modelo_professor/`, preservados com autoria |

## Reproduzir o teste do enunciado
Na raiz do clone, executar `Rscript estrutura/banco-de-dados/coletar.R` e depois
`Rscript estrutura/codigo/aula02.R`. A coleta reconstitui RDS a partir dos textos-fonte locais
congelados e confere IDs e conteúdo com o corpus julgado antes de escrever.
Os rankings e as contribuições que explicam os primeiros lugares são exportados.
No primeiro pedido, o cosseno coloca um texto de outro clube no topo; o termo `fund`
explica a contribuição dominante. Registro a falha lexical, sem rotular o resultado como relevante.

## Limites e itens que exigem pessoas
Os julgamentos assistidos não são votos de Arthur, Pedro ou Ailana. Os três arquivos humanos
continuam sem preenchimento; kappa real, presença em reunião e demonstração ao vivo não foram inventados.
O teste de consultas é retrospectivo: as mesmas necessidades já tinham sido vistas em versões anteriores.
Não criei uma tag retroativa `entrega-1` nem alterei o histórico para simular uma entrega na data antiga.
O corpus atual de 141 documentos é o congelamento da Aula 05; ultrapassa o tamanho inicial de 20–60
do enunciado de meio de semestre. Não reduzi esse corpus após o julgamento, pois isso invalidaria os IDs.


O manifesto `2026-10-25-fontes.json` registra os commits e os hashes dos materiais didáticos copiados.
A versão atual dos próprios relatórios não reutiliza os números nem a identidade do Team Shannon.
