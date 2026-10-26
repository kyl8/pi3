# Consolidado — PI III — Aula 03 — Parte D — 2026-10-25
**Grupo:** APPA · **Solicitante:** Pedro Henrique · **Apoio:** Codex.
Preparação e execução automatizadas. Presenças, rodízio e concordância dos colegas não foram observados.

## 1. O que foi feito
- M10 — Limpar o corpus do grupo, e a decisão dos acentos
- M11 — As *stopwords* do projeto
- M12 — Índice invertido e busca AND no corpus do grupo

Adotei transliteração antes da regex para preservar São/Sao como a mesma palavra. Removo as stopwords explícitas do config e preservo nomes de clubes, estádios e pessoas. O vocabulário passou de 3073 formas brutas para 1902 radicais após limpeza, stopwords e Snowball. O índice tem 1902 entradas. Corpus e consultas usam exatamente `preparar()`; a busca AND devolve vazio se um termo não está no índice.


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
