# Projeto Integrador III

Repositório do grupo APPA para o estudo de recuperação de informação. O motor usa textos sobre clubes tradicionais da Baixada Santista e evolui de uma busca por ocorrência para TF-IDF, busca booleana e BM25.

## Estrutura

- [entregas](entregas/): relatórios formais e entregas acadêmicas em LaTeX/Sweave;
- [consolidado](consolidado/): atividades documentadas;
- [estrutura/codigos](estrutura/codigos/): scripts em R;
- [estrutura/corpus](estrutura/corpus/): informações e artefatos do corpus;
- [estrutura/resultados](estrutura/resultados/): métricas e saídas das execuções;
- [materiais-aulas](materiais-aulas/): PDFs e materiais de apoio.

Todos os artefatos seguem a convenção de prefixo `YYYY-MM-DD-appa`.

## Scripts

- [MotorDeBusca](estrutura/codigos/2026-08-20-appa-MotorBuscaInicial.r): busca direta, frases e estatísticas;
- [MotorBuscaTfIdf](estrutura/codigos/2026-08-25-appa-MotorBuscaTfIdf.r): TF-IDF, cosseno e operadores booleanos;
- [MotorBuscaBM25](estrutura/codigos/2026-09-04-appa-MotorBuscaBm25.r): BM25 e comparação com TF-IDF.
- [Avaliação](estrutura/codigos/2026-09-15-appa-Atividade05-AvaliacaoMotor.r): métricas de ranking com consultas de teste.
- [Métricas de Avaliação (Aula 5.5)](estrutura/codigos/2026-09-18-appa-Atividade05b-MetricasAvaliacao.r): cálculo de P@k, AP, MRR e nDCG (binário e graduado).
- [Métricas no Gabarito Próprio (Parte D)](estrutura/codigos/2026-09-18-appa-Atividade05b-ParteD-MetricasGabaritoProprio.r): avaliação comparativa entre BM25 e TF-IDF contra o qrels do projeto.
- [Introdução ao R e Motor de Busca (Aula 00 - Notebook)](estrutura/codigos/Aula_00_Introducao_ao_R_Motor_de_Busca.ipynb): notebook interativo cobrindo vetores, regex, tokenização e contagens.
- [Execução Completa Aula 00 (Script R)](estrutura/codigos/2026-10-02-appa-Aula00-IntroducaoR.R): script reprodutível com todos os blocos dos módulos 1 a 14.

## Entregas Formais
 
- [Entrega 1: Corpus do Projeto (PDF compilado)](entregas/entrega-1/entrega-1-corpus.pdf) ([Fonte Sweave](entregas/entrega-1/entrega-1-corpus.Rnw))
- [Entrega 1: Pergunta da Pesquisa (PDF compilado)](entregas/entrega-1-pergunta/entrega-1-pergunta.pdf) ([Fonte Sweave](entregas/entrega-1-pergunta/entrega-1-pergunta.Rnw))

## Atividades

- [00: introdução ao R (visão geral)](consolidado/2026-09-15-appa-Atividade00-IntroducaoR.md)
- [00: introdução ao R (teoria e estado do R)](consolidado/2026-10-02-appa-Atividade00-ConsolidadoTeoria.md)
- [00: introdução ao R (prática e fluxo)](consolidado/2026-10-02-appa-Atividade00-ParteD-FluxoCurso.md)
- [01: corpus e busca direta](consolidado/2026-09-15-appa-Atividade01-CorpusBusca.md)
- [01b: pesos dos termos](consolidado/2026-09-15-appa-Atividade01b-PesosTermos.md)
- [02: TF-IDF e cosseno](consolidado/2026-09-15-appa-Atividade02-TfIdfCosseno.md)
- [03: pré-processamento e índice](consolidado/2026-09-15-appa-Atividade03-PreProcessamentoIndice.md)
- [04: Poisson, saturação e BM25](consolidado/2026-09-15-appa-Atividade04-PoissonBm25.md)
- [05: avaliação do motor](consolidado/2026-09-15-appa-Atividade05-AvaliacaoMotor.md)
- [05b: métricas de avaliação teóricas](consolidado/2026-09-18-appa-Atividade05b-MetricasAvaliacao.md)
- [05b: métricas no gabarito próprio (Parte D)](consolidado/2026-09-18-appa-Atividade05b-ParteD-MetricasGabaritoProprio.md)

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
- `2026-09-15-appa-05e-gerar-qrels-inicial.R`: preenche a referencia inicial do projeto;
- `csv/`: corpus, necessidades, pool e arquivo de julgamentos.

Para preparar os arquivos, execute os scripts `05b`, `05c`, `05d` e `05e` a partir da raiz do repositorio. O qrels inicial tem 66 pares e serve como referencia para testar o motor. Depois abra o HTML no navegador, carregue os tres CSVs e revise ou substitua esses graus com julgamentos humanos.
