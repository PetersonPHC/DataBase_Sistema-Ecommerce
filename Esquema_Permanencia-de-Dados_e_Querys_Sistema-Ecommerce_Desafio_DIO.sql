-- CRIANDO O BANCO DE DADOS E SUAS RESPECTIVAS TABELAS
CREATE DATABASE Desafio_DIO_SistemaEcommerce;
USE Desafio_DIO_SistemaEcommerce;

CREATE TABLE Pessoa_Fisica (
	CPF CHAR (11) PRIMARY KEY NOT NULL,
    PrimeiroNome VARCHAR(10) NOT NULL,
    NomeDoMeio VARCHAR(20) NOT NULL,
    UltimoNome VARCHAR(10) NOT NULL,
    Idade INT NOT NULL,
    Logradouro VARCHAR(50)
    
);

CREATE TABLE Pessoa_Juridica (
    CNPJ CHAR(14) PRIMARY KEY NOT NULL,
    Nome VARCHAR(30) NOT NULL,
    Logradouro VARCHAR(50)

);

CREATE TABLE Cliente (
    Id_Cliente INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Identificacao VARCHAR(45),
    CPF CHAR(11) DEFAULT NULL,
    CNPJ CHAR(14) DEFAULT NULL,
    Logradouro VARCHAR(50) UNIQUE,
    
    CONSTRAINT fk_cliente_PFisica FOREIGN KEY (CPF) REFERENCES Pessoa_Fisica (CPF),
    CONSTRAINT fk_cliente_PJuridica FOREIGN KEY (CNPJ) REFERENCES Pessoa_Juridica (CNPJ)
);

CREATE TABLE Fornecedor (
    Id_Fornecedor INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    RazaoSocial VARCHAR(45),
    CNPJ CHAR(14)
    
);

CREATE TABLE Estoque (
    Id_Estoque INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Logradouro VARCHAR(45)
    
);

CREATE TABLE Produto (
    Id_Produto INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_Estoque INT,
    Categoria VARCHAR(45),
    Descricao VARCHAR(45),
    Valor DECIMAL UNIQUE,
    CONSTRAINT fk_prod_estoque FOREIGN KEY (Id_Estoque) REFERENCES Estoque (Id_Estoque)
    
);


CREATE TABLE Disponibiliza_Produto (
    Id_Fornecedor INT NOT NULL,
    Id_Produto INT NOT NULL,
    PRIMARY KEY (Id_Produto , Id_Fornecedor),
    CONSTRAINT fk_dispProduto_fornecedor FOREIGN KEY (Id_Fornecedor) REFERENCES Fornecedor (Id_Fornecedor),
    CONSTRAINT fk_dispProduto_Produto FOREIGN KEY (Id_Produto) REFERENCES Produto (Id_Produto)
    
);

CREATE TABLE Quantidade_em_estoque (
    Id_Produto INT,
    Id_Estoque INT,
    CONSTRAINT pk_Qtd_estoque PRIMARY KEY (Id_Produto , Id_Estoque),
    Quantidade INT,
    CONSTRAINT fk_QtdEstoque_idEstoq FOREIGN KEY (Id_Estoque) REFERENCES Estoque (Id_Estoque),
    CONSTRAINT fk_QtdEstoque_idProd FOREIGN KEY (Id_Produto) REFERENCES Produto (Id_Produto)
    
);

CREATE TABLE Entrega (
    Logradouro varchar(50),
    Id_Produto INT,
    Rastreio CHAR(15) UNIQUE,
    ValorFrete DOUBLE UNIQUE,
    CONSTRAINT pk_Entrega PRIMARY KEY (Logradouro , Id_Produto),
    CONSTRAINT fk_Entrega_IdCliente FOREIGN KEY (Logradouro) REFERENCES Cliente(Logradouro),
    CONSTRAINT fk_Entrega_Id_Produto FOREIGN KEY (Id_Produto) REFERENCES Produto (Id_Produto)
);

CREATE TABLE Pagamento (
	NumeroTransacao INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    FormaPagamento VARCHAR(20) NOT NULL,
    Id_Cliente INT NOT NULL,
    Parcelas INT DEFAULT NULL,
    Desconto DOUBLE DEFAULT NULL,
    CONSTRAINT fk_Pag_idCliente FOREIGN KEY (Id_Cliente) REFERENCES Cliente (Id_Cliente)
    
);

CREATE TABLE Vendedor (
    Id_VendedorTerceirizado INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    RazaoSocial VARCHAR(45),
    Logradouro VARCHAR(45)
    
);

CREATE TABLE Produtos_por_Vendedor (
    Id_Produto INT,
    Id_VendedorTerceirizado INT,
    CONSTRAINT pk_Prod_por_Vendedor PRIMARY KEY (Id_Produto , Id_VendedorTerceirizado),
    CONSTRAINT fk_Prod_por_vendedor_IdProd FOREIGN KEY (Id_Produto) REFERENCES Produto (Id_Produto),
    CONSTRAINT fk_Prod_por_vendedor_Vendedor FOREIGN KEY (Id_VendedorTerceirizado) REFERENCES Vendedor (Id_VendedorTerceirizado)
);
drop table Pedido;
CREATE TABLE Pedido (
    Id_Pedido INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Id_Cliente INT,
    FormaPagamento VARCHAR(20) NOT NULL,
    Rastreio CHAR(15),
    ValorFrete DOUBLE,
    ValorProduto DECIMAL,
    CodigoDeRastreio CHAR(15),
    StatusPedido VARCHAR(10),
    Descricao VARCHAR(30),
    
    CONSTRAINT fk_Pedido_IdCliente FOREIGN KEY (Id_Cliente) REFERENCES Cliente (Id_Cliente),
    CONSTRAINT fk_valorFrete FOREIGN KEY (ValorFrete) REFERENCES Entrega (ValorFrete),
    CONSTRAINT fk_valorProduto FOREIGN KEY (ValorProduto) REFERENCES Produto (Valor),
	CONSTRAINT fk_CodRastreio FOREIGN KEY (Rastreio) REFERENCES Entrega (Rastreio)
);

-- INSERINDO DADOS NAS TABELAS CRIADAS
-- Table Pessoa Fisica
INSERT INTO Pessoa_Fisica VALUES (12345678910, 'Peter', 'B','Parker',22 ,'Avenida Palacio'),
								 (10987654321, 'Robert', 'J','Morgan',22 ,'Avenida Brigadeiro'),
								 (15467892345, 'Ana', 'Y','Maria',22 ,'Jd Das Rosas'),
								 (11122233344, 'Alissa', 'G','Junior',22 ,'Rua Jardins Floridos'),
								 (19879871802, 'Carina', 'P','Santos',22 ,'Avenida Qualquer');
SELECT * FROM Pessoa_Fisica;

-- Table Pessoa Juridica
INSERT INTO Pessoa_Juridica VALUES ( 08007897897891, 'Empresa 1', 'Rua 1 de Janeiro'),
							(08001234567890, 'Empresa Ficticia 2', 'Rua 25 de Março'),
								  (08007779995544, 'EmpregaBem', 'Rua 43 de Outubro'),
						  (08004242567492, 'NomeFicticios.com', 'Rua 5 de Fevereiro'),
							(08005648721325, '5° Empresa Ficticia', 'Rua 7 de Abril');
SELECT * FROM Pessoa_Juridica;

-- Table Cliente
insert into Cliente (Identificacao, CPF, Logradouro) VALUES ('Cliente que compra em atacado', 12345678910, 'Avenida Palacio'),
													   ('Cliente Que Faz Grandes Pedidos', 10987654321, 'Avenida Brigadeiro'),
														('Cliente Que Compra No Varejo', 11122233344, 'Rua Jardins Floridos');

insert into Cliente (Identificacao, CNPJ, Logradouro) VALUES ('Cliente Premium', 08001234567890, 'Rua 25 de Março'),
																('Cliente Master',08005648721325, 'Rua 7 de Abril'),
													 ('Cliente Premium Plus', 08004242567492, 'Rua 5 de Fevereiro');
SELECT * FROM Cliente;

-- Table Fornecedor
INSERT INTO Fornecedor (RazaoSocial, CNPJ) VALUES ('Fornecedor A', '99945678901234'),
												  ('Fornecedor B', '99989012345678'),
												  ('Fornecedor C', '99923456789012'),
												  ('Fornecedor D', '99967890123456'),
												  ('Fornecedor E', '99901234567890');
SELECT * FROM Fornecedor;

-- Table Estoque
INSERT INTO Estoque (Logradouro) VALUES ('Rua A, 123'),
									('Avenida B, 456'),
								   ('Travessa C, 789'),
										('Rua D, 321'),
									('Avenida E, 654');
SELECT * FROM Estoque;

-- Table Produto
INSERT INTO Produto (Categoria, Descricao, Valor, Id_Estoque) VALUES ('Eletrônicos', 'Smartphone', 799.99, 1),
																			 ('Roupas', 'Camiseta', 29.99, 2),
																			  ('Livros', 'Romance', 15.50, 3),
																	  ('Eletrônicos', 'Notebook', 1299.99, 4),
																	('Acessórios', 'Óculos de Sol', 49.99, 5);
SELECT * FROM Produto;

-- Table Disponibiliza_Produto
INSERT INTO Disponibiliza_Produto (Id_Fornecedor, Id_Produto) VALUES (1, 5),
																	 (2, 3),
																	 (3, 1),
																	 (4, 2),
																	 (5, 4);
SELECT * FROM Disponibiliza_Produto;

-- Table Quantidade_em_estoque
INSERT INTO Quantidade_em_estoque (Id_Produto, Id_Estoque, Quantidade) VALUES (1, 1, 100),
																			   (2, 2, 50),
																	   		   (3, 3, 75),
																			   (4, 4, 30),
																		  	   (5, 5, 40);
SELECT * FROM Quantidade_em_estoque;

-- Table Entrega
INSERT INTO Entrega (Logradouro, Id_Produto, Rastreio, ValorFrete) VALUES ('Rua Jardins Floridos', 1, 'ABC123', 15.99),
																			('Avenida Brigadeiro', 2, 'DEF456', 10.50),
																				 ('Rua 7 de Abril', 3, 'GHI789', 8.75),
																			   ('Rua 25 de Março', 4, 'JKL321', 20.00),
																			('Rua 5 de Fevereiro', 5, 'MNO654', 12.99);
SELECT * FROM Entrega;

-- Table Pagamento
INSERT INTO Pagamento (FormaPagamento, Id_Cliente, Parcelas, Desconto) VALUES ('Cartão de Crédito', 1, 3, 5.00),
																				('Boleto Bancário', 2, 1, NULL),
																			  ('Cartão de Crédito', 3, 5, Null),
																			   ('Cartão de Débito', 4, 2, 2.50),
																						 ('Pix', 5, NULL, 7.00);
SELECT * FROM Pagamento;

-- Table Vendedor
INSERT INTO Vendedor (CNPJ, RazaoSocial, Logradouro) VALUES ('12345678901234', 'Vendedor A', 'Rua X, 789'),
														('56789012345678', 'Vendedor B', 'Avenida Y, 456'),
													   ('90123456789012', 'Vendedor C', 'Travessa Z, 123'),
															('34567890123456', 'Vendedor D', 'Rua W, 987'),
														('78901234567890', 'Vendedor E', 'Avenida V, 654');
SELECT * FROM Vendedor;

-- Table Produtos_por_Vendedor
INSERT INTO Produtos_por_Vendedor (Id_Produto, Id_VendedorTerceirizado) VALUES (5, 1),
																			   (4, 2),
																			   (2, 3),
																			   (1, 4),
																			   (3, 5);
SELECT * FROM Produtos_por_Vendedor;

-- Table Pedido
INSERT INTO Pedido (Id_Cliente, FormaPagamento, ValorFrete, ValorProduto, CodigoDeRastreio, StatusPedido, Descricao)
	VALUES
		(1, 'Cartão de Crédito', 15.99, 799.99, 'ABC123', 'A Caminho', 'Pedido de smartphone'),
		(2, 'Boleto Bancário', 10.50, 29.99, 'DEF456', 'Concluído', 'Pedido de camiseta'),
		(3, 'Cartão de Crédito', 8.75, 15.50, 'GHI789', 'Cancelado', 'Pedido de romance'),
		(4, 'Cartão de Débito', 20.00, 1299.99, 'JKL321', 'Concluído', 'Pedido de notebook'),
		(5, 'Pix', 12.99, 49.99, 'MNO654', 'Enviado', 'Pedido de óculos de sol');
SELECT * FROM Pedido;

-- QUERYS SEGUINDO AS SOLICITAÇÕES PROPOSTAS PELO DESAFIO

-- Recuperações simples com SELECT Statement
SELECT FormaPagamento, StatusPedido, CodigoDeRastreio FROM Pedido;

-- Filtros com WHERE Statement
SELECT * FROM Pagamento WHERE FormaPagamento = 'Cartão de Crédito';

-- Crie expressões para gerar atributos derivados
SELECT 
    P.Id_Pedido,
    P.Id_Cliente,
    SUM(E.ValorFrete + P.ValorProduto) AS Valor_Total_Pedido,
    PG.Desconto AS Desconto_Aplicado
FROM
    Pedido P
        JOIN
    Entrega E ON P.ValorFrete = E.ValorFrete
        JOIN
    Pagamento PG USING (Id_Cliente);

-- Defina ordenações dos dados com ORDER BY
SELECT DISTINCT
	C.CPF, C.Identificacao, PF.PrimeiroNome
FROM 
	Cliente as C, Pessoa_Fisica as PF
WHERE
	C.CPF = PF.CPF
ORDER BY
	PF.PrimeiroNome DESC;
    
-- Condições de filtros aos grupos – HAVING Statement
SELECT
	CASE
		WHEN CPF IS NOT NULL THEN 'CPF'
        ELSE 'CNPJ'
        END AS TipoDocumento,
	COUNT(*) AS Quantidade
FROM Cliente
	GROUP BY TipoDocumento
	HAVING COUNT(*) > 2;

-- Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
SELECT
	CONCAT(PrimeiroNome, NomeDoMeio, UltimoNome) as Nome,
    C.Identificacao, P.FormaPagamento,
    P.ValorProduto, V.RazaoSocial as Nome_Vendedor,
    PG.Desconto, PG.Parcelas
FROM
	Pessoa_Fisica PF
		JOIN Cliente C USING(CPF)
		JOIN Pedido P USING(Id_Cliente)
		JOIN Vendedor V ON V.Id_VendedorTerceirizado = P.Id_Pedido
        LEFT OUTER JOIN Pagamento PG USING (Id_Cliente)
ORDER BY Nome ASC;
-- A Query Acima Mostra o nome do Cliente, sua identificação, a Forma de Pagamento, O Valor do Produto, Quem Vendeu o Produto, Qual Foi o Desconto(Se Houver) e o número de Parcelas(se Houver).