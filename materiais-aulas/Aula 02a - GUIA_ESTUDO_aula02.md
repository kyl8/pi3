# Aula 02a: TF-IDF e similaridade do cosseno

Este guia acompanha a Aula 02 do Projeto Integrador III e usa o corpus APPA sobre clubes tradicionais da Baixada Santista.

## Objetivo

Entender como texto vira vetor, por que termos raros recebem mais peso e como o cosseno ordena documentos para uma consulta.

## Antes de estudar

Abra o PDF da Aula 02 e deixe disponível o script `estrutura/codigos/2026-08-25-appa-MotorBuscaTfIdf.r`. O script parte do corpus criado na Aula 01 e produz os rankings do motor.

## Roteiro

1. Escolha duas consultas curtas sobre o corpus, como `titulos santos` ou `estadio portuguesa santista`.
2. Identifique quais termos aparecem em cada documento e monte uma pequena matriz termo-documento.
3. Calcule TF para um termo em dois documentos. Depois compare o IDF de um termo comum, como o nome de um clube, com o IDF de uma palavra rara.
4. Explique o TF-IDF: frequência no documento multiplicada pela capacidade de distinguir documentos no corpus.
5. Rode a busca por cosseno e observe que o resultado não depende só de existir uma palavra, mas do peso do conjunto de termos.
6. Compare a ordem obtida pelo cosseno com a busca direta da Aula 01.

## Perguntas para o consolidado

- Que termo teve peso baixo por aparecer em muitos documentos?
- Qual documento ganhou posição por combinar melhor os termos da consulta?
- Em que situação a busca booleana seria mais rígida que o cosseno?

Registre a consulta, os primeiros documentos retornados e uma explicação curta da ordem. Não trate um ranking plausível como prova de qualidade: a comparação contra um qrels começa na Aula 05.
