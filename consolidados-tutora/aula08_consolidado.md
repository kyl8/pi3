# Aula 08 — recuperação e reordenação

**Documento de estudo com apoio de IA; não registra uma sessão individual nem avaliação de aprendizagem.**

O primeiro estágio recupera candidatos de todo o corpus; o segundo só reordena a cabeça. Um relevante fora dela permanece na cauda. BM25 ignora ordem; LSA pré-calcula vetores de documentos; a proximidade ordenada lê termos da consulta e do documento em conjunto, mas só encontra coincidências literais próximas e na ordem indicada. Um cross-encoder treinado é conceitualmente mais expressivo e mais custoso por par, sem garantia de ser correto.

Profundidade e janela são hiperparâmetros escolhidos no desenvolvimento; o teste deve ser reservado para uma avaliação final. Os exemplos e as duas consultas estão em [resoluções](aula08_resolvido.md); a aplicação, números e limitações estão no [consolidado da Parte D](aula08_parteD_consolidado.md). Não houve registro de teste pessoal ou de presença dos integrantes.
