# Julgamentos consolidados e comparação de modelos

Consolidação feita com apoio de IA a pedido do grupo. As referências `claude_leitura` e `codex_assistido` são avaliações assistidas, não votos de integrantes. Suas condições de produção anteriores não permitem afirmar independência entre avaliadores humanos nem calcular concordância humana.

## Cobertura e busca complementar

A referência Claude cobre os 101 pares do pool v2 e mais 51 pares fora dele. A união com a referência Codex acrescenta 19 pares distintos: o [consolidado assistido](../estrutura/codigos/05-julgamento/csv/2026-11-11-appa-05-qrels-consolidado-assistido.csv) contém 171 pares únicos, dos quais 70 fora do pool. Decisão: aproveitar essa busca complementar já realizada, sem afirmar que o corpus inteiro foi julgado. Pares não julgados são tratados como não relevantes nas métricas; isso pode subestimar relevantes e enviesar a comparação.

As duas referências têm 47 pares em comum, dos quais 45 estão no pool. Na escala de 0 a 2, a concordância observada é 93,62% e o kappa de Cohen é 0,9036 nos 47 pares; na escala binária com limiar 2, 97,87% e 0,9519. Nos 45 pares do pool, o kappa de três graus é 0,8990. São medidas entre saídas assistidas, numa interseção selecionada, e não medem concordância entre pessoas.

## Divergências revisadas

Uma revisão adicional assistida examinou os três casos divergentes; é uma decisão editorial, não um terceiro voto independente:

| Par | Claude | Codex | Decisão | Motivo |
|---|---:|---:|---:|---|
| q01/d70 | 0 | 1 | 1 | Contexto histórico do confronto do Santos, mas não sua formação. |
| q05/d107 | 1 | 2 | 2 | Relata confronto contra o Olympiacos e sua repercussão, dentro da necessidade de confrontos. |
| q05/d26 | 1 | 0 | 1 | Jogo amistoso fornece contexto, sem rivalidade entre clubes identificada. |

Nos pares sem divergência, conserva-se o acordo; nos pares com uma única avaliação, conserva-se essa avaliação. As planilhas humanas não foram preenchidas com notas geradas por IA.

## Modelos

Com o consolidado assistido, AP no ranking completo, limiar 2, LSA com 20 dimensões e RRF com c=60:

| Modelo | MAP desenvolvimento | MAP teste retrospectivo |
|---|---:|---:|
| BM25 | 0,250729 | 0,440243 |
| Cosseno | 0,253445 | 0,445875 |
| LSA | 0,302773 | 0,411741 |
| Híbrido | 0,325449 | 0,465251 |

O híbrido tem o maior MAP no desenvolvimento entre esses quatro candidatos e permanece como configuração experimental. O teste já era conhecido e os julgamentos são assistidos: os números não estabelecem desempenho generalizável. Os julgamentos foram construídos sobre um pool derivado de rankings, logo modelos e referência não são independentes.

Reproduzir: `Rscript estrutura/codigos/05-julgamento/2026-11-11-appa-05j-consolidar-assistidos.R`. O script gera o qrels consolidado, [divergências](../estrutura/codigos/resultados/2026-11-11-appa-divergencias-assistidas.csv), [concordância](../estrutura/codigos/resultados/2026-11-11-appa-kappa-assistido.csv), métricas por consulta e placar; preserva os arquivos originais e as planilhas humanas.
