# Atividade 05: avaliação do motor

A avaliação precisa comparar os resultados do motor com julgamentos de relevância. Para o corpus da Baixada Santista, podem ser criadas necessidades como encontrar informações sobre a história de um clube, seus títulos, estádio ou rivalidades.

## Procedimento

1. escrever as necessidades em linguagem natural;
2. executar as consultas em TF-IDF e BM25;
3. juntar os resultados em uma lista de avaliação;
4. marcar cada parágrafo como relevante, parcialmente relevante ou irrelevante;
5. comparar os julgamentos e calcular métricas de recuperação.

O script [2026-09-15-appa-Atividade05-AvaliacaoMotor.r](../estrutura/codigos/2026-09-15-appa-Atividade05-AvaliacaoMotor.r) executa consultas de teste, compara BM25 e TF-IDF e salva as métricas em `estrutura/resultados`.

O gabarito atual é uma primeira versão automática por clube de origem. Ele serve para testar o pipeline. Antes da entrega final, deve ser revisado por avaliadores humanos, porque pertencer ao mesmo clube não garante que um parágrafo responda à necessidade.

## Cuidados com a comparação

Os julgamentos devem ser feitos a partir da necessidade escrita, e não somente pela presença das palavras da consulta. Também é melhor misturar resultados dos modelos antes da avaliação, para não favorecer o primeiro sistema exibido.

Uma avaliação mínima precisa guardar o identificador da necessidade, o documento, a nota dada e o avaliador. Com esses dados será possível calcular concordância entre juízes e métricas de ranking. O corpus também deve ser salvo, porque a Wikipédia pode alterar os parágrafos depois da coleta.

## Primeiro resultado

O script executou seis consultas sobre os 141 parágrafos coletados. Considerando como relevantes os parágrafos do clube esperado, a média em dez posições foi:

| Modelo | Precisão em 10 | Revocação em 10 | Reciprocal rank |
|---|---:|---:|---:|
| BM25 | 0,733 | 0,250 | 0,750 |
| TF-IDF | 0,750 | 0,252 | 0,833 |

Esse resultado é apenas um teste do pipeline. O gabarito por clube é amplo demais para decidir qual modelo é melhor. A comparação final precisa de julgamentos humanos por parágrafo.

## Material

[Aula 05](../materiais-aulas/Aula%2005%20-%20Julgamento%2C%20Pooling%20e%20Concord%C3%A2ncia%20Entre%20Ju%C3%ADzes.PDF), [guia de estudo](../materiais-aulas/Aula%2005a%20-%20GUIA_ESTUDO_aula05.md) e [orientação para julgamento](../materiais-aulas/Aula%2005b%20-%20PROMPT_LLM_julgamento_relevancia.md).

## Arquivos da coleta humana

A coleta ficou em [estrutura/codigos/05-julgamento](../estrutura/codigos/05-julgamento). O HTML mistura os resultados dos modelos, embaralha os documentos e registra notas de 0 a 2 com o nome do juiz. Os arquivos `2026-09-15-appa-05-corpus.csv`, `2026-09-15-appa-05-necessidades.csv` e `2026-09-15-appa-05-pool.csv` ja foram gerados para os 141 paragrafos do corpus.

O arquivo `2026-09-15-appa-05-qrels.csv` esta apenas com o cabecalho porque os julgamentos precisam ser feitos por pessoas. Depois de duas coletas sobre os mesmos itens, o script `2026-09-15-appa-05a-kappa.R` calcula a concordancia entre os juizes.