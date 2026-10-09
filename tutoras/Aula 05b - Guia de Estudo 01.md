# Aula 05b: métricas para avaliar o motor

Este guia acompanha a parte de métricas da Aula 05. Ele usa o motor do grupo APPA, o corpus sobre clubes da Baixada Santista e o qrels produzido na atividade de julgamento.

## Objetivo

Ao terminar, você deve conseguir ler um ranking, compará-lo com o gabarito e explicar o que cada métrica mede. A conta vem antes do código: o script só confirma o resultado.

## Antes de começar

Tenha estes arquivos disponíveis:

- `estrutura/codigos/2026-09-18-appa-Atividade05b-MetricasAvaliacao.r`;
- `estrutura/codigos/2026-09-18-appa-Atividade05b-ParteD-MetricasGabaritoProprio.r`;
- `estrutura/codigos/05-julgamento/csv/05-qrels.csv`;
- os consolidados das atividades 04 e 05.

## Roteiro de estudo

1. Escolha uma necessidade de informação e anote o ranking devolvido por TF-IDF e BM25.
2. Defina antes do cálculo qual limiar transforma os graus 0, 1 e 2 em relevância binária. No projeto, `grau >= 1` considera material útil; `grau >= 2` considera apenas o mais diretamente pertinente.
3. Monte o vetor `rel`: 1 para documento relevante, 0 para os demais, na mesma ordem do ranking.
4. Calcule e interprete:
   - **P@k**: quantos documentos relevantes aparecem nos primeiros `k` resultados;
   - **recall**: quantos dos relevantes conhecidos foram recuperados;
   - **AP**: média da precisão nos pontos em que aparece um relevante;
   - **MRR**: posição do primeiro resultado relevante;
   - **nDCG**: qualidade do ranking com mais peso para o topo. A versão graduada preserva os graus 0, 1 e 2.
5. Rode o script teórico e confira as contas canônicas do consolidado.

## Perguntas para registrar

- Qual métrica muda quando um documento muito relevante sai da primeira posição e vai para a quarta?
- TF-IDF e BM25 ganham nas mesmas necessidades?
- A conclusão permanece quando o limiar muda? Se não, qual é a justificativa para o limiar adotado?

Não declare um vencedor só por uma consulta. O corpus é pequeno e o qrels inicial é uma referência de trabalho. Registre a média, os casos em que cada modelo falha e a limitação do julgamento.

## Saída esperada

Atualize o consolidado da Aula 05b com uma tabela por necessidade e uma comparação final entre TF-IDF e BM25. Cite o limiar usado, a origem do qrels e qualquer documento que tenha ficado fora do pool.
