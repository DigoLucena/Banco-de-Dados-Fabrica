CREATE database db_fabrica;
use db_fabrica;

create table tb_setor
(
id_setor int not null auto_increment primary key, 
nome_setor varchar(100)
);

create table tb_funcionario(
id_func int not null auto_increment primary key,
nome VARCHAR(100),
cargo VARCHAR(50),
salario DECIMAL(10,2) check(salario > 0),
data_admissao DATE,
id_setor INT,
foreign key (id_setor) references tb_setor(id_setor)
);

create table tb_fornecedor(
id_fornecedor int auto_increment ,
nome_fornecedor VARCHAR(100) not null,
pais VARCHAR (50),
primary key (id_fornecedor)
);

CREATE TABLE tb_ingrediente (
    id_ingrediente INT NOT NULL AUTO_INCREMENT,
    nome_ingrediente VARCHAR(50),
    preco_kg DECIMAL(10,2),
    estoque_kg DECIMAL(10,2) DEFAULT 0,
    id_fornecedor INT,
    PRIMARY KEY (id_ingrediente),
    CHECK (preco_kg > 0),
    CHECK (estoque_kg >= 0),
    FOREIGN KEY (id_fornecedor)
        REFERENCES tb_fornecedor(id_fornecedor)
);


create table produto (
   id_produto  INT NOT NULL AUTO_INCREMENT,
   nome_produto VARCHAR(100), 
   categoria VARCHAR(30), 
   preco_venda DECIMAL(10,2), 
   primary key(id_produto),
   check (preco_venda >0),
   estoque INT DEFAULT 0
);

drop table produto;
CREATE TABLE produto (
    id_produto INT NOT NULL AUTO_INCREMENT,
    nome_produto VARCHAR(100),
    categoria VARCHAR(30),
    preco_venda DECIMAL(10,2),
    PRIMARY KEY (id_produto),
    CHECK (preco_venda > 0),
    estoque INT DEFAULT 0
);
create table receita(
id_produto int,
id_ingrediente int,
qtd_kg DECIMAL(10,3),
primary key (id_produto,  id_ingrediente),
foreign key (id_produto) references tb_produto(id_produto),
foreign key (id_ingrediente) references tb_ingrediente (id_ingrediente)
);

drop table receita;
CREATE TABLE receita (
    id_produto INT,
    id_ingrediente INT,
    qtd_kg DECIMAL(10,3),

    PRIMARY KEY (id_produto, id_ingrediente),

    FOREIGN KEY (id_produto) 
        REFERENCES produto(id_produto),

    FOREIGN KEY (id_ingrediente) 
        REFERENCES tb_ingrediente(id_ingrediente)
);

CREATE TABLE cliente (
    id_cliente INT NOT NULL AUTO_INCREMENT,
    nome_cliente VARCHAR(100) NOT NULL,
    cidade VARCHAR(50),
    tipo VARCHAR(20),

    PRIMARY KEY (id_cliente)
);

CREATE TABLE pedido (
    id_pedido INT NOT NULL AUTO_INCREMENT,
    id_cliente INT,
    data_pedido DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pendente',

    PRIMARY KEY (id_pedido),

    FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);

CREATE TABLE item_pedido (
    id_pedido INT,
    id_produto INT,
    quantidade INT,
    preco_unitario DECIMAL(10,2),

    PRIMARY KEY (id_pedido, id_produto),

    CHECK (quantidade > 0),

    FOREIGN KEY (id_pedido)
        REFERENCES pedido(id_pedido),

    FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto)
);

ALTER TABLE tb_setor ADD COLUMN andar INT;

insert into tb_setor(nome_setor, andar)  values
('Sala do Chocolate', 0), -- 1
('Sala de Invenções', 1), -- 2
('Sala de Embalagem', 0), -- 3
('Sala das Nozes', 2), -- 4
('Sala de Televisão', 3); -- 5

insert into tb_funcionario (nome, cargo, salario, data_admissao, id_setor) values
('Willy Wonka', 'Diretor', 25000.00, '2000-01-10', 2),
('Charlie Bucket', 'Aprendiz', 1800.00, '2024-03-01', 2),
('Vovô Joe', 'Supervisor', 4200.00, '2023-06-15', 1),
('Oompa Loompa Lux', 'Operador', 2500.00, '2019-05-20', 1),
('Oompa Loompa Zim', 'Operador', 2600.00, '2020-08-11', 1),
('Oompa Loompa Bip', 'Embalador', 2200.00, '2021-02-03', 3),
('Oompa Loompa Tuk', 'Embalador', 2300.00, '2022-09-14', 3),
('Oompa Loompa Nox', 'Tratador de Esquilos', 2100.00, '2018-11-30', 4),
('Senhora Bucket', 'Embaladora', 2400.00, '2024-01-08', 3),
('Oompa Loompa Kip', 'Operador', 2700.00, '2017-04-22', NULL); -- ainda sem setor

insert into tb_fornecedor (nome_fornecedor, pais) values
('Cacau Loompalândia', 'Loompalândia'), -- 1
('Açúcar Doce Vale', 'Brasil'), -- 2
('Laticínios dos Alpes', 'Suíça'), -- 3
('Nozes & Cia', 'Turquia'), -- 4
('Baunilha Real', 'Madagascar'); -- 5

insert into produto (nome_produto, categoria, preco_venda, estoque) values
('Barra Wonka ao Leite', 'Barra', 12.90, 500), -- 1
('Barra Wonka Amargo 70%', 'Barra', 15.90, 300), -- 2
('Bombom de Avelã', 'Bombom', 4.50, 1000), -- 3
('Chiclete Três Refeições', 'Guloseima', 29.90, 50), -- 4
('Ovo de Páscoa Dourado', 'Sazonal', 89.90, 20), -- 5
('Bala Eterna', 'Guloseima', 3.00, 2000), -- 6
('Trufa de Caramelo', 'Bombom', 6.50, 0); -- 7

insert into receita (nome_ingrediente, preco_kg, estoque_kg, id_fornecedor) values
(1, 1, 0.020), (1, 3, 0.030), (1, 4, 0.040), -- Barra ao Leite
(2, 1, 0.050), (2, 2, 0.020), (2, 3, 0.010), -- Barra Amargo
(3, 1, 0.005), (3, 5, 0.008), (3, 4, 0.005), -- Bombom de Avelã
(5, 1, 0.200), (5, 2, 0.100), (5, 4, 0.100), (5, 5, 0.050), -- Ovo Dourado
(7, 1, 0.010), (7, 7, 0.010); -- Trufa de Caramelo

insert into cliente (nome_cliente, cidade, tipo) values
('Doces da Veruca', 'Londres', 'Atacado'), -- 1
('Mercado Gloop', 'Düsseldorf', 'Varejo'), -- 2
('Loja Beauregarde', 'Atlanta', 'Varejo'), -- 3
('Teavee Distribuidora', 'Denver', 'Atacado'), -- 4
('Confeitaria Bucket', 'Londres', 'Varejo'); -- 5

insert into pedido (id_cliente, data_pedido,status_do_pedido) values
(1, '2025-03-10', 'Entregue'), -- 1
(1, '2025-04-02', 'Entregue'), -- 2
(2, '2025-04-15', 'Entregue'), -- 3
(3, '2025-05-20', 'Cancelado'), -- 4
(4, '2025-06-01', 'Em produção'), -- 5
(2, '2025-06-18', 'Pendente'), -- 6
(4, '2025-07-07', 'Entregue'); -- 7

insert into item_pedido (id_pedido, id_produto, quantidade, preco_unitario) values
(1, 1, 100, 12.90), (1, 3, 200, 4.50),
(2, 2, 50, 15.90), (2, 5, 5, 89.90),
(3, 1, 30, 12.90), (3, 6, 100, 3.00),
(4, 4, 10, 29.90),
(5, 3, 300, 4.50), (5, 2, 80, 15.90),
(6, 6, 50, 3.00), (6, 1, 20, 12.90),
(7, 5, 10, 89.90), (7, 1, 150, 12.90);

alter table tb_funcionario 
ADD COLUMN email VARCHAR(100);

ALTER TABLE tb_ingrediente 
ADD COLUMN situacao_estoque VARCHAR(20) DEFAULT 'Normal';

ALTER TABLE produto 
ADD COLUMN ativo CHAR(1) DEFAULT 'S';

ALTER TABLE cliente 
MODIFY COLUMN cidade VARCHAR(80);

ALTER TABLE tb_setor 
RENAME COLUMN andar TO pavimento;


