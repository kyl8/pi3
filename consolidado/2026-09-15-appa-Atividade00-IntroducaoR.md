# Atividade 00: introdução ao R

O projeto usa R para carregar textos, separar palavras, contar termos e comparar documentos. Os scripts podem ser executados no RStudio ou pelo terminal.

## Preparação

É preciso ter R instalado e conexão com a internet, porque o corpus é carregado das páginas da Wikipédia durante a execução. Os scripts usam recursos da biblioteca padrão do R.

O ponto de entrada mais completo é [2026-09-04-appa-MotorBuscaBm25.r](../estrutura/codigos/2026-09-04-appa-MotorBuscaBm25.r).

## Organização do trabalho

Os documentos são tratados como vetores de palavras. Primeiro o texto é coletado, depois é limpo e transformado em uma estrutura de contagens. A partir dela, cada modelo calcula uma pontuação diferente.

O projeto mantém uma versão simples para entender a busca e versões mais completas para comparar ranking. Essa ordem ajuda a conferir cada parte antes de juntar tudo no motor final.

## Reprodutibilidade

O corpus é obtido pela internet e pode mudar. Por isso, uma execução deve registrar a data da coleta, a quantidade de parágrafos e os parâmetros usados no ranking.

## Material

[Aula 00](../materiais-aulas/Aula%2000%20-%20O%20B%C3%A1sico%20para%20Acompanhar%20o%20Curso.PDF).
