# Atividade 04: Poisson, saturação e BM25

O BM25 melhora o ranqueamento do TF-IDF em dois pontos: repetições do mesmo termo têm ganho decrescente e documentos muito longos recebem uma correção de tamanho.

## No código do grupo

O script calcula a frequência dos termos, a frequência de documentos, o tamanho de cada parágrafo e o tamanho médio do corpus. Depois aplica o IDF probabilístico e a fórmula BM25 com `k1 = 1.2` e `b = 0.75`.

Também existe um comparativo direto entre BM25 e TF-IDF usando as mesmas consultas. Isso permite observar quando os modelos mantêm a mesma ordem e quando a saturação altera a posição dos parágrafos.

## Fórmula usada

Para cada termo da consulta, o script soma:

`IDF(t) × f(t,d) × (k1 + 1) / (f(t,d) + K)`

com `K = k1 × (1 - b + b × tamanho(d) / tamanho_medio)`. O código calcula `df`, `dl` e `avgdl` antes da busca, exatamente na ordem necessária para a fórmula.

O parâmetro `k1` controla a velocidade da saturação da frequência. O parâmetro `b` controla quanto o tamanho do parágrafo interfere no resultado. Alterar esses valores pelo menu muda o ranking sem precisar reconstruir o corpus.

## Limite da comparação

O código compara os dois modelos. A avaliação inicial da Atividade 05 calcula precisão, revocação e posição do primeiro resultado relevante em dez posições. MAP e NDCG ainda dependem de um gabarito humano mais detalhado.

O script é [2026-09-04-appa-MotorBuscaBm25.r](../estrutura/codigos/2026-09-04-appa-MotorBuscaBm25.r).

## Material

[Aula 04](../materiais-aulas/Aula%2004%20-%20Satura%C3%A7%C3%A3o%2C%20Tamanho%20de%20Documento%20e%20Ranqueamento.PDF).
