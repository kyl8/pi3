# Resolução — PI III — aula05

**Apoio:** ChatGPT.
**Aluno:** Pedro Henrique · **Grupo:** APPA · **Data:** 2026-10-25.
**Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana.
Caderno de resoluções: checkpoints, respostas e exemplos da disciplina.
Fonte: [guia original](../tutoras/GUIA_ESTUDO_aula05.md); exemplos e gabaritos da disciplina.

### Checkpoint 1

*Um colega diz: "rodei cinco buscas no meu BM25 e nas cinco o primeiro resultado fazia sentido; ele é melhor que o cosseno". Aponte dois problemas nesse argumento.*

**Minha resolução:** quaisquer dois — ele escolheu as consultas; "fazia sentido" é julgamento dele depois de ver o resultado; não rodou o cosseno nas mesmas consultas; olhou só o primeiro.
### Checkpoint 2

*Um colega monta o gabarito assim: "relevante é o documento que tem todas as palavras da consulta". Ele roda a `busca_AND` da Aula 03 e ela acerta tudo. O que essa avaliação mediu?*

**Minha resolução:** nada sobre relevância — o gabarito é a própria regra de casamento de palavras, então a `busca_AND` concorda consigo mesma por construção. É a avaliação circular: falta julgar contra a necessidade.
### Checkpoint 3

*Um grupo julgou as consultas olhando a tela do próprio motor, com os escores ao lado, e conclui: "o BM25 acertou 9 dos 10 primeiros". O que esse "9 de 10" mede?*

**Minha resolução:** o quanto os juízes concordaram com um ranking que já tinham visto — a ancoragem —, não a relevância. Para medir o BM25, o julgamento tinha que vir antes, sem ver o ranking.
### Checkpoint 4

*Você inventou um modelo novo, muito bom, que recupera documentos que os outros três nunca acham. Avaliado com a pool dos três antigos, ele vai parecer melhor ou pior do que é? Por quê?*

**Minha resolução:** **pior** — os documentos que só ele encontra não foram julgados, logo valem 0.
### Checkpoint 5

*Numa consulta, os graus foram: `d1` = 1, `d4` = 1, `d5` = 2, o resto 0. Quantos relevantes há com limiar $\geq 2$, e com $\geq 1$? Um modelo pôs `d1` e `d4` no topo e `d5` em 8º: ele parece bom com qual limiar?*

**Minha resolução:** $\geq 2$ → 1 relevante (`d5`); $\geq 1$ → 3 (`d1`, `d4`, `d5`). Com $\geq 1$ o topo está cheio de relevantes e o modelo parece bom; com $\geq 2$ o único relevante está em último e ele parece péssimo. Por isso o limiar se declara.
### Checkpoint 6

*No cosseno, `d4` (grau 0) ficou em 3º, à frente de `d2` (grau 2). Erro do modelo, erro do gabarito, ou nenhum dos dois? O que o `d4` tem que o fez subir?*

**Minha resolução:** nenhum dos dois. O `d4` contém `recuperacao` — casou uma palavra da consulta —, mas fala de fundamento, não de modelo; o modelo fez o que sabe (casar palavras), o gabarito fez o que deve (julgar contra a necessidade). A distância entre os dois **é** o objeto de estudo.
### Checkpoint 7

*Dois juízes concordaram em $88\%$ dos itens e o $\kappa$ deu $0{,}12$. O que você conclui, e o que recomenda ao grupo?*

**Minha resolução:** quase toda a concordância é a que o acaso já daria — provavelmente a *pool* tem muitos "0" e os dois concordam neles, mas discordam onde importa (graus 1 e 2). $\kappa < 0{,}4$: o guia de julgamento está ambíguo; olhar os itens em que discordaram, decidir os casos de fronteira que faltaram, reescrever e rejulgar.
### Checkpoint 8

*Um grupo julgou 20 consultas, escolheu o $b$ do BM25 olhando o resultado nas 20, e só então sorteou 5 para "teste". O número nessas 5 vale como teste?*

**Minha resolução:** não — as 5 já influenciaram a escolha do $b$; o resultado nelas é otimista. A separação tinha que ter sido decidida antes de julgar e de ajustar qualquer coisa.

## Verificação final resolvida

| módulo | pergunta | minha resposta |
|---|---|---|
| **1** | O cosseno pôs `d1` em 1º e o BM25 pôs `d3`. O que falta para dizer qual dos dois acertou — e o que não serve como resposta? | um gabarito fixo, julgado antes, e as mesmas consultas para os dois; "olhar e achar melhor" não serve |
| **2** | Por que a relevância é julgada contra a necessidade de informação, e não contra a consulta? | julgar contra a consulta mede casamento de palavras — o que o sistema já faz; a avaliação vira circular |
| **3** | Qual é a ordem obrigatória das quatro etapas, e o que dá errado se as duas últimas forem invertidas? | necessidade → consulta → julgar → rodar; invertendo, o juiz se ancora no ranking e o gabarito passa a favorecer o sistema |
| **4** | Dois modelos têm top-3 `d2 d5 d7` e `d5 d1 d2`. Qual é a *pool*, e o que acontece com um relevante que ficou em 4º nos dois? | `union` → `d2 d5 d7 d1` (4 documentos); o 4º lugar não entra, nunca é julgado e conta como irrelevante — o viés que superestima o *recall* |
| **5** | Um gabarito tem graus 0/1/2. Que decisão é preciso tomar para usá-lo com uma métrica binária, e por que ela muda o resultado? | escolher o limiar ($\geq 1$ ou $\geq 2$) e declará-lo; muda quantos e quais documentos contam como relevantes |
| **6** | O BM25 pôs em 2º lugar um documento de grau 1, à frente de um de grau 2. O que isso ilustra? | casamento léxico $\neq$ relevância; nem erro do modelo nem do gabarito |
| **7** | Como é possível $90\%$ de concordância com $\kappa$ negativo? | quase toda a concordância era esperada por acaso (os dois deram "0" a quase tudo, $p_e$ alto); concordaram menos que o acaso previa |
| **8** | Por que separar as consultas de teste **antes** de julgar e ajustar, e não na Aula 09? | depois de usadas para ajustar, já estão contaminadas; não dá para "desver" |

## Execução

O script `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R` executa os exemplos
canônicos e a aplicação ao corpus congelado. As saídas ficam em `estrutura/resultados/guias/`.
