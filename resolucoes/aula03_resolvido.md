# Resolução — PI III — aula03

**Apoio:** ChatGPT.
**Aluno:** Pedro Henrique · **Grupo:** APPA · **Data:** 2026-10-25.
**Solicitante:** Grupo APPA — Arthur Galvão, Pedro Henrique e Ailana.
Caderno de resoluções: checkpoints, respostas e exemplos da disciplina.
Fonte: [guia original](../tutoras/GUIA_ESTUDO_aula03.md); exemplos e gabaritos da disciplina.

### Checkpoint 1

*Sem rodar: `busca_booleana("busca", bruto_tf)` acha quais documentos? E na matriz limpa, `ix$tf`?*

**Minha resolução:** na suja, só `d5` — em `d7` o token é `"busca."`, com ponto; na limpa, `d5` e `d7`.
### Checkpoint 2

*Sem rodar: `limpar("R$ 3,50 (meia-entrada)")` dá o quê?*

**Minha resolução:** `"r 3 50 meia entrada"` — o `$`, a vírgula, os parênteses e o hífen viram espaço; o número se parte em dois.
### Checkpoint 3

*Sem rodar: `sem_stop(brutos[["d7"]])` — quais termos sobram? Algum deles deveria ter saído?*

**Minha resolução:** `"avaliacao" "mede" "relevancia" "dos" "resultados" "busca"`; `dos` sobreviveu porque não está na lista (`do` está, mas a comparação é com a palavra inteira).
### Checkpoint 4

*Sem rodar: `stem("cidades")` e `stem("cidade")` — dão o mesmo radical?*

**Minha resolução:** **não** — `"cidade"` e `"ci"`. Em `cidades` só o `s$` casa (e o `sub` corta uma vez só); em `cidade`, casa `dade$`. O brinquedo separa o que deveria juntar. Conferência em R: `wordStem(c("cidades", "cidade"), language = "portuguese")` → `"cidad" "cidad"` — o Snowball aplica as regras em ordem e confere o tamanho do que sobra.
### Checkpoint 5

*O vocabulário por palavra tem `praia` e `praias`. Chega a consulta `praiano`. O que acontece na tokenização por palavra? E numa por subword cujo vocabulário tem os pedaços `praia`, `s` e `no`?*

**Minha resolução:** por palavra, `praiano` é OOV — contribui zero, nenhum documento; por *subword* vira `praia` + `no`, e o pedaço `praia` liga a consulta aos documentos com `praia` e `praias`.
### Checkpoint 6

*Sem rodar: depois de fundir `as`, qual par vence a segunda rodada, e com quanto?*

**Minha resolução:** empate em $7$ entre `pr`, `ra` e `ai` (todos de `praias` $+$ `praia`); `ias` vem atrás, com $5$. O `sort` mantém a ordem de chegada nos empates e põe `pr` primeiro. O desempate é arbitrário — e é assim mesmo. Conferência em R: `head(contar_pares(strsplit(gsub("a s", "as", palavras), " "), freq), 4)` → `pr 7, ra 7, ai 7, ias 5`. O radical `pra…` começa a emergir.
### Checkpoint 7

*Um corpus de um milhão de documentos; a consulta tem um termo que aparece em 50. Quantos documentos a busca ingênua lê? E o índice invertido, quantos devolve — e quantos lê?*

**Minha resolução:** um milhão; devolve 50 e **lê nenhum** — só consulta o dicionário e pega a lista pronta.
### Checkpoint 8

*Sem rodar: no `p_sem` — sem stopwords tiradas e sem `unique` —, o que é `p_sem[["a"]]`?*

**Minha resolução:** `"d4" "d5" "d6" "d7" "d7"` — `a` aparece uma vez em `d4`, `d5`, `d6` e **duas** em `d7` ("**a** avaliacao mede **a** relevancia"); sem `unique`, `d7` entra duas vezes.
### Checkpoint 9

*Sem rodar: `busca_AND("Relevancia da busca")` devolve o quê, e por quê?*

**Minha resolução:** `"d7"` — o `prep` põe em minúsculas e tira `da` (*stopword*); sobram `relevancia → {d1, d7}` e `busca → {d5, d7}`; a interseção é `{d7}`.

## Verificação final resolvida

| módulo | pergunta | minha resposta |
|---|---|---|
| **1** | Dois motivos pelos quais `"Busca."` e `"busca"` não casam sem limpeza. | caixa (maiúscula) e pontuação (o ponto) — viram tokens distintos |
| **2** | Em `"[^a-z0-9 ]"`, o que o `^` faz — e por que é diferente do `^` de `"^ca"`? | dentro de colchetes é negação ("tudo exceto"); fora, é início do texto |
| **3** | `sem_stop("Os navios do porto de Santos")` devolve o quê, e por que um dos termos sobreviveu? | `"os" "navios" "porto" "santos"`; `os` sobreviveu porque a lista tem `o`, não `os` — a comparação é com a palavra inteira |
| **4** | `wordStem("recuperacao", language = "portuguese")` dá `"recuperaca"`; com `"recuperação"` dá `"recuper"`. Por quê? | o Snowball reconhece o sufixo `-ação` com acento; sem acento só tira a vogal final — o *stemmer* espera o português escrito direito |
| **5** | Onde se usa tokenização por palavra e onde por *subword*, e por quê? | palavra: índice invertido e BM25 (termo legível, busca por termo); *subword*: *embeddings* e redes neurais (sem OOV, pega a morfologia) |
| **6** | Por que `as` venceu `pr` na primeira fusão, se os dois estão em `praias`? | `as` está em três palavras ($5 + 4 + 3 = 12$); `pr` só em duas ($5 + 2 = 7$) — a contagem é ponderada pela frequência |
| **7** | A linha `ix$tf["modelo", ]` tem 8 números; a lista de postagens de `modelo` tem 2 nomes. É a mesma informação? | sim: as postagens são os documentos onde a linha não é zero; o índice só não guarda os zeros e organiza por termo |
| **8** | Num corpus real, um parágrafo diz "porto" três vezes. Sem o `unique` no laço, o que acontece com a lista de postagens de `porto`? | aquele documento entra três vezes na lista — o tamanho da lista deixa de ser o número de documentos ($\text{df}$) |
| **9** | `busca_AND("Modelo, de documentos!")` devolve o quê, e por quê? | `"d2"`: o `prep` tira caixa, pontuação e o `de`, como fez nos documentos; sobram `modelo` e `documentos`, cuja interseção é `{d2}` |

## Execução

O script `estrutura/codigos/2026-10-25-appa-GuiasEstudo.R` executa os exemplos
canônicos e a aplicação ao corpus congelado. As saídas ficam em `estrutura/resultados/guias/`.
