import zipfile
import os
import pdfplumber
import pandas as pd
import shutil
#extraindo o pdf resultado do teste 1
zip_path = os.path.join(os.getcwd(), "anexo_bin_zipada.zip")
extract_dir = "dest"
os.makedirs(extract_dir, exist_ok= True)

with zipfile.ZipFile(zip_path, 'r') as zip_ref:
    zip_ref.extractall(extract_dir)
    



pdf_path = os.path.join(extract_dir, "anexo1.pdf")

tables = []

#lendo o pdf usando a biblioteca pdfplumber
with pdfplumber.open(pdf_path) as pdf:
    #parte mais demorada do código já que existem muitas linhas em cada tabela
    num_pages = len(pdf.pages)
    page = pdf.pages[2]
    textos = page.extract_text() 
    print(f"Processando {num_pages} páginas...") 
    for i in range(2, num_pages):
        page = pdf.pages[i]
        table = page.extract_table()
        if table:
            df = pd.DataFrame(table[1:], columns = table[0])
            tables.append(df)
        
    


for i in range(len(textos)):
    #como a legenda é a última parte dos textos dentro do pdf. esse recorte consegue tratar perfeitamente
    if(textos[i:i+8] == "Legenda:"):
        categorias = textos[i+9:len(textos) - 1]
legendas = categorias.strip().split()

#Formatação para atribuir as legendas a cada uma das abreviações solicitadas
abrevi_leg = {}
for i in range(len(legendas)):
    string_final = ""
    if "OD:" in legendas[i] or "AMB:" in legendas[i]:
        j = i + 1
        while True:
            try:
                if ":" in legendas[j]:
                    string_final = string_final[0:len(string_final) - 1]
                    break
            except:
                break
            string_final = string_final + legendas[j]
            string_final = string_final + " "
            j = j + 1
        abrevi_leg[legendas[i][0:len(legendas[i]) - 1]] = string_final
    

#concatenando todos os dataframes em um só para salvar em csv
     
final = pd.concat(tables, ignore_index = True)
#alterando o nome das colunas solicitadas e também retirando o marcador de fim de linha para melhor formatação do csv
final = final.rename(columns = {'RN\n(alteração)':'RN (alteração)','OD': abrevi_leg['OD'], 'AMB': abrevi_leg['AMB']})

compression_opts = dict(method='zip',
                        archive_name='output_Teste_Ciro_Moraes.csv')  
final.to_csv('Teste_Ciro_Moraes.zip', index=False,
          compression=compression_opts)
print(f"concluido!. arquivo: Teste_Ciro_Moraes.zip salvo em {os.getcwd()}")
#deletando a pasta auxilar após usa-la
shutil.rmtree(extract_dir)  
