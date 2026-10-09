# Atividade 06: Rocchio, expansão de consulta e pseudo-feedback

Nesta atividade, exploramos o algoritmo de Rocchio para realizar a expansão de consultas a partir de feedback de relevância explícito (realimentação de relevância) e pseudo-feedback (feedback cego), ajustando a consulta inicial no modelo de espaço vetorial (TF-IDF e Cosseno) para refletir de maneira mais rica a necessidade do usuário.

## Procedimento

1. **Implementação do motor base:** vetorização (TF-IDF) para o corpus de 8 documentos da aula.
2. **Algoritmo de Rocchio:** implementação da função `rocchio` que recebe o vetor da consulta original, os índices dos documentos marcados como relevantes e não relevantes, e os parâmetros de ponderação ($\alpha$, $\beta$ e $\gamma$).
3. **Feedback explícito:** avaliação da consulta original *"modelo de recuperacao"*. Com base nos resultados, o usuário marca `d2` e `d3` como relevantes, e `d4` como não relevante. Essa informação é usada para empurrar o vetor de consulta em direção aos relevantes e afastá-lo do não relevante.
4. **Pseudo-feedback:** aplicação de uma automação que assume que os *top-2* documentos do ranking base são relevantes, aplicando o algoritmo de Rocchio sem a intervenção do usuário.

O script [2026-10-09-appa-Atividade06-RocchioFeedback.r](../estrutura/codigos/2026-10-09-appa-Atividade06-RocchioFeedback.r) executa todo esse fluxo.

## Discussão dos Resultados

### Realimentação com Usuário
Na busca base pela consulta *"modelo de recuperacao"*, os documentos contendo os termos exatos são priorizados.
Com a realimentação de relevância (marcando `d2` e `d3` como relevantes, e `d4` como não relevante), a nova consulta ganha peso em termos que sequer haviam sido digitados (por exemplo, "bm25", "espaco", "vetorial"). Essa expansão afasta o resultado do documento `d4` (que cai consideravelmente, inclusive assumindo um valor de cosseno negativo ou zerado dependendo do tratamento de pesos negativos) e impulsiona `d2` e `d3` para o topo do novo ranking. A consulta passa a "entender" melhor o contexto (expansão semântica).

### Pseudo-feedback (Feedback Cego)
A implementação do pseudo-feedback assume automaticamente os primeiros documentos (*top-2* da busca original) como relevantes e roda a expansão sobre eles. 
Essa abordagem tem a vantagem de não exigir esforço adicional do usuário. Contudo, traz o grande risco de **query drift** (desvio da consulta): se a busca original (base) retornar documentos espúrios ou equivocados nas primeiras posições, o algoritmo expandirá a consulta adicionando termos incorretos. Isso empurrará a segunda busca para uma direção errada, frequentemente piorando a precisão geral dos resultados em vez de melhorá-la. É recomendado utilizar um conjunto pequeno para *k* e um valor moderado para $\beta$ na tentativa de mitigar o risco de *drift*.

## Material

- [Aula 06 - Rocchio, expansão de consulta e pseudo-feedback](../materiais-aulas/Aula%2006%20-%20Rocchio.PDF)
