# Atividade 05b (Parte D): Métricas de Avaliação no Gabarito Próprio

Relatório de avaliação comparativa dos modelos de recuperação **BM25** e **TF-IDF (Similaridade do Cosseno)** utilizando os julgamentos de relevância humanos do projeto da Baixada Santista (`2026-09-15-appa-05-qrels.csv`).

## 1. Escolha do Limiar de Binarização e Tratamento da Pool

- **Limiar Adotado:** $\text{grau} \ge 1$ (Amplo / Relevância Parcial e Total).
- **Justificativa Metodológica:** A consulta `q06` (*estadio jabaquara*) possui 5 documentos julgados com grau 1 e nenhum com grau 2. A escolha de um limiar estrito ($\text{grau} \ge 2$) anularia o número de relevantes ($R = 0$) para `q06`, gerando indefinição matemática ($\text{NaN}$) no cálculo do Average Precision (AP). O limiar amplo permite a mensuração uniforme de todas as 6 consultas.
- **Tratamento de Não Julgados:** Conforme a convenção de *pooling* da disciplina, qualquer documento recuperado fora da lista avaliada é estritamente tratado como grau 0 (`is.na(g) <- 0`).

---

## 2. Resultados Consolidados por Consulta e Modelo (Limiar grau >= 1)

| ID | Consulta | Modelo | P@3 | AP | MRR | nDCG Bin | nDCG Grad |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `q01` | historia santos futebol clube | BM25 | 0,667 | 0,544 | 0,500 | 0,817 | 0,700 |
| `q01` | historia santos futebol clube | TF-IDF | 0,667 | 0,610 | 1,000 | 0,938 | 0,794 |
| `q02` | titulos santos | BM25 | 1,000 | 0,879 | 1,000 | 0,994 | 0,893 |
| `q02` | titulos santos | TF-IDF | 1,000 | 0,890 | 1,000 | 0,997 | 0,941 |
| `q03` | portuguesa santista estadio | BM25 | 1,000 | 1,000 | 1,000 | 1,000 | 0,845 |
| `q03` | portuguesa santista estadio | TF-IDF | 1,000 | 1,000 | 1,000 | 1,000 | 0,831 |
| `q04` | jabaquara clube | BM25 | 0,667 | 0,686 | 0,500 | 0,774 | 0,774 |
| `q04` | jabaquara clube | TF-IDF | 0,667 | 0,593 | 0,500 | 0,735 | 0,735 |
| `q05` | rivalidade santos | BM25 | 1,000 | 0,818 | 1,000 | 1,000 | 0,958 |
| `q05` | rivalidade santos | TF-IDF | 1,000 | 0,909 | 1,000 | 1,000 | 1,000 |
| `q06` | estadio jabaquara | BM25 | 0,667 | 0,573 | 0,500 | 0,724 | 0,724 |
| `q06` | estadio jabaquara | TF-IDF | 0,667 | 0,579 | 0,500 | 0,730 | 0,730 |

---

## 3. Síntese Global e Declaração de Vencedor

- **Mean Average Precision (MAP Global, grau >= 1):**
  - **TF-IDF:** $\text{MAP} = 0{,}763$
  - **BM25:** $\text{MAP} = 0{,}750$

### Análise Comparativa dos Resultados Reais:
No corpus atual indexado a partir da Wikipédia (141 parágrafos) e avaliado contra os julgamentos do `qrels.csv`, o **TF-IDF clássico com similaridade do cosseno** obteve ligeira vantagem global em MAP ($0{,}763$ contra $0{,}750$). 

O TF-IDF destacou-se com maior precisão no topo em consultas como `q01` ($\text{AP} = 0{,}610$ vs $0{,}544$; $\text{MRR} = 1{,}000$ vs $0{,}500$) e `q05` ($\text{AP} = 0{,}909$ vs $0{,}818$). Em contrapartida, o **BM25** superou o TF-IDF na consulta `q04` (*jabaquara clube*, $\text{AP} = 0{,}686$ vs $0{,}593$) e empatou perfeitamente em `q03` ($\text{AP} = 1{,}000$ em ambos).

### Ressalva Metodológica:
A diferença observada entre os dois sistemas ($0{,}013$ em MAP) é marginal. Em uma amostra de apenas 6 consultas de teste, a oscilação natural de cada necessidade de informação pode justificar a diferença. Conforme os preceitos da recuperação de informação, **não é possível afirmar significância estatística** sem a aplicação de testes de hipótese pareados (teste t ou teste de postos de Wilcoxon), tópico reservado para a Aula 16.

---

## 4. Script e Artefatos Gerados
- Script R completo: `estrutura/codigos/2026-09-18-appa-Atividade05b-ParteD-MetricasGabaritoProprio.r`
- Resultados consolidados: `estrutura/resultados/2026-09-18-appa-05b-MetricasGabaritoProprio.csv`
