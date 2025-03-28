import requests
from bs4 import BeautifulSoup
import re
import urllib.request
import os

import shutil
#requirements: html5lib, beautifulsoup4

save_dir = os.path.join(os.getcwd(), "final_bin") 
os.makedirs(save_dir, exist_ok=True)


URL = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"
r = requests.get(URL)
data = r.text

soup = BeautifulSoup(data, 'html.parser')

anexo = soup.find_all('a')
urls = []
#Separando os elementos que estão de acordo com a instrulões
for tag in anexo:
    if("Anexo" in tag.text and "pdf" in str(tag)):
        urls.append(tag)
        
anexo1, anexo2 = str(urls[0]), str(urls[1])
#Pegando o endereço separada de cada url
li1 = re.findall(r'\"(.*?)\"', anexo1)
li2 = re.findall(r'\"(.*?)\"', anexo2)
for i in li1:
    if "pdf" in i:
        url1 = i
for i in li2:
    if "pdf" in i:
        url2 = i



file_Path1 = os.path.join(save_dir, "anexo1.pdf")
file_Path2 = os.path.join(save_dir, "anexo2.pdf")

try:
    urllib.request.urlretrieve(url1, file_Path1)
    urllib.request.urlretrieve(url2, file_Path2)
    print(f"baixado: {file_Path1}")
    print(f"baixado: {file_Path2}")
except Exception as e:
    print(f"erro: {e}")


#Criando a pasta zip com os arquivos solicitados
zip_file = os.path.join(os.getcwd(), "anexo_bin_zipada.zip")
shutil.make_archive(zip_file.replace(".zip", ""), 'zip', save_dir)
#Deletando a pasta criada para armazenar temporariamente os arquivos antes de colocar em zip
shutil.rmtree(save_dir)
