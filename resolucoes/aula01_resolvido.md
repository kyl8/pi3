# Resolução — PI III — aula01

**Apoio:** ChatGPT.
**Aluno:** Pedro Henrique · **Grupo:** APPA · **Data:** 2026-10-25.
**Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana.
Caderno de resoluções: checkpoints, respostas e exemplos da disciplina.
Fonte: [guia original](../tutoras/GUIA_ESTUDO_aula01.md); exemplos e gabaritos da disciplina.

### Checkpoint 1

*Uma mesma busca devolve 500 linhas num banco de dados e 500 documentos num motor de busca. O que cada um te dá, e o que falta em um deles?*

**Minha resolução:** o banco dá um conjunto (todas iguais, sem ordem); o motor dá uma lista ordenada por relevância. Falta ordem no banco.
### Checkpoint 2

*Um motor tem um milhão de documentos. O estágio 2 leva um segundo por documento. Por que não aplicá-lo direto sobre todos?*

**Minha resolução:** $10^6$ s $\approx$ 11,6 dias por consulta. O estágio 1 reduz um milhão a uma centena; só então o 2 vale a pena.
### Checkpoint 3

*Sem rodar: `nchar(docs[["d8"]])` e `nchar(docs["d8"])` dão o mesmo número? O que muda na tela?*

**Minha resolução:** o mesmo número, 50 (`nchar` conta caracteres); o segundo mostra o nome `d8` em cima, porque o colchete simples preserva o nome e `nchar` o mantém.
### Checkpoint 4

*Sem rodar: `tokenizar("Modelo modelo MODELO")` dá quantos tokens, e quantos distintos?*

**Minha resolução:** 3 tokens, 1 distinto — o `tolower` unifica.
### Checkpoint 5

*Na cópia, troque o d9 por `"busca busca busca"`. O que acontece com a frequência de `busca` e com o tamanho do vocabulário?*

**Minha resolução:** `busca` vai de 2 para 5; o vocabulário fica 45 — "busca" já existia.
### Checkpoint 6

*O que aconteceria com o `sapply` se um documento devolvesse um vetor de 7 e outro de 9?*

**Minha resolução:** não monta matriz; devolve lista. O `factor(levels = vocab)` existe para impedir isso.
### Checkpoint 7

*Com `busca_booleana` e `intersect`, escreva a busca "documentos E busca" — documentos que têm os dois termos.*

**Minha resolução:** `intersect(busca_booleana("documentos", tdm), busca_booleana("busca", tdm))` → `"d5"`.
### Checkpoint 8

*Um termo aparece 2 vezes em d5 e em nenhum outro documento. Qual é o seu peso em d5?*

**Minha resolução:** $2 \times \log(8/1) = 2 \times 2{,}08 = 4{,}16$. Frequente aqui **e** raro lá fora: o melhor caso.
### Checkpoint 9

*Sem rodar: qual é o tfidf de `modelo` em d3?*

**Minha resolução:** `modelo` está em d2 e d3 ($\text{df} = 2$, Módulo 6) e aparece 1 vez em d3 → $1 \times \log(8/2) = 1{,}39$.
### Checkpoint 10

*Sem rodar: `grep("busca", docs)` e `busca_booleana("busc", tdm)` — o que cada um devolve, e por quê?*

**Minha resolução:** `5 7` (as posições de d5 e d7, que contêm "busca"); `character(0)` — "busc" não é um termo do vocabulário. A regex acharia "busc" também; o motor não.

## Verificação final resolvida

| módulo | pergunta | minha resposta |
|---|---|---|
| **1** | Qual é a diferença entre recuperação de informação e busca num banco de dados? | relevância em vez de igualdade; lista ordenada em vez de conjunto |
| **2** | Por que *retrieve & rerank* usa dois estágios, e o que acontece se o primeiro for ruim? | o caro não escala; o barato reduz milhões a uma centena; o que o primeiro perde, o segundo não recupera |
| **3** | Por que `docs` é um vetor e `tokens` é uma lista? | em `docs` cada documento é **um** texto, todos do mesmo tipo; em `tokens` cada documento vira um vetor de **tamanho diferente** — só uma lista comporta |
| **4** | O que `tokenizar("Porto  DE Santos")` devolve, e por quê? | `"porto" "de" "santos"`: o `tolower` põe em minúsculas e o `"\\s+"` quebra em um ou mais espaços |
| **5** | O corpus tem 64 palavras e 45 distintas. Onde foram parar as outras 19? | repetições (`de` 6 vezes, `a` 5…); `unique` as removeu |
| **6** | Para que serve `factor(tk, levels = vocab)` na matriz? | garante 45 posições em toda coluna, na mesma ordem; sem isso o `sapply` não monta matriz |
| **7** | A busca booleana responde a qual pergunta, e não responde a qual? | "quais documentos têm o termo"; não "qual é o mais relevante" |
| **8** | Um termo aparece em 4 dos 8 documentos, 2 vezes em d2. Qual é o seu peso em d2? | $2 \times \log(8/4) = 2 \times 0{,}69 = 1{,}39$ |
| **9** | Explique `tdm * idf` em uma frase. | reciclagem coluna a coluna: `idf` tem o comprimento de uma coluna, então alinha termo a termo |
| **10** | Por que `grep` acha "recupera" e o motor não — e por que isso não é defeito? | o índice é de termos inteiros; o motor precisa de termos para pesar, indexar e escalar — a regex não tem nada disso |

## Execução

O script `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R` executa os exemplos
canônicos e a aplicação ao corpus congelado. As saídas ficam em `estrutura/resultados/guias/`.
