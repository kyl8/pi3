# Resolução — PI III — aula06

**Apoio:** ChatGPT.
**Aluno:** Pedro Henrique · **Grupo:** APPA · **Data:** 2026-10-25.
**Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana.
Caderno de resoluções: checkpoints, respostas e exemplos da disciplina.
Fonte: [guia original](../tutoras/GUIA_ESTUDO_aula06.md); exemplos e gabaritos da disciplina.

### Checkpoint 1

*Se o usuário olhasse só o top-3 do cosseno e marcasse com o gabarito (limiar 2), quem iria para $D_r$ e $D_{nr}$? Que relevante ele não veria?*

**Minha resolução:** $D_r = \{d3\}$; $D_{nr} = \{d4\}$ (e `d1`, se ele marcar "abaixo do limiar" como não relevante); `d2`, na 4ª posição, fica sem ser visto.
### Checkpoint 2

*Qual o centroide de três documentos, `d1`, `d3` e `d4`, no termo `recuperacao`? (`d1` e `d4` têm peso $1{,}386$; `d3`, 0.)*

**Minha resolução:** $(1{,}386 + 0 + 1{,}386)/3 = 0{,}924$. Confere com `round(rowMeans(ix$w[, c("d1", "d3", "d4")])[["recuperacao"]], 3)`.
### Checkpoint 3

*À mão: o peso de `recuperacao` em $\vec q_m$. (`q0`: $1{,}386$; `d2` e `d3`: 0; `d4`: $1{,}386$.)*

**Minha resolução:** $1 \cdot 1{,}386 + 0{,}75 \cdot 0 - 0{,}15 \cdot 1{,}386 = 1{,}386 - 0{,}208 = 1{,}178$ — **caiu**, porque `d4` também tem `recuperacao`. Confere na saída.
### Checkpoint 4

*Com `pmax`, as métricas são $\text{P@}3 = 0{,}667$, AP $1$, RR $1$, nDCG binário $1$ e graduado $0{,}990$. Por que o graduado cai e o AP não?*

**Minha resolução:** com limiar 2, o AP só vê `d2` e `d3`, que continuam em 1º e 2º. O graduado vê também `d6` (grau 1), empurrado do 4º para o 5º por `d4` — perde um pouco de ganho descontado.
### Checkpoint 5

*Outro cenário: o usuário marcou só `d3` (relevante) e `d4` (não). Quais documentos ficam na coleção residual? Existe ali algum relevante grau 2 que o Rocchio poderia "achar de novo"? Preveja: o AP residual sobe ou empata?*

**Minha resolução:** residual `d1 d2 d5 d6 d7 d8`; `d2` (grau 2) está lá, em 2º no base residual. Ele roda `q_a <- rocchio(q0, "d3", "d4", ix)` (um documento só: o `drop = FALSE` trabalhando) e mede como acima com `fora <- c("d3", "d4")`: AP residual $0{,}5 \to 1$ — `d2` sobe para 1º. Aqui o ganho é honesto: um relevante **não marcado** subiu.
### Checkpoint 6

*Antes de rodar: PRF com $k = 1$ (só `d1`, grau 1). O AP sobe ou desce em relação ao base ($0{,}5$)? Por quê?*

**Minha resolução:** desce — `d1` é grau 1 (não relevante com limiar 2) e traz `informacao`, `ordena`, `recuperacao`; `recuperacao` puxa `d4`. Ao rodar (`names(base)[1]`): `d1` 0,882 · `d4` 0,183 · `d3` 0,129 · `d2` 0,126 …; AP $0{,}417$, abaixo do base. *Drift* com um documento só.

## Verificação final resolvida

| módulo | pergunta | minha resposta |
|---|---|---|
| **1** | O usuário vê o top-4 do BM25 (`d3 d1 d2 d4`) e marca com o gabarito, limiar 2, deixando sem marca o que é grau 1. Quem vai para $D_r$ e $D_{nr}$? | $D_r = \{d3, d2\}$; $D_{nr} = \{d4\}$; `d1` sem marca |
| **2** | `busca` pesa $1{,}386$ em `d5` e em `d7`. Centroide de `d5` e `d7` nesse termo? | $(1{,}386 + 1{,}386)/2 = 1{,}386$ |
| **3** | Com $\beta = 0{,}5$ e o resto igual, quanto pesa `modelo` em $\vec q_m$? | $1{,}386 + 0{,}5 \cdot 1{,}386 = 2{,}079$ |
| **4** | `d7` tem cosseno $-0{,}007$ com $\vec q_m$. Qual termo explica o sinal? | o artigo `a`: peso $-0{,}104$ em $\vec q_m$ (vem de `d4`), e é o único termo de `d7` com peso não nulo na consulta |
| **5** | Um colega reporta: "Rocchio com `d2` e `d3` marcados: nDCG $= 1$". Que objeção, e o que mediria? | mediu nos próprios marcados (otimista); medir na coleção residual, sem os marcados no ranking e no gabarito |
| **6** | Um grupo usa PRF com $k = 10$ num corpus em que cada consulta tem uns 3 relevantes. O que esperar? | pelo menos 7 irrelevantes em $D_r$: *query drift* provável; preferir $k$ pequeno |

## Execução

O script `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R` executa os exemplos
canônicos e a aplicação ao corpus congelado. As saídas ficam em `estrutura/resultados/guias/`.
