# Corpus

O corpus do grupo é congelado, para que os identificadores `d1` a `d141` não mudem quando a Wikipédia for editada.

- `fontes-congeladas/*.txt`: um parágrafo por linha de cada artigo (Santos FC, Portuguesa Santista, Jabaquara);
- `docs.rds`: vetor nomeado com os 141 parágrafos (`d1` a `d141`);
- `origem.rds`: vetor nomeado associando cada documento ao clube correspondente.

`estrutura/corpus/banco-de-dados/coletar.R` reconstrói `docs.rds` e `origem.rds` a partir das fontes congeladas e confere o resultado com `estrutura/codigos/05-julgamento/csv/2026-09-15-appa-05-corpus.csv` antes de gravar.

Os scripts de setembro (`2026-08-25-appa-MotorBuscaTfIdf.r`, `2026-09-04-appa-MotorBuscaBm25.r`) ainda baixam a Wikipédia ao vivo e podem gerar um corpus diferente; para avaliações, use sempre o corpus congelado.
