"""Importa as saídas do exercício MMR calculadas em R."""
import csv
import json
from pathlib import Path

root = Path(__file__).resolve().parent
repo = root.parents[1]
out = repo / 'estrutura/codigos/resultados'

def read(path):
    with path.open(encoding='utf-8-sig', newline='') as stream:
        return list(csv.DictReader(stream))

grade = [{k: float(v) for k, v in row.items()} for row in read(out/'aula08-mmr-dev.csv')]
teste = [dict(consulta=r['consulta'], antes=float(r['antes']), depois=float(r['depois']))
         for r in read(out/'aula08-mmr-teste.csv')]
top = read(out/'aula08-mmr-top.csv')
assuntos = {'d4':'conquistas', 'd2':'Pelé e títulos', 'd95':'origem do futebol feminino',
            'd97':'destaque no futebol feminino', 'd55':'história do hino'}
top = [dict(lambda_=float(row['lambda']), id=row['id'], texto=row['texto'],
            assunto=assuntos.get(row['id'],'parágrafo do corpus')) for row in top]
for row in top:
    row['lambda'] = row.pop('lambda_')
exemplo = [{k:float(v) for k,v in row.items()} for row in read(out/'aula08-mmr-exemplo.csv')]
corpus = len(read(repo/'estrutura/corpus/banco-de-dados/corpus.csv'))
motor = [dict(consulta=r['consulta'], **{k:float(r[k]) for k in
         ('ap_antes','ap_depois','red_antes','red_depois')}) for r in read(out/'aula08-mmr-motor-dev.csv')]
(root/'src/dados.json').write_text(json.dumps(dict(grade=grade, teste=teste, top=top, exemplo=exemplo, corpus=corpus, motor=motor),
                                             ensure_ascii=False, indent=2)+'\n', encoding='utf8')
