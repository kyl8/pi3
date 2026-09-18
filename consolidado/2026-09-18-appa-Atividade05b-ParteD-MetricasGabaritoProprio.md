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
| `q01` | historia santos futebol clube | BM25 | 0,333 | 0,528 | 0,500 | 0,863 | 0,698 |
| `q01` | historia santos futebol clube | TF-IDF | 0,333 | 0,512 | 1,000 | 0,841 | 0,674 |
| `q02` | titulos santos | BM25 | 0,667 | 0,707 | 0,500 | 0,833 | 0,638 |
| `q02` | titulos santos | TF-IDF | 0,667 | 0,685 | 0,500 | 0,812 | 0,621 |
| `q03` | portuguesa santista estadio | BM25 | 0,667 | 0,771 | 0,500 | 0,823 | 0,693 |
| `q03` | portuguesa santista estadio | TF-IDF | 0,667 | 0,750 | 0,500 | 0,805 | 0,670 |
| `q04` | jabaquara clube | BM25 | 0,000 | 0,354 | 0,167 | 0,541 | 0,541 |
| `q04` | jabaquara clube | TF-IDF | 0,000 | 0,340 | 0,167 | 0,530 | 0,530 |
| `q05` | rivalidade santos | BM25 | 0,667 | 0,643 | 0,500 | 0,833 | 0,662 |
| `q05` | rivalidade santos | TF-IDF | 0,667 | 0,620 | 0,500 | 0,810 | 0,645 |
| `q06` | estadio jabaquara | BM25 | 0,000 | 0,354 | 0,167 | 0,541 | 0,541 |
| `q06` | estadio jabaquara | TF-IDF | 0,000 | 0,345 | 0,167 | 0,535 | 0,535 |

---

## 3. Síntese Global e Declaração de Vencedor

- **Mean Average Precision (MAP):**
  - **BM25:** $\text{MAP} = 0{,}560$
  - **TF-IDF:** $\text{MAP} = 0{,}542$

### Qual modelo venceu e por quê?
O **BM25** apresentou desempenho global superior em MAP ($0{,}560$ vs $0{,}542$) e em nDCG graduado na maioria das consultas. Isso ocorre porque o BM25 atenua o impacto de parágrafos longos excessivamente repetitivos através do fator de normalização de comprimento ($b = 0{,}75$) e da saturação assintótica do termo ($k_1 = 1{,}2$). O TF-IDF clássico, por sua vez, garantiu o primeiro acerto mais cedo na consulta `q01` ($\text{MRR} = 1{,}000$), mas sofreu perda de precisão global na cauda da lista.

### Ressalva Metodológica:
Embora o BM25 tenha superado o TF-IDF numericamente, **não é possível afirmar que a diferença é estatisticamente significante**. Com apenas 6 consultas de teste, a variância inerente a cada necessidade de busca pode explicar a oscilação observada. A confirmação rigorosa de superioridade depende de testes estatísticos pareados (teste t ou teste de Wilcoxon), a serem desenvolvidos na Aula 16.

---

## 4. Script e Artefatos Gerados
- Script R completo: `estrutura/codigos/2026-09-18-appa-Atividade05b-ParteD-MetricasGabaritoProprio.r`
- Resultados consolidados: `estrutura/resultados/2026-09-18-appa-05b-MetricasGabaritoProprio.csv`
