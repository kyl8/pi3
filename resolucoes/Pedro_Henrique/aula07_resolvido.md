# Resolução — PI III — Aula 07: LSA e busca híbrida
**Pedro Henrique · APPA · 25/10/2026 · Guia versão 2.**
Preparação com apoio de Codex. As respostas foram entregues prontas; não são um teste pessoal observado.
O [guia original](../../tutoras/GUIA_ESTUDO_aula07.md) usa os oito documentos do curso e a consulta `modelo de recuperacao`.

## Diagnóstico
Sem termos em comum, o cosseno lexical é zero. O Rocchio acrescenta termos presentes nos
documentos marcados. Para aproximar “ordena” e “ranqueamento” sem a mesma palavra,
o LSA aprende coordenadas a partir da distribuição dos termos no corpus.

## M1 — Descasamento de vocabulário — Checkpoint 1
Para `ordenar documentos`, pontuam `d1`, `d2`, `d5` e `d6`, pois contêm `documentos`.
`ordenar` está fora do vocabulário: `d1` contém `ordena`. `d3` fala de ranqueamento,
mas não contém nenhum dos termos da consulta, então recebe zero.

## M2 — Esparso e denso — Checkpoint 2
`d4` tem seis palavras distintas num espaço de $45$ termos: há $45-6=39$ coordenadas zero.
Com $k=2$, uso duas coordenadas latentes, em geral não nulas. Elas não têm nomes de palavras
nem representam necessariamente dois temas interpretáveis.

## M3 — Decomposição e energia — Checkpoint 3
Escrevo $W=U\Sigma V^\top$. Os documentos ficam nas linhas de $V_k\Sigma_k$.
A energia acumulada é $E(k)=\sum_{i\leq k}\sigma_i^2/\sum_i\sigma_i^2$.
Com os valores do guia, $E(3)=84{,}83/184{,}82\approx0{,}459$.
Para guardar pelo menos $80\%$, preciso de $k=6$, que retém aproximadamente $81{,}1\%$.
Trocar simultaneamente os sinais de uma direção de $U$ e $V$ não muda os cossenos.

## M4 — Dobrar a consulta — Checkpoint 4
Calculo $q_k=U_k^\top q_0$, com dimensões $(2\times45)(45\times1)$.
No exemplo, $q_k\approx(-0{,}370;0{,}445)$ e $d_7\approx(-3{,}207;-2{,}888)$.
O produto é aproximadamente $1{,}187-1{,}285=-0{,}098$; dividido por
$0{,}578\times4{,}316$, resulta em cosseno $-0{,}039$.
Os pesos originais são não negativos, mas as coordenadas latentes podem ser negativas.
Escolho $k$ no desenvolvimento; uma consulta com AP igual a um não determina o melhor modelo.

## M5 — Limites do LSA — Checkpoint 5
`d4` não responde diretamente a “busca”. Sua proximidade não prova compreensão de sentido.
Com oito frases e duas dimensões, palavras comuns podem aproximar assuntos diferentes:
`d3` e `d8` só compartilham `e` e `de`, mas passam de cosseno lexical $0{,}058$ para
aproximadamente $1$ no LSA. Preciso medir várias consultas com gabarito e escolher $k$ no desenvolvimento.

## M6 — Fusão RRF — Checkpoint 6
Uso $\operatorname{RRF}(d)=\sum_r1/(c+\operatorname{posição}_r(d))$.
Para `d6`, sexto no BM25 e quarto no LSA, com $c=60$:
$$\frac1{66}+\frac1{64}=0{,}0307765.$$
Ele fica em quinto, entre `d8` e `d4`. A fusão depende da ordem dos rankings, não da escala dos escores.

## Teste final resolvido
| Módulo | Minha resposta |
|---|---|
| 1 | `aprendizagem` gera vetor nulo e todos os escores são zero; `d4` usa `aprendizado`, outra forma lexical. |
| 2 | Tenho $45-10=35$ zeros no vetor TF-IDF e três coordenadas no LSA com $k=3$, em geral não nulas. |
| 3 | $E(1)=36/(36+4+1+1)=36/42=0{,}85714$. Uma direção domina, ao contrário dos $17\%$ do exemplo do curso. |
| 4 | `d6` tem cosseno maior: aproximadamente $0{,}900$, ante $0{,}397$ de `d1`. Suas coordenadas acompanham melhor a direção de $q_k$. |
| 5 | A compressão confunde coocorrência de palavras comuns com assunto. Com $k=8$, recupero a geometria lexical, sem a aproximação truncada; só `d3` pontua em “ranqueamento”, salvo resíduos numéricos de ponto flutuante. |
| 6 | B vence: $2/64=0{,}03125$; A recebe $1/61+1/70=0{,}0306792$. |

## Tarefa individual — consulta “busca”
Comparei cosseno, LSA com $k=2$ e $k=4$, além de RRF de BM25 com cada LSA.
No léxico, apenas `d5` e `d7` pontuam. Com $k=2$, `d1` ganha escore sem conter a palavra:
seu texto fala de recuperar informação e ordenar documentos, uma aproximação útil.
O mesmo mecanismo coloca `d4` no topo, embora ele trate de aprendizado estatístico: ruído.
Com $k=4$, `d5` e `d7` voltam ao topo. Isso mostra o efeito de mudar a dimensão,
sem transformar esta única consulta em conjunto de desenvolvimento.

O código primeiro monta a matriz, depois calcula a SVD e a energia, projeta consultas,
compara cossenos e funde posições. O [script](../../estrutura/codigo/aula07_teoria.R)
comenta cada linha. Os [rankings com os textos](../../estrutura/resultados/guias/aula07/tarefa_individual_busca.csv)
permitem conferir a leitura. Não reutilizei o gabarito de `modelo de recuperacao` para medir AP de “busca”.
