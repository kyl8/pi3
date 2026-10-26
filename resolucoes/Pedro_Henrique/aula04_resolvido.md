# Resolução — PI III — aula04

**Aluno:** Pedro Henrique · **Grupo:** APPA · **Data:** 2026-10-25.
Respostas preparadas com apoio de Codex a pedido do aluno. Este arquivo é um caderno
de resolução, não um registro de presença nem prova de desempenho individual.
Fonte: [guia original](../../tutoras/GUIA_ESTUDO_aula04.md); exemplos e gabaritos da disciplina.

### Checkpoint 1

*O documento A tem 50 palavras e cita `porto` 2 vezes. O documento B é o A colado 5 vezes seguidas (250 palavras, `porto` 10 vezes). No TF-IDF, quanto B pesa a mais que A em `porto`? Qual dos dois defeitos aparece aqui?*

**Minha resolução:** 5 vezes mais ($10$ contra $2$ ocorrências, mesmo IDF). Os dois: a frequência linear (10 vale 5 vezes 2) e o tamanho (B é longo só por repetir o mesmo conteúdo).
### Checkpoint 2

*Com $\lambda = 3$: calcule $P(X = 0)$, $P(X = 3)$ e $P(X = 6)$ (na calculadora ou com a linha de R acima, trocando o 2). Qual é o mais provável? E entre 0 e 6?*

**Minha resolução:** $0{,}050$; $0{,}224$; $0{,}050$. O mais provável é perto da média (3); 0 e 6 ficam praticamente iguais ($0{,}0498$ e $0{,}0504$), longe do pico. (O $\lambda = 3$ volta no Módulo 5.)
### Checkpoint 3

*Num corpus de 1 000 documentos com essa palavra, quantos documentos com exatamente 6 ocorrências a Poisson única prevê, e quantos a mistura? Que documentos são esses?*

**Minha resolução:** Poisson única: $1\,000 \times 0{,}00007 = 0{,}07$ — nenhum; mistura: $1\,000 \times 0{,}016 = 16$. São justamente os documentos que **falam muito** do assunto — os que um buscador mais quer achar.
### Checkpoint 4

*E se $\lambda = \mu$ — documentos elite e não-elite usam a palavra na mesma taxa? O que acontece com $w(f)$, quaisquer que sejam $p$ e $q$?*

**Minha resolução:** o numerador vira $e^{-\lambda}\lambda^{f}\,(p + 1 - p) = e^{-\lambda}\lambda^{f}$, e o denominador também; $w(f) = 0$. Se a contagem não separa elite de não-elite, ela não informa nada — nem sobre relevância.
### Checkpoint 5

*Mesmo modelo, mas com $q = 0{,}2$. Qual é o teto cru, qual é $w(0)$, e qual é o teto normalizado? (Confira no R com `log(3) - w2p(0, q = 0.2)`.)*

**Minha resolução:** teto cru $\log(0{,}6/0{,}2) = \log 3 = 1{,}0986$; den $= 0{,}2 \times 0{,}049787 + 0{,}8 \times 0{,}818731 = 0{,}664942$; $w(0) = \log(0{,}357365/0{,}664942) = -0{,}6209$; normalizado $1{,}0986 + 0{,}6209 \approx 1{,}720$ (o R mostra `[1] 1.719556`). Com $q$ maior, o termo distingue menos — o teto cai.
### Checkpoint 6

*Duas candidatas: $1 - 0{,}5^{f}$ e $\sqrt{f}$. Calcule em $f = 0, 1, 2, 3$ e diga qual passa nas quatro propriedades.*

**Minha resolução:** $1 - 0{,}5^{f}$: $0$; $0{,}5$; $0{,}75$; $0{,}875$ — incrementos $0{,}5$, $0{,}25$, $0{,}125$, tende a 1: passa nas quatro. $\sqrt{f}$: $0$; $1$; $1{,}414$; $1{,}732$ — côncava, mas $\sqrt{100} = 10$: sem teto, falha na saturação.
### Checkpoint 7

*$\lvert d \rvert = 16$, $\text{avgdl} = 8$, $k_1 = 1{,}2$, $b = 0{,}75$: calcule $K$ e a contribuição com $f = 1$.*

**Minha resolução:** $K = 1{,}2 \times (0{,}25 + 0{,}75 \times 2) = 1{,}2 \times 1{,}75 = 2{,}1$; contribuição $= 2{,}2 / 3{,}1 = 0{,}710$. Documento com o dobro do tamanho médio: o termo vale 71% do que valeria num médio.
### Checkpoint 8

*Um termo aparece em 7 dos 8 documentos. IDF do BM25? Sem o $+1$? E sem os $+0{,}5$ (mas com o $+1$)?*

**Minha resolução:** $1{,}5/7{,}5 = 0{,}2$; $+1 = 1{,}2$; $\ln 1{,}2 = 0{,}182$. Sem o $+1$: $\ln 0{,}2 = -1{,}609$ — negativo. Sem os $+0{,}5$: $\ln(1/7 + 1) = \ln(8/7) = 0{,}134$ — o IDF da Aula 01.
### Checkpoint 9

*Calcule à mão o BM25 de `d2` para `modelo de recuperacao`. `d2` tem `modelo` e `de`, uma vez cada; $\lvert d \rvert = 9$.*

**Minha resolução:** $K = 1{,}2 \times (0{,}25 + 0{,}75 \times 1{,}125) = 1{,}3125$; cada termo contribui IDF $\times\, 2{,}2/2{,}3125 = $ IDF $\times\, 0{,}951$; $(1{,}281 + 0{,}492) \times 0{,}951 = 1{,}773 \times 0{,}951 = \mathbf{1{,}687}$. Bate com o R.

## Verificação final resolvida

| módulo | pergunta | minha resposta |
|---|---|---|
| **1** | Os dois defeitos do TF-IDF que o BM25 corrige? | frequência linear (sem saturação); tamanho tratado sem princípio |
| **2** | Com $\lambda = 1$, qual é mais provável: ver a palavra 1 vez ou 3 vezes? | 1 vez: $P(1) = e^{-1} = 0{,}368$; $P(3) = 0{,}368/6 = 0{,}061$ |
| **3** | O que é *burstiness*, em uma frase, e o que a Poisson única erra por causa dela? | ou a palavra não aparece, ou aparece muitas vezes; a Poisson única quase proíbe os documentos que falam muito do assunto |
| **4** | Qual é a diferença entre "elite" e "relevante"? | elite: o documento é sobre o *termo*; relevante: responde à *consulta*; $p$ e $q$ ligam os dois |
| **5** | Por que se subtrai $w(0)$ — e o que dá se não subtrair? | para a ausência do termo contribuir zero; sem isso, o teto sai 1,79 em vez de 2,52 |
| **6** | Por que a fórmula 2-Poisson exata não é usada — e a hipérbole dá a mesma ordem que ela? | 4 parâmetros ocultos por termo, inestimáveis sem saber quem é elite nem julgamentos; não: preserva o comportamento, a ordem exata depende da forma ($k_1$) |
| **7** | O que acontece com $b = 0$, $b = 1$, e por que 0,75? | ignora o tamanho; normaliza totalmente; interpola entre verbosidade e escopo |
| **8** | Um termo está em 6 dos 8 documentos. IDF do BM25, e sem o $+1$? | $\ln(2{,}5/6{,}5 + 1) = \ln 1{,}385 = 0{,}325$; sem o $+1$: $\ln 0{,}385 = -0{,}956$ — o documento seria punido por conter o termo |
| **9** | Com $k_1 = 0$ e sem a linha `if (f == 0) next`, o que o R mostra para o ranking, e por quê? | `named numeric(0)`: termo ausente dá $0/0$ = `NaN`, o `NaN` contamina a soma de todo documento, e o `sort` descarta `NaN` |

## Execução

O script `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R` executa os exemplos
canônicos e a aplicação ao corpus congelado. As saídas ficam em `estrutura/resultados/guias/`.
