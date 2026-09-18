# Atividade 05b: Métricas de Avaliação (Aula 5,5)

Consolidado da sessão de cálculo de métricas de avaliação e exploração teórica/experimental para o Projeto Integrador III.

## 1. Métricas Canônicas do Motor de Busca (Slides 3 e 4)

Com base no cenário canônico da consulta `modelo de recuperacao`:
- **Ranking BM25:** `d3, d1, d2, d4, d8, d6, d5, d7`
- **Gabarito:** `d2 = 2, d3 = 2, d1 = 1, d6 = 1, resto = 0`
- **Vetor rel (binário com limiar >= 2):** `1 0 1 0 0 0 0 0` ($R = 2$)

### Resultados Obtidos:
- **P@3:** $0{,}667$ ($2/3$)
- **AP:** $0{,}833$ ($\frac{1{,}000 + 0{,}667}{2}$)
- **MRR:** $1{,}000$ ($1/1$, primeiro relevante na posição 1)
- **nDCG (binário):** $0{,}920$ ($\frac{1{,}500}{1{,}631}$)
- **nDCG (graduado com graus 2, 1, 0):** $0{,}951$ ($\frac{3{,}987}{4{,}193}$)

---

## 2. Experimentos do Slide 26 (Tarefa de Casa 1)

1. **Inversão do Ranking (`rev(ranking)`):**
   - Os relevantes passam para as posições 6 e 8.
   - P@3 cai para $0{,}000$ (-100%).
   - MRR cai para $0{,}167$ (-83,3%).
   - AP cai para $0{,}208$ (-75%).
   - nDCG binário cai para $0{,}412$ e graduado para $0{,}519$.
   - A métrica que mais sofre impacto imediato de topo é a P@3, seguida pelo MRR.

2. **Flexibilização do Limiar Binário (`grau >= 1`, $R = 4$):**
   - Os documentos $d_1$ e $d_6$ passam a ser considerados relevantes.
   - P@3 sobe para $1{,}000$ (3 acertos nas 3 primeiras posições).
   - AP atinge $0{,}917$.
   - nDCG binário sobe para $0{,}971$.

3. **Substituição por Desconto Linear ($1/i$ vs $1/\log_2(i+1)$):**
   - O desconto linear penaliza a cauda com severidade excessiva (posição 10 tem peso 10x menor, contra apenas 3,5x menor na escala logarítmica).
   - nDCG linear binário: $0{,}889$ (vs $0{,}920$ logarítmico).
   - nDCG linear graduado: $0{,}930$ (vs $0{,}951$ logarítmico).

4. **Deslocamento de $d_6$ da 6ª para a 4ª Posição:**
   - Como $d_6$ possui grau 1, nas métricas binárias estritas (limiar grau 2) nada se altera.
   - No nDCG graduado, a antecipação de um documento com relevância parcial aumenta o DCG de $3{,}987$ para $4{,}062$ e o nDCG graduado sobe de $0{,}951$ para $0{,}969$.

---

## 3. Script Desenvolvido
O código executável com todos os cálculos encontra-se em:
`estrutura/codigos/2026-09-18-appa-Atividade05b-MetricasAvaliacao.r`
