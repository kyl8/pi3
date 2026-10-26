# Consolidado — PI III — Aula 05 — Parte D — 2026-10-25
**Grupo:** APPA · **Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana · **Apoio:** ChatGPT.

## 1. O que foi feito
- M9 — Congelar o corpus: de `docs` a `corpus.csv`
- M10 — As necessidades, e o que é teste
- M11 — O guia de julgamento
- M12 — A ferramenta: `julgar.html`, e quem julga o quê
- M13 — Julgar, e medir a concordância

O corpus congelado tem 141 textos e a pool tem 66 pares necessidade-documento. Usamos julgamento assistido identificado como `codex_assistido`, separado da referência heurística antiga e das três planilhas humanas vazias. Limiar: grau dois responde diretamente à necessidade. Não calculamos kappa entre humanos sem votos reais. O exercício didático de kappa foi executado. As consultas foram divididas em desenvolvimento e teste retrospectivo antes desta nova seleção; como já apareciam em análises anteriores, não tratamos o teste como inédito.


## 2. Como o grupo trabalhou — opinião da tutora
Estruturamos o fluxo em congelamento do corpus, definição das necessidades, formação da pool
e aplicação da escala de relevância. Mantivemos o julgamento assistido separado da referência
heurística e dos arquivos destinados aos juízes humanos. O exercício de kappa foi usado para
interpretar concordância sem confundi-lo com uma medição sobre os votos do projeto.
A separação entre desenvolvimento e teste retrospectivo foi registrada para orientar as avaliações.

**Verificação final:** 141 documentos e 66 pares rastreáveis; origem dos julgamentos identificada.

## 3. Observações para a frente
- **Produzido:** código `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R`, roteiros em
  `estrutura/codigos/guias/` e saídas em `estrutura/resultados/guias/`.
- **Ficha:** decisões e parâmetros atualizados em `consolidado/00_FICHA_PROJETO.md`.
- **Perguntas guardadas:** ampliar julgamentos, testar consultas inéditas e medir concordância humana.
- **Limite da evidência:** resultados sobre pool parcial e referência assistida; não equivalem a validação por três juízes humanos.
