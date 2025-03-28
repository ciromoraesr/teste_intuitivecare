
-- Criando a tabela principal com os elementos do csv
CREATE TABLE operadoras (
    Registro_ANS BIGINT PRIMARY KEY,
    CNPJ BIGINT,
    Razao_Social VARCHAR(255),
    Nome_Fantasia VARCHAR(255),
    Modalidade VARCHAR(100),
    Logradouro VARCHAR(255),
    Numero VARCHAR(50),
    Complemento VARCHAR(255),
    Bairro VARCHAR(100),
    Cidade VARCHAR(100),
    UF CHAR(2),
    CEP INT,
    DDD INT,
    Telefone BIGINT,
    Fax BIGINT NULL,
    Endereco_eletronico VARCHAR(255),
    Representante VARCHAR(255) ,
    Cargo_Representante VARCHAR(255) ,
    Regiao_de_Comercializacao INT,
    Data_Registro_ANS DATE 
);



LOAD DATA INFILE 'C:/teste_intuitivecare/teste_3/Relatorio_cadop.csv'
INTO TABLE operadoras
CHARACTER SET UTF8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
-- importante essas condições já que muitos dos dados na tabela estão nulos, sem "". Então assim consigo carregar os dados corretamente.
(
    @Registro_ANS, @CNPJ, @Razao_Social, @Nome_Fantasia, @Modalidade, 
    @Logradouro, @Numero, @Complemento, @Bairro, @Cidade, @UF, @CEP, 
    @DDD, @Telefone, @Fax, @Endereco_eletronico, @Representante, 
    @Cargo_Representante, @Regiao_de_Comercializacao, @Data_Registro_ANS
)
SET 
    Registro_ANS = NULLIF(@Registro_ANS, ''),
    CNPJ = NULLIF(@CNPJ, ''),
    Razao_Social = NULLIF(@Razao_Social, ''),
    Nome_Fantasia = NULLIF(@Nome_Fantasia, ''),
    Modalidade = NULLIF(@Modalidade, ''),
    Logradouro = NULLIF(@Logradouro, ''),
    Numero = NULLIF(@Numero, ''),
    Complemento = NULLIF(@Complemento, ''),
    Bairro = NULLIF(@Bairro, ''),
    Cidade = NULLIF(@Cidade, ''),
    UF = NULLIF(@UF, ''),
    CEP = NULLIF(@CEP, ''),
    DDD = NULLIF(@DDD, ''),
    Telefone = NULLIF(@Telefone , ''),
    Fax = NULLIF(@Fax, ''),
    Endereco_eletronico = NULLIF(@Endereco_eletronico, ''),
    Representante = NULLIF(@Representante, ''),
    Cargo_Representante = NULLIF(@Cargo_Representante, ''),
    Regiao_de_Comercializacao = NULLIF(@Regiao_de_Comercializacao, ''),
    Data_Registro_ANS = NULLIF(@Data_Registro_ANS, '');



CREATE TABLE contabeis_2023 (
    Data_Cont DATE,
    Registro_ANS BIGINT, 
    CD_Conta_Contabil BIGINT,
    Descricao VARCHAR(255),
    Vl_Saldo_Inicial DECIMAL(16,3),
    Vl_Saldo_Final DECIMAL(16,3),
    Trimestre INT
);

-- Carregando dados do primeiro trimestre
LOAD DATA INFILE 'C:/teste_intuitivecare/teste_3/1T2023.csv'
INTO TABLE contabeis_2023
CHARACTER SET UTF8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
-- Novamente a mesma formatação, mantendo a precaução em caso de dados que estejam em branco.
-- Formatando a data já que ela se apresenta em formatos diferentes dependendo da tabela.
IGNORE 1 ROWS
(@Data_Cont, @Registro_ANS, @CD_Conta_Contabil, @Descricao, @Vl_Saldo_Inicial, @Vl_Saldo_Final, @Trimestre)
SET 
    Data_Cont = CASE
        WHEN @Data_Cont LIKE '__/__/____' THEN STR_TO_DATE(@Data_Cont, '%d/%m/%Y')
        WHEN @Data_Cont LIKE '____-__-__' THEN CAST(@Data_Cont AS DATE)
        ELSE NULL
    END,
    Registro_ANS = NULLIF(@Registro_ANS, ''),
    CD_Conta_Contabil = NULLIF(@CD_Conta_Contabil, ''),
    Descricao = NULLIF(@Descricao, ''),
    Vl_Saldo_Inicial = NULLIF(REPLACE(@Vl_Saldo_Inicial, ',', '.'), ''),
    Vl_Saldo_Final = NULLIF(REPLACE(@Vl_Saldo_Final, ',', '.'), ''),
    Trimestre = 1;

-- Carregando dados do segundo trimestre
LOAD DATA INFILE 'C:/teste_intuitivecare/teste_3/2T2023.csv'
INTO TABLE contabeis_2023
CHARACTER SET UTF8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@Data_Cont, @Registro_ANS, @CD_Conta_Contabil, @Descricao, @Vl_Saldo_Inicial, @Vl_Saldo_Final, @Trimestre)
SET 
    Data_Cont = CASE
        WHEN @Data_Cont LIKE '__/__/____' THEN STR_TO_DATE(@Data_Cont, '%d/%m/%Y')
        WHEN @Data_Cont LIKE '____-__-__' THEN CAST(@Data_Cont AS DATE)
        ELSE NULL
    END, 
    Registro_ANS = NULLIF(@Registro_ANS, ''),
    CD_Conta_Contabil = NULLIF(@CD_Conta_Contabil, ''),
    Descricao = NULLIF(@Descricao, ''),
    Vl_Saldo_Inicial = NULLIF(REPLACE(@Vl_Saldo_Inicial, ',', '.'), ''),
    Vl_Saldo_Final = NULLIF(REPLACE(@Vl_Saldo_Final, ',', '.'), ''),
    Trimestre = 2;

-- Carregando dados do terceiro trimestre
LOAD DATA INFILE 'C:/teste_intuitivecare/teste_3/3T2023.csv'
INTO TABLE contabeis_2023
CHARACTER SET UTF8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@Data_Cont, @Registro_ANS, @CD_Conta_Contabil, @Descricao, @Vl_Saldo_Inicial, @Vl_Saldo_Final, @Trimestre)
SET 
	Data_Cont = CASE
        WHEN @Data_Cont LIKE '__/__/____' THEN STR_TO_DATE(@Data_Cont, '%d/%m/%Y')
        WHEN @Data_Cont LIKE '____-__-__' THEN CAST(@Data_Cont AS DATE)
        ELSE NULL
    END,
    Registro_ANS = NULLIF(@Registro_ANS, ''),
    CD_Conta_Contabil = NULLIF(@CD_Conta_Contabil, ''),
    Descricao = NULLIF(@Descricao, ''),
    Vl_Saldo_Inicial = NULLIF(REPLACE(@Vl_Saldo_Inicial, ',', '.'), ''),
    Vl_Saldo_Final = NULLIF(REPLACE(@Vl_Saldo_Final, ',', '.'), ''),
    Trimestre = 3;

-- Carregando dados do quarto trimestre
LOAD DATA INFILE 'C:/teste_intuitivecare/teste_3/4T2023.csv'
INTO TABLE contabeis_2023
CHARACTER SET UTF8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@Data_Cont, @Registro_ANS, @CD_Conta_Contabil, @Descricao, @Vl_Saldo_Inicial, @Vl_Saldo_Final, @Trimestre)
SET 
    Data_Cont = CASE
        WHEN @Data_Cont LIKE '__/__/____' THEN STR_TO_DATE(@Data_Cont, '%d/%m/%Y')
        WHEN @Data_Cont LIKE '____-__-__' THEN CAST(@Data_Cont AS DATE)
        ELSE NULL
    END,
    Registro_ANS = NULLIF(@Registro_ANS, ''),
    CD_Conta_Contabil = NULLIF(@CD_Conta_Contabil, ''),
    Descricao = NULLIF(@Descricao, ''),
    Vl_Saldo_Inicial = NULLIF(REPLACE(@Vl_Saldo_Inicial, ',', '.'), ''),
    Vl_Saldo_Final = NULLIF(REPLACE(@Vl_Saldo_Final, ',', '.'), ''),
    Trimestre = 4;


CREATE TABLE contabeis_2024 (
    Data_Cont DATE,
    Registro_ANS BIGINT, 
    CD_Conta_Contabil BIGINT,
    Descricao VARCHAR(255),
    Vl_Saldo_Inicial DECIMAL(16,3),
    Vl_Saldo_Final DECIMAL(16,3),
    Trimestre INT
);

-- Carregando dados do primeiro trimestre
LOAD DATA INFILE 'C:/teste_intuitivecare/teste_3/1T2024.csv'
INTO TABLE contabeis_2024
CHARACTER SET UTF8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@Data_Cont, @Registro_ANS, @CD_Conta_Contabil, @Descricao, @Vl_Saldo_Inicial, @Vl_Saldo_Final, @Trimestre)
SET 
    Data_Cont = CASE
        WHEN @Data_Cont LIKE '__/__/____' THEN STR_TO_DATE(@Data_Cont, '%d/%m/%Y')
        WHEN @Data_Cont LIKE '____-__-__' THEN CAST(@Data_Cont AS DATE)
        ELSE NULL
    END,
    Registro_ANS = NULLIF(@Registro_ANS, ''),
    CD_Conta_Contabil = NULLIF(@CD_Conta_Contabil, ''),
    Descricao = NULLIF(@Descricao, ''),
    Vl_Saldo_Inicial = NULLIF(REPLACE(@Vl_Saldo_Inicial, ',', '.'), ''),
    Vl_Saldo_Final = NULLIF(REPLACE(@Vl_Saldo_Final, ',', '.'), ''),
    Trimestre = 1;

-- Carregando dados do segundo trimestre
LOAD DATA INFILE 'C:/teste_intuitivecare/teste_3/2T2024.csv'
INTO TABLE contabeis_2024
CHARACTER SET UTF8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@Data_Cont, @Registro_ANS, @CD_Conta_Contabil, @Descricao, @Vl_Saldo_Inicial, @Vl_Saldo_Final, @Trimestre)
SET 
    Data_Cont = CASE
        WHEN @Data_Cont LIKE '__/__/____' THEN STR_TO_DATE(@Data_Cont, '%d/%m/%Y')
        WHEN @Data_Cont LIKE '____-__-__' THEN CAST(@Data_Cont AS DATE)
        ELSE NULL
    END, 
    Registro_ANS = NULLIF(@Registro_ANS, ''),
    CD_Conta_Contabil = NULLIF(@CD_Conta_Contabil, ''),
    Descricao = NULLIF(@Descricao, ''),
    Vl_Saldo_Inicial = NULLIF(REPLACE(@Vl_Saldo_Inicial, ',', '.'), ''),
    Vl_Saldo_Final = NULLIF(REPLACE(@Vl_Saldo_Final, ',', '.'), ''),
    Trimestre = 2;

-- Carregando dados do terceiro trimestre
LOAD DATA INFILE 'C:/teste_intuitivecare/teste_3/3T2024.csv'
INTO TABLE contabeis_2024
CHARACTER SET UTF8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@Data_Cont, @Registro_ANS, @CD_Conta_Contabil, @Descricao, @Vl_Saldo_Inicial, @Vl_Saldo_Final, @Trimestre)
SET 
	Data_Cont = CASE
        WHEN @Data_Cont LIKE '__/__/____' THEN STR_TO_DATE(@Data_Cont, '%d/%m/%Y')
        WHEN @Data_Cont LIKE '____-__-__' THEN CAST(@Data_Cont AS DATE)
        ELSE NULL
    END,
    Registro_ANS = NULLIF(@Registro_ANS, ''),
    CD_Conta_Contabil = NULLIF(@CD_Conta_Contabil, ''),
    Descricao = NULLIF(@Descricao, ''),
    Vl_Saldo_Inicial = NULLIF(REPLACE(@Vl_Saldo_Inicial, ',', '.'), ''),
    Vl_Saldo_Final = NULLIF(REPLACE(@Vl_Saldo_Final, ',', '.'), ''),
    Trimestre = 3;

-- Carregando dados do quarto trimestre
LOAD DATA INFILE 'C:/teste_intuitivecare/teste_3/4T2024.csv'
INTO TABLE contabeis_2024
CHARACTER SET UTF8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@Data_Cont, @Registro_ANS, @CD_Conta_Contabil, @Descricao, @Vl_Saldo_Inicial, @Vl_Saldo_Final, @Trimestre)
SET 
    Data_Cont = CASE
        WHEN @Data_Cont LIKE '__/__/____' THEN STR_TO_DATE(@Data_Cont, '%d/%m/%Y')
        WHEN @Data_Cont LIKE '____-__-__' THEN CAST(@Data_Cont AS DATE)
        ELSE NULL
    END,
    Registro_ANS = NULLIF(@Registro_ANS, ''),
    CD_Conta_Contabil = NULLIF(@CD_Conta_Contabil, ''),
    Descricao = NULLIF(@Descricao, ''),
    Vl_Saldo_Inicial = NULLIF(REPLACE(@Vl_Saldo_Inicial, ',', '.'), ''),
    Vl_Saldo_Final = NULLIF(REPLACE(@Vl_Saldo_Final, ',', '.'), ''),
    Trimestre = 4;



-- Criando Indexes para melhorar o tempo de consulta
CREATE INDEX idx_contabeis_registro_ans_trimestre ON contabeis_2024 (Registro_ANS, Trimestre);
CREATE INDEX idx_operadoras_registro_ans ON operadoras (Registro_ANS);


-- 3.5-1
SELECT
-- Em alguns dos dados o nome fantasia estava vazio. Daí esta solução para tratar isto
	CASE WHEN op.Nome_Fantasia IS NULL OR op.Nome_Fantasia = ''
	THEN op.Razao_Social
	ELSE op.Nome_Fantasia
END AS Nome_Fantasia,
-- Coalesce para tratar os valores NULLs e não dar erro
SUM(COALESCE(cb.Vl_Saldo_Final, 0) - COALESCE(cb.Vl_Saldo_Inicial, 0)) AS Gasto
FROM     contabeis_2024 AS cb 
INNER JOIN     operadoras AS op 
ON cb.Registro_ANS = op.Registro_ANS
-- No último trimestre
WHERE     LOWER(cb.Descricao)  LIKE '%eventos/sinistros conhecidos%'     
AND cb.Trimestre = 4 
GROUP BY op.Registro_ANS
ORDER BY Gasto DESC LIMIT 10;


-- 3.5-2
SELECT
-- Em alguns dos dados o nome fantasia estava vazio. Daí esta solução para tratar isto
	CASE WHEN op.Nome_Fantasia IS NULL OR op.Nome_Fantasia = ''
	THEN op.Razao_Social
	ELSE op.Nome_Fantasia
END AS Nome_Fantasia,
-- Coalesce para tratar os valores NULLs e não dar erro
SUM(COALESCE(cb.Vl_Saldo_Final, 0) - COALESCE(cb.Vl_Saldo_Inicial, 0)) AS Gasto
FROM     contabeis_2024 AS cb 
INNER JOIN     operadoras AS op 
ON cb.Registro_ANS = op.Registro_ANS
-- No último Ano
WHERE     LOWER(cb.Descricao)  LIKE '%eventos/sinistros conhecidos%'      
GROUP BY op.Registro_ANS
ORDER BY Gasto DESC LIMIT 10;


