# Julgamento humano da Aula 05

Esta pasta separa os votos de tres pessoas e so gera um qrels humano depois que as tres planilhas estiverem preenchidas. O arquivo `2026-09-15-appa-05-qrels.csv` continua sendo apenas uma referencia inicial do pipeline.

## Preparacao

Na pasta `estrutura/codigos/05-julgamento`, execute:

```r
source("2026-10-05-appa-05f-preparar-julgamentos-humanos.R")
```

Isso cria `juiz_01.csv`, `juiz_02.csv` e `juiz_03.csv` com os 101 pares do pool v2 e sem nenhum grau. Planilhas do mesmo pool são preservadas. Se o pool mudou e há votos preenchidos, o script para antes de gravar: os votos precisam ser migrados.

## Cada avaliador

Cada pessoa abre `2026-09-15-appa-05-julgar.html`, informa sua identificacao (`juiz_01`, `juiz_02` ou `juiz_03`), carrega corpus, necessidades e `2026-11-06-appa-05-pool-v2.csv`, e julga sem ver os votos dos outros. Os arquivos com graus de LLM e a origem dos rankings ficam separados desse julgamento.

Use os mesmos criterios:

- **0**: nao responde a necessidade;
- **1**: traz contexto parcial ou indireto;
- **2**: responde diretamente a necessidade.

Depois de terminar, a pessoa exporta o CSV e substitui o arquivo correspondente em `csv/julgamentos-humanos/`. O identificador informado no HTML deve coincidir com o nome da planilha.

## Consolidacao

Quando os tres arquivos estiverem completos, execute:

```r
source("2026-10-05-appa-05g-consolidar-julgamentos-humanos.R")
```

O script valida os pares, gera `kappas.csv` e `divergencias.csv`. Se todos os pares tiverem maioria, ele cria `2026-09-15-appa-05-qrels-humanos.csv`. Se os tres graus forem diferentes em algum par, ele para sem fabricar um vencedor: os avaliadores precisam discutir esse caso e registrar a decisao antes de consolidar.
