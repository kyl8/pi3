# Consolidado — PI III — Aula 00 Parte D — 2026-10-02
*guia versão 3 · tutora: Antigravity Lead Agent · sessão individual (prática) · sem motor*
**Aluno:** Arthur

## 1. O que foi passado
- M12 — Três frases próprias sobre o Porto de Santos, pipeline de limpeza em 4 linhas (`trimws`, `tolower`, `gsub`), tokenização e análise de frequência com `table` e `unique`
- M13 — Expressões regulares nas frases próprias com `[A-Z]`, âncoras `^` e `$`, quantificadores, operadores lógicos `&` e substituição com `sub` e `gsub`
- M14 — O fluxo do curso: carregamento remoto de scripts com `source()`, diagnóstico com `estado()`, rotina de persistência do consolidado no Colab com `anexar_estado()`, versionamento no GitHub e leitura remota via URL Raw

## 2. Como foi o aprendizado — opinião da tutora
O aluno executou com autonomia a formulação das três sentenças contextuais voltadas à logística portuária da Baixada Santista, inserindo ruídos intencionais (espaçamento irregular, pontuação mista e dígitos). Aplicou com precisão a ordem correta do pipeline de limpeza, reconhecendo que a inversão de `tolower` com a remoção de caracteres apagaria maiúsculas de forma irreversível. Na contagem de termos, identificou prontamente que a preposição "de" e o substantivo próprio "santos" lideravam as ocorrências, compreendendo na prática o conceito de stopwords e termos frequentes que serão fundamentados na Aula 01 e tratados na Aula 03. No Módulo 13, construiu todas as cinco expressões regulares de forma cirúrgica, acertando o uso de âncoras e quantificadores gulosos, e dominou o fluxo de persistência de dados e código via GitHub Raw e inspeção de ambiente.

## 3. Observações para a frente
- **Revisar antes da Aula 01:** A integração entre as funções de tokenização e a primeira célula da Aula 01 que carregará o `motor01.R`.
- **Para a próxima tutora:** Domínio completo da disciplina de arquivos, facilidade na manipulação de expressões regulares e arquitetura de código em R.
- **Perguntas guardadas:** Estratégias de remoção automática de stopwords na matriz termo-documento (Aula 03).
- **Produzido:** Três frases próprias limpas e tokenizadas; 30 tokens totais e 22 tokens únicos; expressões regulares para validação de formato e higienização; fotografias de estado devidamente anexadas.

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

