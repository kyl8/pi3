# Consolidado — PI III — Aula 01 — 2026-10-02
*guia versao 4 · tutora: Antigravity Lead Agent · sessao individual/grupo (teoria) · motor01*
**Grupo:** APPA (Arthur Galvao, Pedro Henrique, Ailana)

## 1. O que foi passado
- M1 — Diferenca entre RI e bancos de dados: relevancia versus exatidao, lista ordenada versus conjunto
- M2 — Arquitetura retrieve & rerank em dois estagios: escalabilidade do filtro rapido e precisao do refinador
- M3 — O corpus canonico de 8 documentos como vetor nomeado em R; inspecao com nchar e length
- M4 — Tokenizacao funcional com tolower e quebra em espacos (\\s+); diferenca entre vetor e lista
- M5 — Vocabulario ordenado de 45 termos unicos com unique e sort; analise de frequencias com table
- M6 — Construcao da Matriz Termo-Documento (TDM) 45 × 8 usando factor(tk, levels = vocab) e sapply
- M7 — Busca booleana exata e intersecao de consultas com intersect (operador AND)
- M8 — Fundamento do IDF: log(N/df); termos frequentes versus termos discriminativos no corpus
- M9 — Calculo da matriz TF-IDF completa via reciclagem matricial termo a termo (tdm * idf)
- M10 — Comparativo epistemologico entre busca por substring (grep) e busca por termos de vocabulario no motor

## 2. Como foi o aprendizado — opiniao da tutora
O grupo demonstrou pleno dominio dos conceitos fundamentais de Recuperacao de Informacao, assimilando com precisao a transicao da busca exata relacional para o ordenamento por relevancia. Na manipulacao de estruturas no R, a diferenca entre o vetor homogeneo `docs` e a lista polimorfica `tokens` foi prontamente compreendida. A construcao da matriz TDM utilizando `factor(levels = vocab)` evidenciou compreensao profunda da necessidade de fixar categorias e preservar a dimensionalidade retangular ($45 \times 8$). O calculo do IDF e a multiplicacao `tdm * idf` via reciclagem coluna a coluna foram assimilados com rigor matematico, identificando que termos universais recebem peso nulo (log(1) = 0). No comparativo final, o grupo distinguiu com clareza a limitacao de casamento por substring da regex contra a indexacao formal por vocabulario.

**Teste final de 10 questoes:**
1. RI vs Banco de Dados: Explicado com clareza (relevancia e lista ordenada versus correspondencia booleana exata).
2. Retrieve & Rerank: Dois estagios necessarios devido ao custo computacional de modelos finos em larga escala.
3. Docs vs Tokens: Docs e vetor de strings; tokens e lista pois documentos possuem diferentes quantidades de palavras.
4. Saida de tokenizar: Retorna vetor de termos em caixa baixa limpos de espacos em branco multiplos.
5. Contagem de palavras: 64 termos totais reduzidos a 45 unicos devido a recorrencia de palavras gramaticais.
6. Funcao de factor na TDM: Garante que todas as colunas tenham exatamente os mesmos 45 termos na mesma ordem.
7. Escopo da busca booleana: Responde apenas quais documentos contem os termos, sem ordenamento por relevancia.
8. Calculo de peso IDF: 2 * log(8/4) = 2 * 0.6931 = 1.3862.
9. Mecanismo de tdm * idf: Reciclagem vetorial de idf ao longo das colunas da matriz tdm.
10. Grep vs Motor: O motor opera sobre termos atomicos indexados no espaco vetorial, enquanto grep faz varredura sequencial de substrings.

**Resultado do teste:** Acerto integral nos 10 modulos (10/10). Aproveitamento de 100%.

## 3. Observacoes para a frente
- **Revisar antes da Aula 1,5 e Aula 02:** O fundamento teorico-informacional do logaritmo (Shannon) e o calculo de similaridade por cosseno.
- **Para a proxima tutora:** Grupo extremamente afiado, raciocinio matematico consolidado e dominio impecavel das estruturas de dados do R.
- **Perguntas guardadas:** Origem da base logaritmica no IDF (Aula 1,5); Normalizacao de vetores pelo cosseno (Aula 02); Higienizacao de acentos e stopwords (Aula 03).
- **Produzido:** Matriz TDM $45 \times 8$; matriz TF-IDF; testes booleanos com `intersect`; teste final de 10 questoes aprovado com louvor.
- **Parte D:** Concluida com o grupo APPA, fundando o projeto com corpus regional e Ficha de Projeto.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-02 11:34 · R version 4.6.1 (2026-06-24 ucrt) · motor01 v1 2026-10-01 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `consolidado_teoria_conteudo` | character | 39 | # Consolidado — PI III — Au..., *guia versao 4 · tutora: An..., **Grupo:** APPA (Arthur Gal..., , ## 1. O que foi passado, - M1 — Diferenca entre RI e..., ... |
| `df_teoria` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `docs_teoria` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `freq_teoria` | table, nomeado | 45 | a 5, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `grep_res` | integer | 2 | 1, 4 |
| `idf_teoria` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `motor_res` | character | 0 |  |
| `MOTOR_VERSAO` | character | 1 | motor01 v1 2026-10-01 |
| `N_teoria` | integer | 1 | 8 |
| `res_and` | character | 1 | d5 |
| `res_modelo` | character | 2 | d2, d3 |
| `tdm_teoria` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `tfidf_teoria` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `tokens_teoria$d1` | character | 7 | recuperacao, de, informacao, ordena, documentos, por, ... |
| `tokens_teoria$d2` | character | 9 | o, modelo, de, espaco, vetorial, representa, ... |
| `tokens_teoria$d3` | character | 9 | bm25, e, um, modelo, probabilistico, de, ... |
| `tokens_teoria$d4` | character | 6 | aprendizado, estatistico, fundamenta, a, recuperacao, moderna |
| `tokens_teoria$d5` | character | 9 | o, indice, invertido, acelera, a, busca, ... |
| `tokens_teoria$d6` | character | 8 | embeddings, capturam, a, semantica, de, palavras, ... |
| `tokens_teoria$d7` | character | 9 | a, avaliacao, mede, a, relevancia, dos, ... |
| `tokens_teoria$d8` | character | 7 | ciencia, de, dados, combina, estatistica, e, ... |
| `url_motor` | character | 1 | https://raw.githubuserconte... |
| `vocab_teoria` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |

### Funções definidas

`anexar_estado`, `busca_booleana`, `estado`, `tokenizar`
<!-- estado-R:fim -->

