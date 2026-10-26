# Projeto Integrador III

**Grupo:** APPA — Arthur Galvão, Pedro Henrique e Ailana.
**Apoio:** ChatGPT.

Repositório do grupo APPA para o estudo de recuperação de informação. O motor usa textos sobre clubes tradicionais da Baixada Santista e evolui de uma busca por ocorrência para TF-IDF, busca booleana e BM25.

> **Módulos Iniciais (Aulas 00 e 01):**
> Os artefatos fundamentais das Aulas 00 e 01 (introdução ao R, tokenização, extração do corpus e busca booleana) também têm um histórico no repositório dedicado: **[Arthur-galvao/pi3-aulas-00-01](https://github.com/Arthur-galvao/pi3-aulas-00-01)**.

## Estrutura

- [entregas](entregas/): relatórios formais e entregas acadêmicas em LaTeX/Sweave;
- [consolidados](consolidados/): atividades documentadas;
- [estrutura/codigos](estrutura/codigos/): scripts em R;
- [estrutura/corpus](estrutura/corpus/): informações e artefatos do corpus;
- [estrutura/resultados](estrutura/resultados/): métricas e saídas das execuções;
- [materiais-aulas](materiais-aulas/): PDFs e materiais de apoio das aulas avançadas (Aulas 00 a 07);
- [tutoras](tutoras/): guias de estudo autônomos das aulas do projeto (Aulas 00 a 07).

Todos os artefatos seguem a convenção de prefixo `YYYY-MM-DD-appa`.

## Scripts

- [MotorBuscaTfIdf](estrutura/codigos/2026-08-25-appa-MotorBuscaTfIdf.r): TF-IDF, cosseno e operadores booleanos;
- [MotorBuscaBM25](estrutura/codigos/2026-09-04-appa-MotorBuscaBm25.r): BM25 e comparação com TF-IDF;
- [Avaliação](estrutura/codigos/2026-09-15-appa-Atividade05-AvaliacaoMotor.r): métricas de ranking com consultas de teste;
- [Métricas de Avaliação (Aula 5.5)](estrutura/codigos/2026-09-18-appa-Atividade05b-MetricasAvaliacao.r): cálculo de P@k, AP, MRR e nDCG (binário e graduado);
- [Métricas no Gabarito Próprio (Parte D)](estrutura/codigos/2026-09-18-appa-Atividade05b-ParteD-MetricasGabaritoProprio.r): avaliação comparativa entre BM25 e TF-IDF contra o qrels do projeto;
- [Espaço Vetorial e Cosseno (Aula 02)](estrutura/codigos/2026-10-09-appa-Aula02-EspacoVetorial.R): implementações geradas via tutora (cosseno, normalização, etc);
- [Motor Cosseno (Parte D)](estrutura/codigos/2026-10-09-appa-Aula02-ParteD-MotorCosseno.R): script da sessão de grupo ranqueando o corpus real com o modelo do espaço vetorial;
- [Realimentação de Relevância e Rocchio](estrutura/codigos/2026-10-09-appa-Atividade06-RocchioFeedback.r): implementação de Rocchio para expansão de consulta;
- [Arquivo de Configuração do Grupo (`estrutura/codigos/config.R`)](estrutura/codigos/config.R): parâmetros canônicos do grupo APPA (`minimo = 50`, `grupo = "APPA"`).

## Ficha do Projeto e Governança

- **[Ficha do Projeto Oficial](consolidados/00_FICHA_PROJETO.md)**: documento canônico de memória contínua do projeto integrador, detalhando tema regional, usuários, perguntas de busca, fonte aberta (Wikipédia CC BY-SA 4.0), estatísticas do corpus (141 documentos, 3.073 termos), pipeline de módulos e estado do R.

## Entregas Formais

A pasta [entregas/](entregas/) reúne a entrega final e os modelos da disciplina:

- **[entregas/finalizada/](entregas/finalizada/):** versão final consolidada do grupo APPA:
  - [Entrega 1: Corpus do Projeto (PDF)](entregas/finalizada/2026-10-02-appa-entrega-1-corpus.pdf) ([Fonte Sweave](entregas/finalizada/2026-10-02-appa-entrega-1-corpus.Rnw))
- **[entregas/modelo_base/](entregas/modelo_base/):** modelos e templates originais fornecidos pela disciplina:
  - [Modelo Base: Corpus do Projeto](entregas/modelo_base/entrega-1-corpus.pdf) ([Fonte Sweave](entregas/modelo_base/entrega-1-corpus.Rnw))
  - [Modelo Base: Pergunta do Trabalho](entregas/modelo_base/entrega-1-pergunta.pdf) ([Fonte Sweave](entregas/modelo_base/entrega-1-pergunta.Rnw))

## Atividades e Consolidados

- **Aulas 00 e 01 (Fundamentos):** Disponíveis no repositório [pi3-aulas-00-01](https://github.com/Arthur-galvao/pi3-aulas-00-01)
- [02: TF-IDF e cosseno](consolidados/2026-09-15-appa-Atividade02-TfIdfCosseno.md)
- [02: teoria e cosseno (novo)](consolidados/2026-10-09-appa-Atividade02-ConsolidadoTeoria.md)
- [02: prática e motor de busca (novo)](consolidados/2026-10-09-appa-Atividade02-ParteD-MotorCosseno.md)
- [03: pré-processamento e índice](consolidados/2026-09-15-appa-Atividade03-PreProcessamentoIndice.md)
- [04: Poisson, saturação e BM25](consolidados/2026-09-15-appa-Atividade04-PoissonBm25.md)
- [05: avaliação do motor](consolidados/2026-09-15-appa-Atividade05-AvaliacaoMotor.md)
- [05b: métricas de avaliação teóricas](consolidados/2026-09-18-appa-Atividade05b-MetricasAvaliacao.md)
- [05b: métricas no gabarito próprio (Parte D)](consolidados/2026-09-18-appa-Atividade05b-ParteD-MetricasGabaritoProprio.md)
- [06: expansão de consulta e Rocchio](consolidados/2026-10-09-appa-Atividade06-RocchioFeedback.md)

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

- `2026-09-15-appa-05-julgar.html`: página offline para dar notas 0, 1 ou 2;
- `2026-09-15-appa-05b-montar-corpus.R`: salva os 141 parágrafos do corpus atual;
- `2026-09-15-appa-05c-ficha-corpus.R`: confere linhas, colunas e duplicidades;
- `2026-09-15-appa-05d-gerar-pool.R`: cria os pares necessidade-documento;
- `2026-09-15-appa-05a-kappa.R`: calcula a concordância entre dois juízes;
- `2026-09-15-appa-05e-gerar-qrels-inicial.R`: preenche a referência inicial do projeto;
- `csv/`: corpus, necessidades, pool e arquivo de julgamentos.

## Guias e aplicações

- [Resoluções individuais de todos os guias](resolucoes/)
- [Consolidados da teoria e das Partes D](consolidados/)
- [07: LSA e fusão de rankings](consolidados/2026-10-25-appa-Atividade07-LsaFusaoRankings.md)
- [Guias originais completos 00–07](tutoras/)

```powershell
Rscript estrutura/codigos/executar_guias_teoria.R
Rscript estrutura/codigos/2026-10-25-appa-GuiasEstudo.R
Rscript estrutura/codigos/aula07_lsa.R
```

Os motores do professor estão fixados localmente com autoria e commit. As métricas usam
o corpus congelado e o julgamento assistido identificado; os votos humanos continuam separados.

A atualização inclui os fundamentos localmente: [Shannon](consolidados/2026-10-25-appa-Atividade01b-Shannon.md), coleta reproduzível e demonstração em `estrutura/codigo/aula02.R`.

Executar todas as etapas: `Rscript estrutura/codigos/executar_atualizacao.R`. Dependências: SnowballC e ggplot2. Os PDFs históricos permanecem preservados; revisões atuais estão nos consolidados em Markdown.

No Windows, execute `powershell -ExecutionPolicy Bypass -File .\executar_atualizacao.ps1`. Em outro ambiente, use R instalado no PATH.

## Guias da Aula 07 — versão 2

A Aula 07 compara LSA, BM25 e fusão RRF no corpus do APPA.

- [Teoria resolvida: seis módulos, checkpoints, teste e tarefa individual](resolucoes/aula07_resolvido.md)
- [Consolidado individual com estado real do R](consolidados/aula07_consolidado.md)
- [Parte D resolvida: comparação dos textos e decisão](resolucoes/aula07_parteD_resolvido.md)
- [Consolidado do grupo com estado real do R](consolidados/aula07_parteD_consolidado.md)
- [Notebook da teoria](estrutura/codigo/aula07_teoria.ipynb) e [notebook da Parte D](estrutura/codigo/aula07.ipynb)

```powershell
Rscript estrutura/codigo/aula07_teoria.R
Rscript estrutura/codigo/aula07.R
```

A avaliação atual varre os candidatos apenas no desenvolvimento e mede no teste somente BM25
e o escolhido. As consultas de teste já eram conhecidas: a ressalva de teste retrospectivo permanece.
As cópias da configuração têm `modelo="hibrido"`, `lsa_k=20`, `rrf_c=60`, com `prf_k=0`.

## Referências

Materiais da disciplina: [Danilo — Projeto Integrador III](https://github.com/danilopradooficial/projetointegrador3), versão `677788d`. Motor de referência: [origem e autoria](estrutura/codigos/motor-professor/ORIGEM.md).
