# Atividade 02: TF-IDF e similaridade do cosseno

O segundo motor trabalha com os parágrafos dos três artigos. Cada parágrafo recebe um identificador `d1`, `d2` e assim por diante, além da informação sobre o clube de origem.

## O que foi implementado

- matriz termo documento;
- pesos TF-IDF;
- similaridade do cosseno entre consulta e parágrafo;
- busca booleana com `AND`, `OR` e `NOT`;
- exibição dos parágrafos recuperados como snippets.

O script é [2026-08-25-appa-MotorBuscaTfIdf.r](../estrutura/codigos/2026-08-25-appa-MotorBuscaTfIdf.r).

O cosseno compara a direção dos vetores e reduz o efeito do tamanho bruto do texto. Ainda assim, a frequência cresce de forma linear, o que motiva a etapa seguinte.

## Fluxo de uma consulta

O motor tokeniza a consulta, remove as stopwords, monta um vetor com o mesmo vocabulário da matriz e calcula um score para cada parágrafo. Os documentos com score zero são descartados e os demais são ordenados do maior para o menor.

Na busca booleana, a ordem não é calculada pelo score. O resultado é obtido combinando conjuntos de documentos que contêm cada termo. Essa diferença entre filtro e ranking fica registrada no consolidado para evitar que as duas operações sejam confundidas.

## Material

[Aula 02](../materiais-aulas/Aula%2002%20-%20Vetores%20TF-IDF%20e%20Similaridade%20do%20Cosseno.PDF).

## Nota de Revisão Metodológica (Alinhamento com Aula 02 e Guia de Estudo 02)
- **Base Logarítmica ($\log_{10}$) e Normalização do Cosseno**: A ponderação TF-IDF segue a definição normativa com logaritmo na base 10 ($\text{TF}(t,d) = 1 + \log_{10}(f_{t,d})$ para $f_{t,d} > 0$ e $\text{IDF}(t) = \log_{10}\left(\frac{N+1}{\text{DF}_t+1}\right)$), e a similaridade do cosseno divide o produto escalar pelo produto das normas euclidianas $\|\vec{q}\|_2 \|\vec{d}\|_2$, mantendo a pontuação estritamente em $[0, 1]$.
