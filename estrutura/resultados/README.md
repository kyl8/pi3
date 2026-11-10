# Resultados

Esta pasta guarda as saídas das avaliações do motor.

## Arquivos atuais (outubro de 2026)

Prefixo `2026-10-25-appa-07-*` e a pasta `guias/`. Usam vírgula como separador de campos e ponto decimal (`write.csv`). Foram calculados sobre o corpus congelado (141 parágrafos) e o qrels assistido (`codex_assistido`), com as decisões de `estrutura/codigos/config.R`.

Para regenerar, execute `Rscript estrutura/codigos/executar_atualizacao.R` a partir da raiz do repositório.

## Arquivos históricos (setembro de 2026) — obsoletos

- `2026-09-15-appa-05-MetricasRanking.csv` e `2026-09-15-appa-05-Necessidades.csv`: relevância definida só pelo clube de origem do parágrafo; o recall usa como denominador todos os parágrafos do clube. Serviram para testar o pipeline e **não** devem ser citados como avaliação.
- `2026-09-18-appa-05b-MetricasGabaritoProprio.csv`: calculado com o qrels de regra (`referencia_inicial_appa`) e com `k1 = 1,2` e as 90 stopwords do script BM25 antigo; nDCG binário e P@3 desse arquivo foram gerados antes da correção do script (ver `2026-09-18-...ParteD-MetricasGabaritoProprio.r`). Os três usam ponto e vírgula e vírgula decimal (`write.csv2`).

Esses três arquivos são reescritos se os scripts de setembro forem executados novamente.
