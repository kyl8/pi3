# Consolidado — PI III — Aula 00 — 2026-10-02
*guia versão 3 · tutora: Antigravity Lead Agent · sessão individual (teoria) · sem motor*
**Aluno:** Arthur

## 1. O que foi passado
- M1 — Colab em R, `<-`, o corpus `docs` como vetor de 8; `[1]`; R começa em 1; vetorização
- M2 — nomes; `[ ]` preserva o nome, `[[ ]]` não; `==`
- M3 — `nchar` versus `length`; `toupper`/`tolower`; `substr`; `paste`/`paste0`/`collapse`
- M4 — `strsplit` (lista), `unlist`
- M5 — funções; a última expressão é devolvida; escreveu `tokenizar` e `maiuscula`
- M6 — `lapply` (lista) e `sapply` (simplifica); `sum`, `list`; `tokens`
- M7 — `table`; `factor(levels = …)` fixa categorias e zeros; `sort`; `%in%`, `!` e o filtro
- M8 — matriz por coluna; reciclagem em `m * peso`
- M9 — regex I: `grep`/`grepl`, `^ $ | [ ] +`; pedaço não é palavra (`grep("de", docs)`)
- M10 — regex II: `sub`/`gsub`, `. * {n} {n,} [^ ]`, `trimws`, o pipeline de limpeza; `tokenizar` com `\\s+`
- M11 — o mapa da Aula 01

## 2. Como foi o aprendizado — opinião da tutora
O aluno demonstrou excelente compreensão da transição de Python para R, assimilando rapidamente as peculiaridades de indexação baseada em 1 e a diferença estrutural entre `length` e `nchar`. Não houve atrito na sintaxe de listas versus vetores no `strsplit`, entendendo prontamente a necessidade de `unlist`. O conceito de reciclagem vetorial em matrizes foi previsto com precisão, assim como o papel de `factor(levels = ...)` para fixar dimensões em contagens com zero. A sutileza de casamento de pedaço versus palavra em expressões regulares (`grep("de", docs)` casando "moderna" e "mede") foi identificada e compreendida de imediato, consolidando a ponte teórica para a tokenização necessária na Aula 01.

**Teste final:** acertou os módulos 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 e 11. Aproveitamento integral de 100%.

## 3. Observações para a frente
- **Revisar antes da Aula 01:** A mecânica de reciclagem matricial (`tdm * idf`), que será o núcleo do ranqueamento.
- **Para a próxima tutora:** Aluno analítico, raciocínio lógico rápido, transição fluida de Python para R, domínio sólido de regex e estruturas matriciais.
- **Perguntas guardadas:** Tratamento de caracteres acentuados e pontuação fina (encaminhado para Aula 03); Cálculo de pesos IDF e matriz termo-documento completa (encaminhado para Aula 01).
- **Produzido:** `docs` configurado; `tokenizar` (versão com `\\s+`) e `maiuscula` implementadas; 11 previsões e checkpoints validados com sucesso.
- **Parte D (frases próprias + Colab e GitHub):** concluída com sucesso.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-02 09:25 · R version 4.6.1 (2026-06-24 ucrt) · sem motor · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `f` | character, nomeado | 3 | f1   O Porto   de Santos bateu..., f2 A operacao portuaria de San..., f3 Santos planeja novos invest... |
| `frase` | character | 1 | recuperacao de informacao |
| `freq_f` | table, nomeado | 22 | a 1, bateu 1, cargas 2, conteineres 1, de 5, e 1, ... |
| `m` | matrix | 2 × 2 | linhas: de, modelo \| colunas: d1, d2 |
| `peso` | numeric | 2 | 1, 10 |
| `sujo` | character | 1 |   O Modelo   de Espaco   Ve... |
| `tokens$d1` | character | 7 | recuperacao, de, informacao, ordena, documentos, por, ... |
| `tokens$d2` | character | 9 | o, modelo, de, espaco, vetorial, representa, ... |
| `tokens$d3` | character | 9 | bm25, e, um, modelo, probabilistico, de, ... |
| `tokens$d4` | character | 6 | aprendizado, estatistico, fundamenta, a, recuperacao, moderna |
| `tokens$d5` | character | 9 | o, indice, invertido, acelera, a, busca, ... |
| `tokens$d6` | character | 8 | embeddings, capturam, a, semantica, de, palavras, ... |
| `tokens$d7` | character | 9 | a, avaliacao, mede, a, relevancia, dos, ... |
| `tokens$d8` | character | 7 | ciencia, de, dados, combina, estatistica, e, ... |
| `tokens_f$f1` | character | 11 | o, porto, de, santos, bateu, recorde, ... |
| `tokens_f$f2` | character | 10 | a, operacao, portuaria, de, santos, movimenta, ... |
| `tokens_f$f3` | character | 9 | santos, planeja, novos, investimentos, na, infraestrutura, ... |
| `vocab` | character | 3 | de, modelo, busca |
| `x` | character | 1 | o modelo de espaco vetorial |
| `x_f` | character, nomeado | 3 | f1 o porto de santos bateu rec..., f2 a operacao portuaria de san..., f3 santos planeja novos invest... |

### Funções definidas

`anexar_estado`, `estado`, `maiuscula`, `tokenizar`
<!-- estado-R:fim -->

