# Projeto Integrador III

Repositório do grupo APPA para o estudo de recuperação de informação. O motor usa textos sobre clubes tradicionais da Baixada Santista e evolui de uma busca por ocorrência para TF-IDF, busca booleana e BM25.

## Estrutura

- [consolidado](consolidado/): atividades documentadas;
- [estrutura/codigos](estrutura/codigos/): scripts em R;
- [estrutura/corpus](estrutura/corpus/): informações sobre a origem do corpus;
- [estrutura/resultados](estrutura/resultados/): métricas e saídas das execuções;
- [materiais-aulas](materiais-aulas/): PDFs e materiais de apoio.

Os arquivos atualizados desta etapa usam a identificação `2026-09-15-appa`.

## Scripts

- [MotorDeBusca](estrutura/codigos/2026-08-20-appa-MotorBuscaInicial.r): busca direta, frases e estatísticas;
- [MotorBuscaTfIdf](estrutura/codigos/2026-08-25-appa-MotorBuscaTfIdf.r): TF-IDF, cosseno e operadores booleanos;
- [MotorBuscaBM25](estrutura/codigos/2026-09-04-appa-MotorBuscaBm25.r): BM25 e comparação com TF-IDF.
- [Avaliação](estrutura/codigos/2026-09-15-appa-Atividade05-AvaliacaoMotor.r): métricas de ranking com consultas de teste.

## Atividades

- [00: introdução ao R](consolidado/2026-09-15-appa-Atividade00-IntroducaoR.md)
- [01: corpus e busca direta](consolidado/2026-09-15-appa-Atividade01-CorpusBusca.md)
- [01b: pesos dos termos](consolidado/2026-09-15-appa-Atividade01b-PesosTermos.md)
- [02: TF-IDF e cosseno](consolidado/2026-09-15-appa-Atividade02-TfIdfCosseno.md)
- [03: pré-processamento e índice](consolidado/2026-09-15-appa-Atividade03-PreProcessamentoIndice.md)
- [04: Poisson, saturação e BM25](consolidado/2026-09-15-appa-Atividade04-PoissonBm25.md)
- [05: avaliação do motor](consolidado/2026-09-15-appa-Atividade05-AvaliacaoMotor.md)

## Como executar

No RStudio, abra um dos scripts e use `Source`. Pelo terminal, execute, a partir da raiz do repositório:

```r
source("estrutura/codigos/2026-09-04-appa-MotorBuscaBm25.r")
```

É necessária conexão com a internet para carregar as páginas da Wikipédia. O corpus pode mudar quando as páginas forem atualizadas. O script BM25 também usa o pacote `SnowballC`:

```r
install.packages("SnowballC")
```

## Julgamento humano da atividade 05

A pasta `estrutura/codigos/05-julgamento` guarda o fluxo completo da Aula 05:

- `2026-09-15-appa-05-julgar.html`: pagina offline para dar notas 0, 1 ou 2;
- `2026-09-15-appa-05b-montar-corpus.R`: salva os 141 paragrafos do corpus atual;
- `2026-09-15-appa-05c-ficha-corpus.R`: confere linhas, colunas e duplicidades;
- `2026-09-15-appa-05d-gerar-pool.R`: cria os pares necessidade-documento;
- `2026-09-15-appa-05a-kappa.R`: calcula a concordancia entre dois juizes;
- `csv/`: corpus, necessidades, pool e arquivo de julgamentos.

Para preparar os arquivos, execute os scripts `05b`, `05c` e `05d` a partir da raiz do repositorio. Depois abra o HTML no navegador, carregue os tres CSVs e exporte o qrels com os julgamentos humanos.