# Aula 05b: aplicando métricas ao qrels do APPA

Esta é a parte prática da Aula 05b. O objetivo é avaliar os rankings do projeto contra o gabarito guardado em `05-qrels.csv`.

## Preparação

1. A partir da raiz do repositório, execute:

```r
source("estrutura/codigos/2026-09-18-appa-Atividade05b-ParteD-MetricasGabaritoProprio.r")
```

2. Confira o arquivo gerado em `estrutura/resultados/2026-09-18-appa-05b-MetricasGabaritoProprio.csv`.
3. Leia também o consolidado `2026-09-18-appa-Atividade05b-ParteD-MetricasGabaritoProprio.md`.

## O que o script faz

O script reconstrói o corpus APPA, gera os rankings de TF-IDF e BM25 e cruza cada ranking com o qrels. Ele informa, por necessidade e por método:

- P@3;
- AP;
- MRR;
- nDCG binário;
- nDCG graduado;
- MAP, que é a média do AP nas necessidades avaliadas.

Documentos que não foram julgados no pool entram como grau 0. Essa é uma consequência do pooling e deve aparecer como limitação no texto da análise.

## Revisão manual

Escolha uma necessidade e faça a conferência sem usar o resultado final do script:

1. Copie os cinco primeiros documentos de cada ranking.
2. Consulte o grau de cada documento no qrels.
3. Monte o vetor binário conforme o limiar já definido.
4. Calcule P@3 e MRR manualmente.
5. Compare com a linha correspondente do CSV.

Se os valores não coincidirem, confira a ordem dos documentos, o limiar e se o identificador do qrels é o mesmo usado pelo ranking.

## Como escrever a conclusão

A conclusão precisa responder três pontos: qual método teve maior média, em quais necessidades a ordem mudou e por que o resultado ainda não é definitivo. O qrels inicial permite testar o fluxo completo, mas julgamentos humanos independentes são necessários para uma avaliação com concordância entre juízes.
