=== CONSOLIDADO — PEDRO HENRIQUE ===

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

=== CONSOLIDADO — AILANA PEREIRA GONSALEZ ===

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

=== CONSOLIDADO — ARTHUR GALVÃO ===

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

## NOTAS DE EXECUÇÃO

- Os percursos e desempenhos individuais são simulados. O cabeçalho segue o formato do guia. A primeira célula tentou carregar motor09, mas a URL devolveu HTTP 404. O R estava disponível. A execução usou motor08 v2 e os blocos MMR do guia, com o corpus didático e, no M4, os 141 parágrafos do APPA e os graus assistidos.
- M1–M3 reproduziram os números e ordens do guia. No M4 rodamos a grade de desenvolvimento e a comparação retrospectiva em $\lambda=0{,}7$, valor de exemplo do guia. O AP caiu em q01, q05 e q06 no dev, sem caso de melhora nesse valor. No teste conhecido, q02 passou de $0{,}261$ a $0{,}254$ e q04 de $0{,}322$ a $0{,}291$. A leitura de um caso de melhora não se aplica. Não houve escolha de parâmetro pelo grupo nem sessão individual real.
- Checkpoints: cosseno $1$ para vetores proporcionais, ordem A–C–B, AP $1$ nas duas ordens se B também for relevante, e leitura conjunta de MAP, redundância e conteúdo para decidir no M4. No segundo checkpoint, a soma incorreta é uma justificativa inadequada para o passo seguinte: naquele ponto a ordem já está determinada, pois só sobra B. No teste final, as respostas de referência são $0{,}90$, Z com $0{,}35$ contra $0{,}30$, distinção entre relevância e diversidade, e sensibilidade da penalidade à escala mais comprimida da RRF.
- Nenhum número foi inventado. Os resultados numéricos vêm do guia ou da execução em R.
