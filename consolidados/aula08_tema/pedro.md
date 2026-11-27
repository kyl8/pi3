# Consolidado — PI III — Aula 08 — Tema 5 (MMR) — 2026-11-27
*guia versão 1 · tutora: ChatGPT · motor09*
**Aluno:** Pedro Henrique · **Grupo:** APPA

## 1. O que foi passado
- M1 — redundância do top-4: $0{,}103$.
- M2 — MMR à mão ($\lambda = 0{,}5$): igual ao BM25 no top-4.
- M3 — AP $0{,}833$ em toda a grade de $0{,}5$ a $1$. No caso A, A2, B, AP $1 \to 0{,}833$ e redundância $0{,}95 \to 0{,}10$.
- M4 — grade no dev: feito. Com $k=10$, de $\lambda=1$ para $0{,}7$, MAP $0{,}315 \to 0{,}289$ e redundância média do top-3 $0{,}146 \to 0{,}105$, com julgamentos assistidos. Execução com motor08 v2.

## 2. Como foi o aprendizado — opinião da tutora
No percurso simulado, acompanhei a conta à mão de Pedro, que chegou à ordem certa. No segundo checkpoint ele propôs somar as similaridades no passo seguinte, embora a ordem já estivesse decidida. Retomamos o maior cosseno e ele corrigiu a regra. Explicou com clareza por que o AP dá crédito integral a uma cópia julgada relevante.

**Teste final:** acertou M1, M3, M4; a revisar M2.

## 3. Observações para a frente
- **Perguntas guardadas:** Como o MMR se comporta quando o estágio 1 combina BM25 e LSA por RRF? — Aula 09
- **Para a apresentação:** A troca de posição entre A2 e B e por que o AP cai mesmo com menos repetição.
