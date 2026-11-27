# Entrega final · Projeto Integrador III · APPA

Arthur Galvão, Pedro Henrique e Ailana Pereira Gonsalez · Prof. Dr. João Paulo Ferreira de Mello.

| Material | Acesso |
|---|---|
| Aula 08, Tema 5 · Pedro Henrique | [Consolidado individual](../../consolidados/aula08_tema/pedro.md) |
| Aula 08, Tema 5 · Ailana Pereira Gonsalez | [Consolidado individual](../../consolidados/aula08_tema/ailana.md) |
| Aula 08, Tema 5 · Arthur Galvão | [Consolidado individual](../../consolidados/aula08_tema/arthur.md) |
| Execução da atividade | [Notas e consolidados](../../consolidados/aula08_tema/CONSOLIDADOS.md) · [saídas do R](../../estrutura/codigos/resultados/aula08-mmr-saidas.txt) |
| Apresentação | [HTML offline](../apresentacao-final/apresentacao-pi3-appa.html) · [PDF](../apresentacao-final/apresentacao-pi3-appa.pdf) |
| Artigo do corpus | [PDF](../entrega-1/2026-10-02-appa-entrega-1-corpus.pdf) |

Os percursos individuais são simulados. Os números do exercício vêm da execução em R. O motor interativo usa a preparação padrão do APPA, com stemming. A grade relatada nos slides usa o preparo do exercício com motor08 v2, então a interface ao vivo pode ordenar os parágrafos de outra forma.

## Testar o motor na apresentação

1. Baixe ou clone o repositório inteiro. No R, instale os pacotes uma vez: `install.packages(c("shiny", "SnowballC"))`.
2. No Windows, abra [motor/abrir.cmd](motor/abrir.cmd). Em qualquer sistema, use `Rscript entregas/entrega-final/motor/iniciar.R` na raiz do repositório.
3. Digite uma consulta ou escolha um exemplo e clique em **Pesquisar**. Comece com a busca híbrida e selecione **MMR (diversidade)** para ver as duas listas. Use $λ=1$ para reproduzir a ordem inicial e depois $λ=0{,}7$ para observar uma reordenação.

O app roda no navegador da própria máquina com os 141 parágrafos do corpus. Depois da instalação inicial, pode pesquisar sem internet. Para encerrar, interrompa o R com Ctrl+C. Os links de fonte usam internet quando abertos.

A redundância exibida é o maior cosseno entre pares dos três primeiros parágrafos. Uma redução indica menos semelhança de vocabulário. Para saber se entrou um aspecto novo, leia os trechos antes e depois.

Para reproduzir as duas buscas comparadas no slide do motor, execute `Rscript entregas/entrega-final/motor/avaliar.R` na raiz. A [tabela de desenvolvimento](../../estrutura/codigos/resultados/aula08-mmr-motor-dev.csv) inclui AP, semelhança e top-5 com e sem MMR. Os graus são assistidos.
