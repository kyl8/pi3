# Aula 02b: aplicando TF-IDF e cosseno no projeto APPA

Esta parte leva os conceitos da Aula 02 para o motor do grupo.

## Preparação

A partir da raiz do repositório, execute:

```r
source("estrutura/codigos/2026-08-25-appa-MotorBuscaTfIdf.r")
```

O script coleta ou atualiza o corpus, normaliza os textos, monta a matriz termo-documento e disponibiliza a busca por TF-IDF, cosseno e operadores booleanos.

## Atividade prática

1. Defina duas necessidades de informação sobre os clubes. Escreva primeiro a pergunta completa e só depois a consulta curta.
2. Rode cada consulta pelo cosseno e pela busca booleana.
3. Salve os cinco primeiros resultados de cada método, com identificador, título ou trecho e escore.
4. Escolha um resultado que pareça bem posicionado e explique-o pelos termos e seus pesos.
5. Escolha um resultado ausente ou mal posicionado e diga se o problema é vocabulário, tamanho do parágrafo ou falta de informação no corpus.

## Cuidados

Use os mesmos identificadores do corpus. Não renomeie documentos depois de criar resultados ou qrels. O corpus vem de páginas públicas e pode mudar quando a fonte for atualizada, então registre a data de execução e o total de documentos.

## Entrega

Atualize o consolidado da Atividade 02 com as consultas, os rankings e a interpretação. O foco não é declarar qual modelo venceu, mas mostrar como TF-IDF e cosseno transformam os textos em uma ordenação verificável.
