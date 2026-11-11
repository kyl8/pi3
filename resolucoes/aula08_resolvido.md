# Aula 08 — Recuperação e reordenação

**Apoio:** ChatGPT.

1. Com limiar 1, há quatro relevantes; o último está na sexta posição. O menor k é 6 e R@3 = 3/4 = 0,75.
2. Cinquenta consultas com top-20 exigem 1.000 leituras de pares; pontuar todos os 2.000 documentos exigiria 100.000. Os 2.000 vetores de documento são calculados uma vez para reutilização.
3. Na consulta `modelo de texto`, d3 recebe 0,5 pelo par `modelo`/`de` e 1 pelo par `de`/`texto`, total 1,5. Em d2 o total é 1; d3 fica na frente.
4. Com k=3, o ranking é `d1 d6 d2 d5 d3 d8 d4 d7`; d1 e d6 empatam e preservam sua ordem anterior.
5. Em `ordena documentos relevancia` contra d1, `documentos` seguido de `relevancia` à distância dois contribui 0,5; a forma `ordena` é necessária para coincidir literalmente. A proximidade lexical não reconhece sinônimos; um modelo treinado pode aprender relações contextuais.
6. Para MAP 0,64 com k=10 e k=20, escolhe-se k=10 por igual desempenho e menor custo. O teste não é usado para desempatar escolhas.

O [código da Parte D](../estrutura/codigo/aula08.R) avalia a grade e o [consolidado](../consolidados/aula08_parteD_consolidado.md) registra o resultado no corpus APPA com julgamento assistido.

## Teste final — resolução com apoio de IA

1. O relevante permanece em 80º: só os 50 primeiros são reordenados.
2. Um cross-encoder calcula o escore a partir do par consulta-documento; a representação conjunta depende da consulta, ao contrário do vetor pré-computado de documento do LSA.
3. `modelo vetorial` em d2: distância 3, escore $1/3$. Na ordem inversa, escore zero.
4. `B C A D E`: B e C empatam e preservam a ordem; D fica na cauda, mesmo com escore maior.
5. `informacao recuperacao` em d1 dá zero porque a ordem no documento é inversa. Um modelo treinado pode reconhecer a relação semântica, sem garantia de acerto.
6. Escolhe-se k=10 pelo empate de MAP e menor custo; o teste não deve desempatar.

## Tarefa: duas consultas no corpus didático

O script [aula08_tarefa.R](../estrutura/codigo/aula08_tarefa.R) gera rankings completos e textos em [CSV](../estrutura/resultados/aula08-tarefa-teoria.csv). Para `modelo vetorial`, BM25, top-2 e top-4 começam `d2 d3 d1 d4`; d2 descreve o modelo de espaço vetorial e já era o primeiro. A proximidade não mudou a ordem.

Para `documentos busca`, os três começam `d5 d7 d1 d6`. d5 trata de índice que acelera a busca em documentos, embora as palavras apareçam na ordem inversa à consulta; d7 trata de avaliação de resultados de busca. A proximidade não alterou os quatro primeiros e não reconhece que a ordem inversa em d5 ainda faz sentido. Essa é uma análise assistida dos textos, não uma avaliação de desempenho individual.
