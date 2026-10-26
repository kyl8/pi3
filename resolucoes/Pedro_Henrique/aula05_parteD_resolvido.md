# Consolidado — PI III — Aula 05 — Parte D — 2026-10-25
**Grupo:** APPA · **Solicitante:** Pedro Henrique · **Apoio:** Codex.
Preparação e execução automatizadas. Presenças, rodízio e concordância dos colegas não foram observados.

## 1. O que foi feito
- M9 — Congelar o corpus: de `docs` a `corpus.csv`
- M10 — As necessidades, e o que é teste
- M11 — O guia de julgamento
- M12 — A ferramenta: `julgar.html`, e quem julga o quê
- M13 — Julgar, e medir a concordância

O corpus congelado tem 141 textos e a pool tem 66 pares necessidade-documento. Preparei julgamento assistido com autoria `codex_assistido`, separado da referência heurística antiga e das três planilhas humanas vazias. Limiar: grau dois responde diretamente à necessidade. Não calculo kappa entre humanos sem votos reais. O exercício didático de kappa foi executado. As consultas foram divididas em desenvolvimento e teste retrospectivo antes desta nova seleção; como já apareciam em análises anteriores, não afirmo que o teste seja inédito.


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
