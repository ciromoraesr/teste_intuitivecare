from flask import Flask, jsonify, request
from flask_cors import CORS
import urllib.parse
import polars as pl
import  re

app = Flask(__name__)
CORS(app)


operadoras = pl.read_csv(
    "data/Relatorio_cadop.csv",
    separator=';',
    quote_char='"',
    null_values=['']
)

cb_2024 = pl.read_csv(
    "data//4T2024.csv",
    separator=';',
    quote_char='"',
    null_values=['']
).rename({"REG_ANS": "Registro_ANS"})

#Utilizando a biblioteca polars pelo ganho em tempo de execução (cerca de 5 segundos de ganho por cada busca)
#Essencialmente essa função realiza o mesmo que a query sql da questão 3
def busca_gasto(descr, quant):
    if(quant == ''):
        quant = 10
    cb = cb_2024.join(operadoras, on="Registro_ANS", how="inner")
    filtered = pl.sql(f"""SELECT * from cb WHERE LOWER(cb.DESCRICAO) LIKE '%{descr}%'""").collect()
    filtered = filtered.with_columns(
        ((pl.col("VL_SALDO_FINAL").str.replace(",", ".").cast(pl.Float64).fill_null(0)) -
        (pl.col("VL_SALDO_INICIAL").str.replace(",", ".").cast(pl.Float64).fill_null(0))
        ).alias("Gasto")
    )

    filtered = filtered.with_columns(
        pl.when(pl.col("Nome_Fantasia").is_null() | (pl.col("Nome_Fantasia").str.len_chars() == 0))
        .then(pl.col("Razao_Social"))
        .otherwise(pl.col("Nome_Fantasia"))
        .alias("Nome_Fantasia")
    )

    final = filtered.group_by(["Registro_ANS", "Nome_Fantasia"]).agg(
        pl.col("Gasto").sum().alias("Gasto")
    )

    return (final.sort("Gasto", descending=True).head(quant).to_dict(as_series = False))



# Segunda opção de busca por relevância, dessa vez analisando por nome e data de registro
def busca_normal(nome, quant):
    
    operadoras1  = operadoras.with_columns(
        pl.when(pl.col("Nome_Fantasia").is_null() | (pl.col("Nome_Fantasia").str.len_chars() == 0))
        .then(pl.col("Razao_Social"))
        .otherwise(pl.col("Nome_Fantasia"))
        .alias("Nome_Fantasia")
    )
    operadoras_n = operadoras1.filter(
        pl.col("Nome_Fantasia").str.contains_any([nome], ascii_case_insensitive=True)

    )

    final = operadoras_n.group_by(["Registro_ANS", "Nome_Fantasia"]).agg(
        pl.col("Data_Registro_ANS")
    )
    return (final.sort("Data_Registro_ANS", descending=False).head(quant).to_dict(as_series = False))





#Uma rota que chama as duas funções
@app.route('/busca', methods = ['GET'])
def buscar_operadores():
    raw_query = request.query_string.decode()
    params = urllib.parse.parse_qs(raw_query)
    try:
        query = urllib.parse.unquote(params['q'][0])
    except:
        query = None
    quant = params['quant'][0]
    try:
        nome = urllib.parse.unquote(params['nome'][0])
    except:
        nome = None
    if not query and not nome:
        return jsonify([])
    if(query):
        print(query)
        results = busca_gasto(query, int(quant))
    if(nome):
        results = busca_normal(nome, int(quant))
    
    return jsonify(results)




@app.route('/api/hello')
def hello():
    return jsonify({'message': "sss"})

if __name__ == '__main__':
    app.run(debug=True)