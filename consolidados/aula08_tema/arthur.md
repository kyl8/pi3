# Consolidado — PI III — Aula 08 — Tema 5 (MMR) — 2026-11-27
*guia versão 1 · tutora: ChatGPT · motor09*
**Aluno:** Arthur Galvão · **Grupo:** APPA

## 1. O que foi passado
- M1 — redundância do top-4: $0{,}103$.
- M2 — MMR à mão ($\lambda = 0{,}5$): igual ao BM25 no top-4.
- M3 — AP $0{,}833$ em toda a grade de $0{,}5$ a $1$. No caso A, A2, B, AP $1 \to 0{,}833$ e redundância $0{,}95 \to 0{,}10$.
- M4 — grade no dev: feito. Com $k=10$, de $\lambda=1$ para $0{,}7$, MAP $0{,}315 \to 0{,}289$ e redundância média do top-3 $0{,}146 \to 0{,}105$, com julgamentos assistidos. Execução com motor08 v2.

## 2. Como foi o aprendizado — opinião da tutora
No percurso simulado, vi Arthur usar os vetores TF-IDF sem normalização no início. A diagonal de $d_3$ ficou em $25{,}388$ e ele corrigiu a matriz usando colunas de norma unitária. Fez a conta à mão com meu apoio e usou o máximo, sem somar similaridades. Primeiro avaliou o MMR só pelo AP. Depois de comparar A, A2 e B, reconheceu que o gabarito pontua cada documento e não registra se o aspecto já apareceu.

**Teste final:** acertou M1, M2, M3; a revisar M4.

## 3. Observações para a frente
- **Perguntas guardadas:** Como escolher a profundidade $k$ no MMR sem consultar o teste? — Aula 09
- **Para a apresentação:** A diferença entre acertar resultados relevantes e repetir o mesmo conteúdo nas primeiras posições.
