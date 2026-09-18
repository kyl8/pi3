# Atividade 03: limpeza e índice

Os scripts do grupo já fazem a limpeza básica do corpus: conversão para minúsculas, remoção de pontuação e retirada de stopwords em português.

Essa etapa é importante porque a consulta precisa passar pelo mesmo tratamento usado nos documentos. Assim, o motor compara unidades equivalentes e evita que palavras gramaticais dominem as frequências.

O TF-IDF mantém os parágrafos como documentos e organiza a matriz para a busca. A versão BM25 mais recente também aplica stemming com SnowballC e cria um índice invertido para as consultas booleanas.

## Como foi implementado

O índice deve guardar, para cada termo, a lista de documentos em que ele aparece. Uma consulta `AND` usa a interseção dessas listas. Uma consulta `OR` usa a união. Isso evita percorrer todo o texto a cada busca.

O stemming com SnowballC deve ser aplicado tanto no corpus quanto na consulta. Sem o mesmo tratamento nos dois lados, uma busca por uma forma da palavra pode não encontrar suas flexões.

O ranking continua usando a matriz termo documento, porque precisa da frequência de cada stem. A busca booleana usa o índice invertido, que retorna diretamente os documentos associados ao termo.

## Material

[Aula 03](../materiais-aulas/Aula%2003%20-%20Limpeza%20de%20Texto%2C%20Stopwords%2C%20Stemming%20e%20o%20Indice.PDF).
