# Consolidado — PI III — Aula 02 — Parte D — 2026-10-25
**Grupo:** APPA · **Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana · **Apoio:** ChatGPT.

## 1. O que foi feito
- M9 — Os vetores sobre o corpus do grupo
- M10 — As três consultas de trabalho
- M11 — Onde o cosseno erra, no corpus do grupo

A matriz tem 1902 termos e 141 documentos na representação limpa do grupo. O documento de maior norma é `d54`, de Santos FC, com norma 75,094. A normalização retira a vantagem de escala, mantendo a direção. Os seis top-5 com texto estão no CSV `aula02_04_top5_com_textos.csv`; uma busca não encontra sinônimos ausentes apenas pelo cosseno.


## 2. Como o grupo trabalhou — opinião da tutora
Estruturamos a atividade em montagem dos vetores, execução das consultas e leitura dos resultados.
Comparamos as normas antes e depois da normalização e relacionamos a posição de cada documento
aos termos que contribuem para o cosseno. Na análise do top-5, usamos o texto dos documentos para
distinguir coincidência lexical de resposta à necessidade de informação. A limitação com sinônimos
ficou registrada como ponto de evolução do motor.

**Verificação final:** matriz, consultas e rankings acompanhados de resultados reproduzíveis.

## 3. Observações para a frente
- **Produzido:** código `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R`, roteiros em
  `estrutura/codigos/guias/` e saídas em `estrutura/resultados/guias/`.
- **Ficha:** decisões e parâmetros atualizados em `consolidados/00_FICHA_PROJETO.md`.
- **Perguntas guardadas:** ampliar julgamentos, testar consultas inéditas e medir concordância humana.
- **Limite da evidência:** resultados sobre pool parcial e referência assistida; não equivalem a validação por três juízes humanos.
