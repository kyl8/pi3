# Pendências do APPA — PI III

Conferência de 11/11/2026 com [Danilo, versão `fafe046`](https://github.com/danilopradooficial/projetointegrador3/tree/fafe046).

## 1. Julgamento humano e gabarito

- Preencher, de forma independente, as três planilhas em `estrutura/codigos/05-julgamento/csv/julgamentos-humanos/`. Cada uma cobre os **101 pares do pool v2** e ainda tem zero graus preenchidos.
- Fazer busca complementar no corpus para não restringir os relevantes aos documentos recuperados pelos modelos. O arquivo Claude contém 51 pares complementares; é referência LLM, não voto humano.
- Conferir os casos ambíguos e a consulta `q06`: o gabarito antigo tem R=0, mas Claude atribui grau 2 a `d135` e `d140`.
- Executar `2026-10-05-appa-05g-consolidar-julgamentos-humanos.R` depois do preenchimento, resolver divergências e registrar o kappa entre pessoas. O script agora usa o pool v2. A preparação preserva votos existentes.
- Reavaliar e escolher BM25/LSA/híbrido pelo desenvolvimento com o gabarito humano. A configuração atual continua baseada no gabarito assistido antigo; não trocar os resultados de outubro pelos de Claude como se fossem a mesma referência.

## 2. Aula 08 — Retrieve & Rerank

O Danilo já tem essa atividade; o APPA recebeu os dois guias e o PDF. Os exemplos teóricos foram executados, mas ainda faltam:

- Resoluções dos checkpoints, teste, tarefa e consolidado da teoria.
- Aplicar proximidade ordenada ao estágio 1 do APPA; comparar os textos antes/depois.
- Medir a grade `rerank_k` em 3, 5 e 10 e `janela` em 2, 3 e 5 no desenvolvimento; comparar com o estágio 1 sem reordenação e relatar o teste após a escolha.
- Integrar a opção ao motor, salvar `aula08.ipynb`, consolidado da Parte D, estado do R e decisão na ficha/configuração. O material deve permitir manter a reordenação desligada se não houver ganho.

Guias: [teoria](tutoras/GUIA_ESTUDO_aula08.md) e [Parte D](tutoras/GUIA_ESTUDO_aula08_parteD.md).

## 3. Entrega e participação

- Confirmar com o professor a aceitação dos 141 parágrafos: o enunciado inicial prevê 20–60. Reduzir o corpus depois dos julgamentos invalidaria os identificadores; a decisão precisa ficar documentada.
- Conferir as entregas individuais dos demais integrantes e registrar somente participações e avaliações de aprendizagem que de fato ocorreram. Os cadernos atuais não demonstram desempenho individual de cada pessoa.
- A demonstração técnica está documentada na [ficha, seção 4.1](consolidados/00_FICHA_PROJETO.md); falta a apresentação ao professor, se ainda não foi realizada.

## Conferido nesta atualização

As correções de 06/11 já estão commitadas no `main`; não há patch externo a aplicar.
O pipeline atual, a geração do pool v2 e a avaliação com Claude executaram sem erro.
Foram executados 121 blocos dos guias teóricos 00–08; isso verifica os exemplos, sem substituir as resoluções e os consolidados pendentes da Aula 08.
Os guias 00–07 coincidem com os atuais do Danilo após normalizar as quebras de linha.
`estrutura/codigo/` é o caminho exigido pelos guias; `estrutura/codigos/` guarda os scripts das atividades.
Os arquivos LaTeX, Sweave e PDFs foram preservados.
