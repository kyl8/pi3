# Consolidado — PI III — Aula 03 — Parte D — 2026-10-25
**Grupo:** APPA · **Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana · **Apoio:** ChatGPT.

## 1. O que foi feito
- M10 — Limpar o corpus do grupo, e a decisão dos acentos
- M11 — As *stopwords* do projeto
- M12 — Índice invertido e busca AND no corpus do grupo

Adotamos transliteração antes da regex para preservar São/Sao como a mesma palavra. Removemos as stopwords explícitas do config e preservo nomes de clubes, estádios e pessoas. O vocabulário passou de 3073 formas brutas para 1902 radicais após limpeza, stopwords e Snowball. O índice tem 1902 entradas. Corpus e consultas usam exatamente `preparar()`; a busca AND devolve vazio se um termo não está no índice.


## 2. Como o grupo trabalhou — opinião da tutora
Seguimos a cadeia de limpeza, tratamento dos acentos, remoção de stopwords e stemming antes
de montar o índice invertido. Comparamos as formas brutas com os radicais e preservamos os termos
importantes para identificar clubes e estádios. Aplicamos a mesma função de preparação ao corpus
e às consultas, conferindo também o retorno vazio quando um termo da busca AND não existe no índice.

**Verificação final:** preparação e índice usam a mesma configuração nos documentos e nas consultas.

## 3. Observações para a frente
- **Produzido:** código `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R`, roteiros em
  `estrutura/codigos/guias/` e saídas em `estrutura/resultados/guias/`.
- **Ficha:** decisões e parâmetros atualizados em `consolidados/00_FICHA_PROJETO.md`.
- **Perguntas guardadas:** ampliar julgamentos, testar consultas inéditas e medir concordância humana.
- **Limite da evidência:** resultados sobre pool parcial e referência assistida; não equivalem a validação por três juízes humanos.
