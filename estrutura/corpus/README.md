# Corpus

Os scripts atuais montam o corpus diretamente a partir de páginas da Wikipédia. Por isso, os textos não ficam duplicados nesta pasta.

As páginas usadas são Santos Futebol Clube, Associação Atlética Portuguesa e Jabaquara Atlético Clube.

Para garantir reprodutibilidade estrita nas entregas acadêmicas, a pasta contém a versão serializada do corpus congelada:
- `docs.rds`: vetor nomeado com os 141 parágrafos textuais (d1 a d141);
- `origem.rds`: vetor nomeado associando cada documento ao clube correspondente (Santos FC, Portuguesa Santista, Jabaquara).
