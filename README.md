# RESOLUÇÃO DO TESTE DE NIVELAMENTO INTUITIVE CARE

## Irei agora passar por cada questão explicando como fiz para resolvê-la, e como testá-la no computador próprio (considerando que você já tenha python instalado no computador)

# 1 - Teste de WEB SCRAPING.

- Para resolver essa questão, utilizei as bibliotecas html5lib e beautifulsoup4
  Basicamente o que fiz foi reduzir a busca a uma busca textual, buscando pelas tags <a> e então buscando pela palavra pdf. Após isso eu isolei a url de cada pdf e os instalei utilizando a urrlib.request

- Para executar o código:
   ```
  pip install html4lib
  pip install beautifulsoup4
  python teste_1.py
   ```
  Após isso um arquivo zip chamado "anexo_bin_zipada.zip" vai ser criado com os 2 PDFs dentro dele.

# 2 - Teste de Transformação de dados.

- Para extrair dados do pdf, eu testei muitas bibliotecas. Mas a que foi capaz de detectar com mais clareza foi a pdfplumber.
  O código puxa o resultado do teste_1.py e extrai o conteúdo dele, lendo assim o conteúdo do pdf 1 como pedido.

  O processo de leitura com o pdfplumber teve um tempo de execução meio longo, pela quantidade de tabelas dentro do pdf, mas esse resultado infelizmente foi o melhor que encontrei dentro das bibliotecas existentes.
  Para executar o código:
   ```
  pip install pandas
  pip install pdfplumber
  python teste_2.py
    ```
  Após a extração, as tabelas são convertidas em um **DataFrame do pandas**, onde aplico a substituição das legendas definidas. No final, todas as tabelas processadas são concatenadas em um **CSV final**, ajustando as colunas **OD** e **AMB**, além da coluna **RN**, que continha um caractere especial que poderia causar erros.  

  O código final salva uma pasta zip chamada Teste_Ciro_Moraes, com o respectivo csv da tabela dentro.

# 3 - Teste de Banco de Dados

- Para essa etapa, utilizei **MySQL**, garantindo a configuração correta do **encoding** ao ler os arquivos CSV.  
  Para permitir a importação dos arquivos, foi necessário modificar o arquivo `my.ini` localizado em `ProgramData/MySQL/MySQL Server 8.0/`, alterando o parâmetro `secure-file-priv` para `""`.  

   Em seguida, criei três tabelas: uma para **operadoras** e outra para **contabilidade anual**, onde cada trimestre foi inserido separadamente e consolidado em uma única tabela.  

  Tive que tomar cuidado pois muitos desses arquivos estavam com problemas de formatação, seja na data ou até na falta de aspas em arquivos NULLs.
  
  Para otimizar as consultas, adicionei **índices** nas tabelas, reduzindo o tempo de execução das duas **queries finais** em aproximadamente **4 segundos**, segundo meus testes.
   
# 4 - Teste de API

- Durante este teste, me perdi um pouco, mas acabei chegando a um resultado concreto. Desenvolvi uma API em Flask que aceita dois parâmetros: a descrição (`q`) ou o nome (`nome`), ambos seguidos da quantidade.
- Para a busca por descrição, utilizei a biblioteca Polars, que, por depender de queries constantes, mostrou-se bem mais rápida que o Pandas. Em testes, o tempo de execução caiu de 2.6 segundos (com Pandas) para 0.4 segundos (com Polars).
  
- O frontend foi construído com **Vue.js** e estilizado com **Tailwind CSS**, a tecnologia com a qual tenho mais familiaridade. Criei os métodos de requisição ao backend e botões para que o usuário defina o modo desejado.  
- Disponibilizei o código fonte para testes e fiz o deploy da API e do frontend no **Vercel** para facilitar a visualização e teste:
  ![Image](https://github.com/user-attachments/assets/09a04c7e-b850-41c2-bd39-5ccf5721abcb)
  
  - **Frontend**: [https://vuefrontintuitive4.vercel.app/](https://vuefrontintuitive4.vercel.app/)
    
  - **Backend**: [https://flaskapiintuitive4.vercel.app/](https://flaskapiintuitive4.vercel.app/)
- No código-fonte do **Teste 4**, há um **JSON** com os testes realizados no **Postman**, para utiliza-la, basta importar esse json em sua conta no postman.
  ![Image](https://github.com/user-attachments/assets/b9ebbe58-55e5-410f-973a-ae8ec8d4c7e0)  
- Realizei **5 testes**, demonstrando a capacidade da API.  
- Para testar a API, basta utilizar um dos seguintes endpoints:  

  - **Busca por descrição:**  
    ```
    https://flaskapiintuitive4.vercel.app/busca?q=<desc>&quant=<quantidade>
    ```  

  - **Busca por nome da empresa:**  
    ```
    https://flaskapiintuitive4.vercel.app/busca?nome=<empresa_nome>&quant=<quantidade>
    ```
  
- Para testar o código localmente:

  - **Backend**:
    ```sh
    cd teste_4
    cd flask_api
    pip install -r requirements.txt
    python app.py
    ```

  - **Frontend**:
    ```sh
    cd teste_4
    cd vue_front
    npm install
    npm run dev
    ```
