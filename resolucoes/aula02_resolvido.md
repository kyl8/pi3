# Resolução — PI III — aula02

**Apoio:** ChatGPT.
**Aluno:** Pedro Henrique · **Grupo:** APPA · **Data:** 2026-10-25.
**Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana.
Caderno de resoluções: checkpoints, respostas e exemplos da disciplina.
Fonte: [guia original](../tutoras/GUIA_ESTUDO_aula02.md); exemplos e gabaritos da disciplina.

### Checkpoint 1

*Imagine um $d_9$ = `"de de de de"` (quatro vezes `de`, com o idf de sempre, $0{,}47$). Para a consulta `modelo de recuperacao`, qual soma é maior, a de $d_9$ ou a de $d_4$ (que tem só `recuperacao`)? Isso é justo?*

**Minha resolução:** $d_9$: $4 \times 0{,}47 = 1{,}88$; $d_4$: $1{,}39$. $d_9$ ganha — e não fala de nada; ganha só por repetir uma palavra vazia. Não é justo.
### Checkpoint 2

*Acrescente ao corpus um $d_9$ = `"porto de santos"`. Quantas dimensões passa a ter o espaço, quantos vetores de documento há nele, e quantas coordenadas do vetor de $d_9$ são diferentes de zero?*

**Minha resolução:** 47 dimensões (`porto` e `santos` são termos novos; `de` já existia — a conta do Explore do Módulo 5 da Aula 01); 9 vetores; 3 coordenadas não nulas (`porto`, `de`, `santos`). E os 8 vetores antigos ganham duas coordenadas, ambas zero.
### Checkpoint 3

*Sem rodar: quanto vale `ix$w["e", "d6"]`? Pode consultar `docs` para contar em quantos documentos o `e` aparece.*

**Minha resolução:** `e` está em $d_3$, $d_6$ e $d_8$ ($\text{df} = 3$) e aparece 1 vez em $d_6$ → $1 \times \log(8/3) = 0{,}98$.
### Checkpoint 4

*$\vec{d} = (1, 2)$ e $\vec{q} = (2, 1)$: calcule o cosseno à mão, confira com `cosseno`, e diga o que ele diz sobre os dois.*

**Minha resolução:** produto $= 2 + 2 = 4$; normas $\sqrt{5}$ cada, produto das normas $= 5$; $4/5 = 0{,}8$; `cosseno(c(1, 2), c(2, 1))` → `[1] 0.8`. Parecidos, mas invertidos — cada um pesa mais o termo que o outro pesa menos.
### Checkpoint 5

*Escreva o cosseno entre `d2` e `d3` usando `wn`, sem nenhuma divisão. Antes de rodar: vai dar o mesmo que `cosseno(ix$w[, "d2"], ix$w[, "d3"])`?*

**Minha resolução:** `sum(wn[, "d2"] * wn[, "d3"])` → `[1] 0.09170673`; sim, o mesmo número — as normas de `wn` são 1.
### Checkpoint 6

*Sem rodar: em `vetor_consulta(tokenizar("busca busca abc"), ix$vocab, ix$idf_tfidf)`, quais coordenadas não são zero, e quanto valem?*

**Minha resolução:** só `busca`: tf 2, $\text{df} = 2$ → $2 \times \log(8/2) = 2{,}77$. O `abc` some — não é dimensão do espaço.
### Checkpoint 7

*Rode `round(ranking_cosseno("modelo recuperacao", ix), 3)` — sem o `de`. Antes de olhar: o que vai acontecer com `d6` e `d8`? Depois de olhar: por que `d3` caiu abaixo de `d4`?*

**Minha resolução:** `d6` e `d8` vão a zero — só tinham `de` em comum. A nova ordem é $d_1\ 0{,}234 > d_4\ 0{,}221 > d_3\ 0{,}195 > d_2\ 0{,}192$, e os outros quatro em zero: `d3` tinha `de` **duas vezes**, e isso contava no numerador; `d4` nunca dependeu de `de`. Uma *stopword* estava mexendo na ordem — é o gancho da Aula 03.
### Checkpoint 8

*A consulta é `"automovel"`. O documento diz `"o carro parou"`. Qual é o cosseno, e por quê?*

**Minha resolução:** zero — nenhum termo em comum; `carro` e `automovel` são dimensões diferentes, e o modelo não tem como ligá-las.

## Verificação final resolvida

| módulo | pergunta | minha resposta |
|---|---|---|
| **1** | Um documento é o texto de $d_1$ colado três vezes. Pela soma dos pesos TF-IDF da consulta, ele ganha de $d_1$? Isso faz dele mais relevante? | a soma triplica, então ganha; não é mais relevante — diz a mesma coisa, só é mais longo |
| **2** | Um corpus tem 300 termos distintos e 40 documentos. Quantas dimensões tem o espaço, quantos vetores de documento, e o que é a consulta nele? | 300 dimensões; 40 vetores; a consulta é mais um vetor de 300 coordenadas, no mesmo espaço |
| **3** | `ix$w["busca", "d5"]` vale $1{,}39$ e `ix$w["busca", "d1"]` vale $0$. Por quê, e em que campos de `ix` você confere? | `busca` aparece 1 vez em $d_5$ e em 2 documentos: $1 \times \log(8/2) = 1{,}39$; em $d_1$ o tf é 0. Confere em `ix$tf` e `ix$df` (ou `ix$idf_tfidf`) |
| **4** | Quanto dá `cosseno(c(0, 2), c(0, 5))`? E `cosseno(c(0, 0), c(0, 5))` — por que não dá `NaN`? | $1$ — mesma direção; $0$ — o denominador é zero e o `if (den == 0) return(0)` devolve 0 antes do $0/0$ |
| **5** | Para que normalizar as colunas, se o cosseno já divide pela norma? | antecipa a divisão: com vetores unitários o cosseno vira produto escalar — feito uma vez na indexação |
| **6** | No corpus da aula, o que sobra em `qw` para a consulta `"porto de santos"`? | só `de`, com $0{,}47$: `porto` e `santos` não são termos do corpus e somem |
| **7** | Para a consulta `"de"`, quem fica em primeiro, $d_1$ ou $d_3$, e por quê? | $d_3$ ($0{,}187$ contra $0{,}112$): tem `de` duas vezes |
| **8** | Por que a consulta `"ranqueamento"` dá zero para $d_1$ (*"ordena documentos por relevancia"*), que fala do mesmo assunto? | os termos são dimensões independentes; `ranqueamento` só existe em $d_3$, e nada na matriz liga `ranqueamento` a `ordena` |

## Execução

O script `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R` executa os exemplos
canônicos e a aplicação ao corpus congelado. As saídas ficam em `estrutura/resultados/guias/`.
