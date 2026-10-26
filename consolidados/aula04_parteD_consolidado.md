# Consolidado — PI III — Aula 04 — Parte D — 2026-10-25
**Grupo:** APPA · **Solicitante:** Pedro Henrique · **Apoio:** Codex.
Preparação e execução automatizadas. Presenças, rodízio e concordância dos colegas não foram observados.

## 1. O que foi feito
- M10 — O que o BM25 exige, no corpus do grupo
- M11 — As três consultas de trabalho, nos dois modelos
- M12 — Variar $k_1$ e $b$, e decidir

O documento mais longo após preparo é `d54`, de Santos FC, com 220 termos. O comprimento médio é 56,922. Com os parâmetros APPA, seu $K$ é 4,723. Uso $K=k_1(1-b+b|d|/\overline{|d|})$. A grade explora $k_1\in\{0;1{,}2;1{,}5;2\}$ e $b\in\{0;0{,}75;1\}$. Com $k_1=0$, cada termo presente vale apenas seu IDF: repetir não aumenta a contribuição; termos ausentes continuam zero.


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
