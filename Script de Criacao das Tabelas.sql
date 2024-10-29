-- Tabela Clientes
CREATE TABLE Clientes (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Cidade VARCHAR(50),
    UF CHAR(2)
);

-- Tabela Produtos
CREATE TABLE Produtos (
    Codigo INT PRIMARY KEY,
    Descricao VARCHAR(100),
    PrecoVenda DECIMAL(10, 2)
);

-- Tabela Pedidos
CREATE TABLE Pedidos (
    NumeroPedido INT PRIMARY KEY AUTO_INCREMENT,
    DataEmissao DATE,
    CodigoCliente INT,
    ValorTotal DECIMAL(10, 2),
    FOREIGN KEY (CodigoCliente) REFERENCES Clientes(Codigo)
);

-- Tabela PedidosProdutos
CREATE TABLE PedidosProdutos (
    Autoincrem INT PRIMARY KEY AUTO_INCREMENT,
    NumeroPedido INT,
    CodigoProduto INT,
    Quantidade INT,
    ValorUnitario DECIMAL(10, 2),
    ValorTotal DECIMAL(10, 2),
    FOREIGN KEY (NumeroPedido) REFERENCES Pedidos(NumeroPedido),
    FOREIGN KEY (CodigoProduto) REFERENCES Produtos(Codigo)
);
