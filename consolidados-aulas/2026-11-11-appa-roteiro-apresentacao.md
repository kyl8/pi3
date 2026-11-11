# Roteiro de apresentação — PI III

Material preparado com apoio de IA para apresentação do APPA. A existência deste roteiro não registra que a apresentação tenha ocorrido.

1. **Problema:** facilitar a consulta à memória dos clubes de futebol da Baixada Santista. O corpus congelado contém 141 parágrafos de três artigos, com identificadores estáveis.
2. **Funcionamento:** o texto passa por normalização, remoção de palavras frequentes e stemming. BM25 e LSA são combinados por RRF; a reordenação por proximidade está implementada, mas desligada por padrão.
3. **Avaliação:** o pool tem 101 pares. O consolidado assistido reúne 171 pares, incluindo 70 fora do pool; os graus são de IA, não votos humanos. A concordância medida se refere apenas às referências assistidas.
4. **Resultados:** com esse consolidado, MAP de desenvolvimento: BM25 0,250729, cosseno 0,253445, LSA 0,302773, híbrido 0,325449. O teste é retrospectivo e documentos não julgados são tratados como não relevantes.
5. **Demonstração:** executar `Rscript estrutura/codigos/executar_atualizacao.R`; mostrar as consultas, os rankings e o texto dos documentos em `estrutura/codigos/resultados/aula08-comparacao-textos.csv`, junto das limitações registradas no consolidado assistido.
6. **Decisão sobre corpus:** manter o corpus congelado evita alterar os identificadores dos julgamentos. O enunciado previa 20 a 60 documentos; a aceitação dos 141 exige manifestação do professor. Se for necessário reduzir, produzir nova versão do corpus e refazer pool, julgamentos e métricas, preservando os arquivos anteriores.

Referências: [ficha do projeto](00_FICHA_PROJETO.md) e [julgamentos assistidos](2026-11-11-appa-julgamentos-assistidos-consolidados.md).
