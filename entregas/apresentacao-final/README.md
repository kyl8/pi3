# Projeto Integrador III — diversidade no topo da busca

Abra [a apresentação offline](apresentacao-pi3-appa.html) no navegador. A [versão PDF](apresentacao-pi3-appa.pdf) traz a grade completa no slide de desenvolvimento. O deck usa React e Remotion com a navegação, o índice e as notas do modelo APPA. A paleta verde, creme e dourada identifica PI III.

Use as setas para navegar, **M** para o índice, **N** para as notas e **F** para tela cheia. Na grade, selecione o peso de relevância para comparar o MAP, o nDCG graduado, a redundância e a ordem dos cinco primeiros parágrafos. Passe o cursor sobre um resultado para ler o trecho. A leitura no celular inclui um seletor maior.

Os números da grade e do teste vêm da execução em R do Tema 5. O slide do motor ao vivo usa a preparação padrão do APPA com stemming, como na interface. A consulta de história do Santos melhora em AP e fica menos repetitiva. Na busca pelo estádio do Jabaquara, a semelhança diminui e o AP cai. São resultados de desenvolvimento com julgamentos assistidos. O teste retrospectivo do exercício usa o valor de exemplo de 0,7. [Abrir instruções da busca](../entrega-final/README.md).

Os trechos do corpus são da Wikipédia em português, sob [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.pt-br). A demonstração de história consulta parágrafos de [Santos Futebol Clube](https://pt.wikipedia.org/wiki/Santos_Futebol_Clube) e [Associação Atlética Portuguesa (Santos)](https://pt.wikipedia.org/wiki/Associa%C3%A7%C3%A3o_Atl%C3%A9tica_Portuguesa_(Santos)). O corpus também inclui [Jabaquara Atlético Clube](https://pt.wikipedia.org/wiki/Jabaquara_Atl%C3%A9tico_Clube).

Para reproduzir, rode a partir da raiz:

```powershell
Rscript estrutura/codigos/aula08_mmr.R
Rscript entregas/entrega-final/motor/avaliar.R
```

Depois, nesta pasta:

```powershell
npm ci
npm run dados
npm run build
npm test
npm run pdf
```

A primeira instalação usa rede. O HTML gerado incorpora código, fontes e dados. O PDF requer Python com PyMuPDF e um Chrome/Chromium compatível. Use `CHROME_PATH` se o navegador estiver em outro caminho.
