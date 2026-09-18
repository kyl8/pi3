# Atividade 01: corpus e busca direta

O primeiro motor monta um corpus com três artigos da Wikipédia: Santos Futebol Clube, Portuguesa Santista e Jabaquara Atlético Clube.

## Como funciona

O texto é baixado, convertido para minúsculas e separado em tokens. O usuário pode pesquisar um ou mais termos, ver as frases encontradas, consultar estatísticas e alternar o uso de stopwords.

O script desta etapa é [2026-08-20-appa-MotorBuscaInicial.r](../estrutura/codigos/2026-08-20-appa-MotorBuscaInicial.r).

## Resultado da busca

Para cada consulta, o programa mostra os documentos com ocorrência dos termos e depois exibe as frases correspondentes. As estatísticas mostram a quantidade de documentos, tokens e termos distintos depois do filtro escolhido.

O menu também permite ligar e desligar as stopwords. Isso deixa visível o efeito de palavras muito comuns sobre a frequência dos termos.

## Limite da primeira versão

Os documentos ainda são comparados por contagem bruta. Uma palavra repetida muitas vezes pode fazer um texto subir mesmo quando ela aparece em quase todo o corpus. A atividade seguinte introduz pesos para reduzir esse problema.

## Limitação

A busca conta ocorrências literais. Palavras com acento, flexões e termos relacionados podem ser tratados como palavras diferentes.

## Material

[Aula 01a](../materiais-aulas/Aula%2001a%20-%20Do%20Problema%20da%20Busca%20ao%20Nosso%20Motor.PDF).
