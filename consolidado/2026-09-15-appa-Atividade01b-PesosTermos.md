# Atividade 01b: pesos dos termos

Esta atividade apresenta a ideia de que uma palavra comum no corpus informa menos do que uma palavra rara. O IDF mede essa diferença usando a frequência de documentos que contêm o termo.

No projeto, o peso é usado junto com a frequência do termo para preparar o ranqueamento. A análise deve sempre informar o tamanho do corpus, a frequência de documentos e a fórmula escolhida.

## Relação com o corpus do grupo

Se um termo aparece em muitos parágrafos dos três clubes, seu IDF fica baixo. Um termo que aparece em poucos parágrafos recebe mais peso. O resultado depende do corpus carregado na hora, pois as páginas da Wikipédia podem mudar.

O PI3 usa o logaritmo natural, como nos scripts. O peso básico usado no TF-IDF é:

`peso(t, d) = frequência(t, d) × log(N / df(t))`

Esse cálculo não diz se um parágrafo responde à necessidade do usuário. Ele apenas mede a distribuição dos termos e serve para ordenar candidatos.

## Exemplo de interpretação

Se `santos` aparece em quase todos os parágrafos, o termo ajuda pouco a distinguir os documentos. Se `estádio` aparece em poucos parágrafos, ele pesa mais quando coincide com a consulta. O peso final sempre depende da frequência no documento e da raridade no conjunto inteiro.

Essa etapa prepara a matriz usada na Atividade 02. O código não deve remover termos raros só porque aparecem poucas vezes, pois eles podem ser justamente os melhores sinais para uma consulta específica.

O cálculo aparece integrado aos scripts de TF-IDF e BM25 do grupo. Esta etapa não foi mantida como um script separado no repositório.

## Material

[Aula 01b](../materiais-aulas/Aula%2001b%20-%20Do%20Shannon%20aos%20Pesos%20dos%20Termos.PDF).
