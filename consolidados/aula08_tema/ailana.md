# Consolidado — PI III — Aula 08 — Tema 5 (MMR) — 2026-11-27
*guia versão 1 · tutora: ChatGPT · motor09*
**Aluno:** Ailana Pereira Gonsalez · **Grupo:** APPA

## 1. O que foi passado
- M1 — redundância do top-4: $0{,}103$.
- M2 — MMR à mão ($\lambda = 0{,}5$): igual ao BM25 no top-4.
- M3 — AP $0{,}833$ em toda a grade de $0{,}5$ a $1$. No caso A, A2, B, AP $1 \to 0{,}833$ e redundância $0{,}95 \to 0{,}10$.
- M4 — grade no dev: feito. Com $k=10$, de $\lambda=1$ para $0{,}7$, MAP $0{,}315 \to 0{,}289$ e redundância média do top-3 $0{,}146 \to 0{,}105$, com julgamentos assistidos. Execução com motor08 v2.

## 2. Como foi o aprendizado — opinião da tutora
No percurso simulado, notei que Ailana rodou a matriz antes de prever a saída. Ela retomou a previsão na etapa seguinte e fez a conta à mão usando o maior cosseno, sem somar os descontos. Acertou os checkpoints e levantou a objeção do terceiro: quando os três documentos têm grau relevante, trocar a cópia de posição pode deixar o AP igual.

**Teste final:** acertou M1, M2, M3, M4; a revisar nenhum.

## 3. Observações para a frente
- **Perguntas guardadas:** Vale usar $\lambda<1$ quando os resultados do corpus quase não se repetem? — Aula 09
- **Para a apresentação:** A grade de desenvolvimento e a leitura do topo para avaliar se aparece um aspecto novo.
