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

### Executável para o pendrive

Copie apenas `Busca-APPA.exe` para o pendrive e abra o arquivo no Windows 10 ou 11 de 64 bits. O motor, o R, as bibliotecas, o corpus e as fontes estão dentro dele. A busca abre no navegador padrão e usa somente localhost. O executável extrai o conteúdo em uma pasta temporária e tenta removê-la ao clicar em **Encerrar**.

O pacote foi testado a partir de uma cópia isolada em uma pasta com espaços, com o navegador impedido de acessar rede externa. O computador da escola precisa permitir a execução de aplicativos locais sem assinatura e ter um navegador atualizado. A versão empacotada não exige instalação do R.

### Executar a partir do código

1. Baixe ou clone o repositório inteiro. No R, instale os pacotes uma vez: `install.packages(c("shiny", "SnowballC"))`.
2. No Windows, abra [motor/abrir.cmd](motor/abrir.cmd). Em qualquer sistema, use `Rscript entregas/entrega-final/motor/iniciar.R` na raiz do repositório.
3. Digite uma consulta ou escolha um exemplo e clique em **Pesquisar**. Comece com a busca híbrida e selecione **MMR (diversidade)** para ver as duas listas. Use $λ=1$ para reproduzir a ordem inicial e depois $λ=0{,}7$ para observar uma reordenação.

O app usa os 141 parágrafos do corpus. Os trechos exibem a procedência, a pontuação corrigida e o termo encontrado em destaque. Clique no título para abrir o texto completo. Os links opcionais da Wikipédia e da licença usam internet quando clicados. Depois da instalação dos pacotes, a execução pelo código também funciona sem internet. Para encerrar, interrompa o R com Ctrl+C.

A redundância exibida é o maior cosseno entre pares dos três primeiros parágrafos. Uma redução indica menos semelhança de vocabulário. Para saber se entrou um aspecto novo, leia os trechos antes e depois.

Para reproduzir as duas buscas comparadas no slide do motor, execute `Rscript entregas/entrega-final/motor/avaliar.R` na raiz. A [tabela de desenvolvimento](../../estrutura/codigos/resultados/aula08-mmr-motor-dev.csv) inclui AP, semelhança e top-5 com e sem MMR. Os graus são assistidos.

### Gerar o executável

No Windows, use Python, .NET Framework e uma instalação x64 do R com `shiny` e `SnowballC` disponíveis. A partir da raiz:

```powershell
python entregas/entrega-final/motor/portable/empacotar.py --r "C:\caminho\do\R" --saida "D:\Busca-APPA.exe"
```

O gerador inclui os pacotes necessários do R, o código desta busca e os recursos locais. As licenças da fonte DM Sans e do R acompanham o pacote.
