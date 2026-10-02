-- ===============================================
-- ATIVIDADE PRÁTICA: FÁBRICA DE CHOCOLATE
-- Banco: db_fabrica
-- Script corrigido para execução no MySQL Workbench
-- ===============================================

DROP DATABASE IF EXISTS db_fabrica;
CREATE DATABASE db_fabrica;
USE db_fabrica;

-- ===============================================
-- 1. PREPARAÇÃO DO AMBIENTE (DDL)
-- ===============================================

CREATE TABLE setor (
    id_setor INT NOT NULL AUTO_INCREMENT,
    nome_setor VARCHAR(50) NOT NULL UNIQUE,
    andar INT,
    PRIMARY KEY (id_setor)
);

CREATE TABLE funcionario (
    id_func INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    salario DECIMAL(10,2) CHECK (salario > 0),
    data_admissao DATE,
    id_setor INT,
    email VARCHAR(100),
    PRIMARY KEY (id_func),
    FOREIGN KEY (id_setor) REFERENCES setor(id_setor)
);

CREATE TABLE fornecedor (
    id_fornecedor INT NOT NULL AUTO_INCREMENT,
    nome_fornecedor VARCHAR(100) NOT NULL,
    pais VARCHAR(50),
    PRIMARY KEY (id_fornecedor)
);

CREATE TABLE ingrediente (
    id_ingrediente INT NOT NULL AUTO_INCREMENT,
    nome_ingrediente VARCHAR(50),
    preco_kg DECIMAL(10,2) CHECK (preco_kg > 0),
    estoque_kg DECIMAL(10,2) DEFAULT 0 CHECK (estoque_kg >= 0),
    id_fornecedor INT,
    situacao_estoque VARCHAR(20) DEFAULT 'Normal',
    PRIMARY KEY (id_ingrediente),
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
);

CREATE TABLE produto (
    id_produto INT NOT NULL AUTO_INCREMENT,
    nome_produto VARCHAR(100),
    categoria VARCHAR(30),
    preco_venda DECIMAL(10,2) CHECK (preco_venda > 0),
    estoque INT DEFAULT 0,
    ativo CHAR(1) DEFAULT 'S',
    PRIMARY KEY (id_produto)
);

CREATE TABLE receita (
    id_produto INT,
    id_ingrediente INT,
    qtd_kg DECIMAL(10,3) NOT NULL,
    PRIMARY KEY (id_produto, id_ingrediente),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
    FOREIGN KEY (id_ingrediente) REFERENCES ingrediente(id_ingrediente)
);

CREATE TABLE cliente (
    id_cliente INT NOT NULL AUTO_INCREMENT,
    nome_cliente VARCHAR(100) NOT NULL,
    cidade VARCHAR(80),
    tipo VARCHAR(20),
    PRIMARY KEY (id_cliente)
);

CREATE TABLE pedido (
    id_pedido INT NOT NULL AUTO_INCREMENT,
    id_cliente INT,
    data_pedido DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pendente',
    PRIMARY KEY (id_pedido),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE item_pedido (
    id_pedido INT,
    id_produto INT,
    quantidade INT CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2),
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- Pergunta: receita e item_pedido usam chave primária composta
-- porque o relacionamento é entre dois elementos que formam a identidade
-- do registro: um produto + ingrediente, ou pedido + produto.

-- ===============================================
-- 1.1. CARGA INICIAL DE DADOS (DML)
-- ===============================================

INSERT INTO setor (nome_setor, andar) VALUES
('Sala do Chocolate', 0),
('Sala de Invenções', 1),
('Sala de Embalagem', 0),
('Sala das Nozes', 2),
('Sala de Televisão', 3);

INSERT INTO funcionario (nome, cargo, salario, data_admissao, id_setor) VALUES
('Willy Wonka', 'Diretor', 25000.00, '2000-01-10', 2),
('Charlie Bucket', 'Aprendiz', 1800.00, '2024-03-01', 2),
('Vovô Joe', 'Supervisor', 4200.00, '2023-06-15', 1),
('Oompa Loompa Lux', 'Operador', 2500.00, '2019-05-20', 1),
('Oompa Loompa Zim', 'Operador', 2600.00, '2020-08-11', 1),
('Oompa Loompa Bip', 'Embalador', 2200.00, '2021-02-03', 3),
('Oompa Loompa Tuk', 'Embalador', 2300.00, '2022-09-14', 3),
('Oompa Loompa Nox', 'Tratador de Esquilos', 2100.00, '2018-11-30', 4),
('Senhora Bucket', 'Embaladora', 2400.00, '2024-01-08', 3),
('Oompa Loompa Kip', 'Operador', 2700.00, '2017-04-22', NULL);

INSERT INTO fornecedor (nome_fornecedor, pais) VALUES
('Cacau Loompalândia', 'Loompalândia'),
('Açúcar Doce Vale', 'Brasil'),
('Laticínios dos Alpes', 'Suíça'),
('Nozes & Cia', 'Turquia'),
('Baunilha Real', 'Madagascar');

INSERT INTO ingrediente (nome_ingrediente, preco_kg, estoque_kg, id_fornecedor) VALUES
('Cacau em pó', 45.00, 500, 1),
('Manteiga de cacau', 80.00, 200, 1),
('Açúcar refinado', 5.50, 1000, 2),
('Leite em pó', 32.00, 300, 3),
('Avelã', 95.00, 80, 4),
('Amendoim', 22.00, 150, 4),
('Caramelo', 28.00, 0, 2);

INSERT INTO produto (nome_produto, categoria, preco_venda, estoque) VALUES
('Barra Wonka ao Leite', 'Barra', 12.90, 500),
('Barra Wonka Amargo 70%', 'Barra', 15.90, 300),
('Bombom de Avelã', 'Bombom', 4.50, 1000),
('Chiclete Três Refeições', 'Guloseima', 29.90, 50),
('Ovo de Páscoa Dourado', 'Sazonal', 89.90, 20),
('Bala Eterna', 'Guloseima', 3.00, 2000),
('Trufa de Caramelo', 'Bombom', 6.50, 0);

INSERT INTO receita (id_produto, id_ingrediente, qtd_kg) VALUES
(1, 1, 0.020), (1, 3, 0.030), (1, 4, 0.040),
(2, 1, 0.050), (2, 2, 0.020), (2, 3, 0.010),
(3, 1, 0.005), (3, 5, 0.008), (3, 4, 0.005),
(5, 1, 0.200), (5, 2, 0.100), (5, 4, 0.100), (5, 5, 0.050),
(7, 1, 0.010), (7, 7, 0.010);

INSERT INTO cliente (nome_cliente, cidade, tipo) VALUES
('Doces da Veruca', 'Londres', 'Atacado'),
('Mercado Gloop', 'Düsseldorf', 'Varejo'),
('Loja Beauregarde', 'Atlanta', 'Varejo'),
('Teavee Distribuidora', 'Denver', 'Atacado'),
('Confeitaria Bucket', 'Londres', 'Varejo');

INSERT INTO pedido (id_cliente, data_pedido, status) VALUES
(1, '2025-03-10', 'Entregue'),
(1, '2025-04-02', 'Entregue'),
(2, '2025-04-15', 'Entregue'),
(3, '2025-05-20', 'Cancelado'),
(4, '2025-06-01', 'Em produção'),
(2, '2025-06-18', 'Pendente'),
(4, '2025-07-07', 'Entregue');

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 100, 12.90), (1, 3, 200, 4.50),
(2, 2, 50, 15.90), (2, 5, 5, 89.90),
(3, 1, 30, 12.90), (3, 6, 100, 3.00),
(4, 4, 10, 29.90),
(5, 3, 300, 4.50), (5, 2, 80, 15.90),
(6, 6, 50, 3.00), (6, 1, 20, 12.90),
(7, 5, 10, 89.90), (7, 1, 150, 12.90);

SELECT COUNT(*) AS total_setores FROM setor;
SELECT COUNT(*) AS total_funcionarios FROM funcionario;
SELECT COUNT(*) AS total_fornecedores FROM fornecedor;
SELECT COUNT(*) AS total_ingredientes FROM ingrediente;
SELECT COUNT(*) AS total_produtos FROM produto;
SELECT COUNT(*) AS total_receitas FROM receita;
SELECT COUNT(*) AS total_clientes FROM cliente;
SELECT COUNT(*) AS total_pedidos FROM pedido;
SELECT COUNT(*) AS total_itens_pedido FROM item_pedido;

-- ===============================================
-- 2. MANUTENÇÃO PÓS-CARGA (ALTER E UPDATE)
-- ===============================================

-- 2.1 Alterações de estrutura
ALTER TABLE funcionario ADD COLUMN email VARCHAR(100);
ALTER TABLE ingrediente ADD COLUMN situacao_estoque VARCHAR(20) DEFAULT 'Normal';
ALTER TABLE produto ADD COLUMN ativo CHAR(1) DEFAULT 'S';
ALTER TABLE cliente MODIFY COLUMN cidade VARCHAR(80);
-- Renomear coluna andar para pavimento, se a estrutura já tiver sido criada com andar
-- ALTER TABLE setor RENAME COLUMN andar TO pavimento;

DESC setor;
DESC funcionario;
DESC ingrediente;
DESC produto;
DESC cliente;

-- 2.2 Atualizações de dados
UPDATE funcionario
SET email = CONCAT(LOWER(REPLACE(nome, ' ', '.')), '@wonka.com')
WHERE email IS NULL;

UPDATE ingrediente
SET situacao_estoque = 'Crítico'
WHERE estoque_kg > 0 AND estoque_kg < 100;

UPDATE ingrediente
SET situacao_estoque = 'Esgotado'
WHERE estoque_kg = 0;

UPDATE funcionario
SET salario = salario * 1.08
WHERE nome LIKE 'Oompa Loompa%' AND data_admissao < '2021-01-01';

UPDATE funcionario
SET cargo = 'Herdeiro', salario = 9500.00
WHERE nome = 'Charlie Bucket';

UPDATE produto
SET preco_venda = preco_venda * 1.10
WHERE id_produto IN (
    SELECT id_produto
    FROM receita
    WHERE id_ingrediente = 5
);

UPDATE produto
SET ativo = 'N'
WHERE estoque = 0;

SELECT nome, salario FROM funcionario WHERE nome = 'Oompa Loompa Kip';
SELECT nome_produto, preco_venda FROM produto WHERE id_produto = 5;

-- ===============================================
-- 3. REMOÇÃO DE DADOS (DELETE) E TESTES DE RESTRIÇÕES
-- ===============================================
SET SQL_SAFE_UPDATES = 0;

-- 13. Teste de chave estrangeira - tentativa de excluir fornecedor usado em ingredientes
-- DELETE FROM fornecedor WHERE id_fornecedor = 1;
-- ERRO: Cannot delete or update a parent row: a foreign key constraint fails

-- 14. Excluir fornecedor que não está em uso
DELETE FROM fornecedor WHERE nome_fornecedor = 'Baunilha Real';

-- 15. Teste de CHECK - produto com preço negativo
-- INSERT INTO produto (nome_produto, categoria, preco_venda, estoque)
-- VALUES ('Chocolate Invisível', 'Barra', -10.00, 100);
-- ERRO: CHECK constraint failed

-- 16. Teste de integridade - tentar excluir pedido com item relacionado
-- DELETE FROM pedido WHERE id_pedido = 1;
-- ERRO: Cannot delete or update a parent row: a foreign key constraint fails

-- 17. Remover pedidos cancelados (primeiro itens, depois pedidos)
DELETE FROM item_pedido
WHERE id_pedido IN (
    SELECT id_pedido FROM pedido WHERE status = 'Cancelado'
);

DELETE FROM pedido WHERE status = 'Cancelado';

-- 18. Excluir ingredientes que não são usados em nenhuma receita
DELETE FROM ingrediente
WHERE id_ingrediente NOT IN (
    SELECT DISTINCT id_ingrediente FROM receita
);

SELECT COUNT(*) AS fornecedores_restantes FROM fornecedor;
SELECT COUNT(*) AS pedidos_restantes FROM pedido;
SELECT COUNT(*) AS ingredientes_restantes FROM ingrediente;

-- ===============================================
-- 4. DESAFIOS DE CONSULTA (SQL AVANÇADO)
-- ===============================================

-- 4.1 Faixa salarial
SELECT f.nome, f.cargo, f.salario
FROM funcionario f
WHERE f.salario BETWEEN 2200.00 AND 2800.00
ORDER BY f.salario DESC;

-- 4.2 Categorias selecionadas
SELECT p.nome_produto, p.categoria, p.preco_venda
FROM produto p
WHERE p.categoria IN ('Bombom', 'Sazonal')
ORDER BY p.preco_venda;

-- 4.3 Busca por texto
SELECT f.nome, f.cargo
FROM funcionario f
WHERE f.nome LIKE '%Bucket%' OR f.cargo LIKE 'Emb%'
ORDER BY f.nome;

-- 4.4 Funcionário perdido
SELECT f.nome, f.cargo, f.id_setor
FROM funcionario f
WHERE f.id_setor IS NULL;

-- 4.5 Clientes internacionais
SELECT c.nome_cliente, c.cidade, c.tipo
FROM cliente c
WHERE c.cidade NOT IN ('Londres')
ORDER BY c.nome_cliente;

-- 4.6 Categorias únicas
SELECT DISTINCT p.categoria
FROM produto p
ORDER BY p.categoria;

-- 4.7 Quem trabalha onde (INNER JOIN)
SELECT f.nome, f.cargo, s.nome_setor
FROM funcionario f
INNER JOIN setor s ON f.id_setor = s.id_setor
ORDER BY s.nome_setor, f.nome;

-- 4.8 Todos os funcionários (LEFT JOIN)
SELECT f.nome, COALESCE(s.nome_setor, 'Sem setor') AS setor
FROM funcionario f
LEFT JOIN setor s ON f.id_setor = s.id_setor
ORDER BY f.nome;

-- 4.9 Setores sem funcionários (RIGHT JOIN)
SELECT s.nome_setor
FROM funcionario f
RIGHT JOIN setor s ON f.id_setor = s.id_setor
WHERE f.id_func IS NULL;

-- 4.10 Nota fiscal
SELECT p.id_pedido AS numero_pedido,
       c.nome_cliente,
       p.data_pedido,
       pr.nome_produto,
       ip.quantidade,
       ip.preco_unitario,
       (ip.quantidade * ip.preco_unitario) AS subtotal
FROM pedido p
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
INNER JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
INNER JOIN produto pr ON ip.id_produto = pr.id_produto
WHERE p.status = 'Entregue'
ORDER BY p.data_pedido, pr.nome_produto;

-- 4.11 Receita do Ovo Dourado
SELECT i.nome_ingrediente,
       fo.nome_fornecedor,
       r.qtd_kg,
       i.preco_kg,
       (r.qtd_kg * i.preco_kg) AS custo_por_unidade
FROM receita r
INNER JOIN ingrediente i ON r.id_ingrediente = i.id_ingrediente
INNER JOIN fornecedor fo ON i.id_fornecedor = fo.id_fornecedor
WHERE r.id_produto = 5
ORDER BY custo_por_unidade DESC;

-- 4.12 Folha por setor
SELECT s.nome_setor,
       COUNT(f.id_func) AS quantidade_funcionarios,
       SUM(f.salario) AS soma_salarios,
       ROUND(AVG(f.salario), 2) AS media_salarios,
       MAX(f.salario) AS maior_salario,
       MIN(f.salario) AS menor_salario
FROM setor s
LEFT JOIN funcionario f ON s.id_setor = f.id_setor
GROUP BY s.id_setor, s.nome_setor
HAVING COUNT(f.id_func) >= 2
ORDER BY media_salarios DESC;

-- 4.13 Ranking de clientes
SELECT c.nome_cliente,
       COUNT(DISTINCT p.id_pedido) AS quantidade_pedidos,
       COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0) AS valor_total
FROM cliente c
LEFT JOIN pedido p ON c.id_cliente = p.id_cliente
LEFT JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY c.id_cliente, c.nome_cliente
ORDER BY valor_total DESC;

-- 4.14 Campeões de venda
SELECT pr.nome_produto,
       SUM(ip.quantidade) AS quantidade_total_vendida
FROM produto pr
INNER JOIN item_pedido ip ON pr.id_produto = ip.id_produto
GROUP BY pr.id_produto, pr.nome_produto
HAVING SUM(ip.quantidade) > 100
ORDER BY quantidade_total_vendida DESC;

-- 4.15 Faturamento por categoria
SELECT pr.categoria,
       SUM(ip.quantidade * ip.preco_unitario) AS total_faturado
FROM produto pr
INNER JOIN item_pedido ip ON pr.id_produto = ip.id_produto
GROUP BY pr.categoria
ORDER BY total_faturado DESC;

-- 4.16 Faturamento por mês
SELECT MONTH(p.data_pedido) AS mes,
       COUNT(DISTINCT p.id_pedido) AS quantidade_pedidos,
       SUM(ip.quantidade * ip.preco_unitario) AS faturamento
FROM pedido p
INNER JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY MONTH(p.data_pedido)
ORDER BY mes;

-- 4.17 Compradores do Ovo Dourado (IN)
SELECT DISTINCT c.nome_cliente, c.cidade
FROM cliente c
WHERE c.id_cliente IN (
    SELECT p.id_cliente
    FROM pedido p
    INNER JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
    WHERE ip.id_produto = 5
);

-- 4.18 Encalhados (NOT IN)
SELECT pr.nome_produto, pr.estoque
FROM produto pr
WHERE pr.id_produto NOT IN (
    SELECT DISTINCT ip.id_produto FROM item_pedido ip
);

-- 4.19 Sem chocolate (NOT IN)
SELECT pr.nome_produto, pr.categoria
FROM produto pr
WHERE pr.id_produto NOT IN (
    SELECT r.id_produto
    FROM receita r
    WHERE r.id_ingrediente IN (
        SELECT i.id_ingrediente
        FROM ingrediente i
        WHERE i.id_fornecedor = 1
    )
);

-- 4.20 Acima da média
SELECT f.nome, f.salario
FROM funcionario f
WHERE f.salario > (
    SELECT AVG(salario) FROM funcionario
)
ORDER BY f.salario DESC;

-- 4.21 Maior que todos (ALL)
SELECT f.nome, f.salario
FROM funcionario f
WHERE f.salario > ALL (
    SELECT f2.salario
    FROM funcionario f2
    WHERE f2.id_setor = 3
);

-- 4.22 Menor que algum (ANY)
-- < ANY equivale a comparar com o maior valor da subconsulta
SELECT pr.nome_produto, pr.categoria, pr.preco_venda
FROM produto pr
WHERE pr.categoria != 'Bombom'
  AND pr.preco_venda < ANY (
      SELECT p2.preco_venda
      FROM produto p2
      WHERE p2.categoria = 'Bombom'
  )
ORDER BY pr.preco_venda;

-- 4.23 Fornecedores da Páscoa (EXISTS)
SELECT fo.nome_fornecedor, fo.pais
FROM fornecedor fo
WHERE EXISTS (
    SELECT 1
    FROM ingrediente i
    WHERE i.id_fornecedor = fo.id_fornecedor
      AND EXISTS (
          SELECT 1
          FROM receita r
          INNER JOIN produto pr ON r.id_produto = pr.id_produto
          WHERE r.id_ingrediente = i.id_ingrediente
            AND pr.categoria = 'Sazonal'
      )
);

-- 4.24 Clientes sem compras (NOT EXISTS)
SELECT c.nome_cliente
FROM cliente c
WHERE NOT EXISTS (
    SELECT 1 FROM pedido p WHERE p.id_cliente = c.id_cliente
);

-- 4.25 Margem de lucro
SELECT pr.nome_produto,
       ROUND(SUM(r.qtd_kg * i.preco_kg), 2) AS custo_producao,
       ROUND(pr.preco_venda - SUM(r.qtd_kg * i.preco_kg), 2) AS margem_reais,
       ROUND(((pr.preco_venda - SUM(r.qtd_kg * i.preco_kg)) / pr.preco_venda) * 100, 2) AS margem_percentual
FROM produto pr
INNER JOIN receita r ON pr.id_produto = r.id_produto
INNER JOIN ingrediente i ON r.id_ingrediente = i.id_ingrediente
GROUP BY pr.id_produto, pr.nome_produto, pr.preco_venda
ORDER BY margem_percentual DESC;

-- 4.26 Cliente campeão (HAVING com ALL)
SELECT c.nome_cliente,
       SUM(ip.quantidade * ip.preco_unitario) AS total_comprado
FROM cliente c
INNER JOIN pedido p ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY c.id_cliente, c.nome_cliente
HAVING SUM(ip.quantidade * ip.preco_unitario) >= ALL (
    SELECT SUM(ip2.quantidade * ip2.preco_unitario)
    FROM pedido p2
    INNER JOIN item_pedido ip2 ON p2.id_pedido = ip2.id_pedido
    GROUP BY p2.id_cliente
);

-- 4.27 Alerta de produção
SELECT i.nome_ingrediente,
       i.estoque_kg,
       i.situacao_estoque,
       COUNT(DISTINCT r.id_produto) AS quantidade_produtos_usados
FROM ingrediente i
LEFT JOIN receita r ON i.id_ingrediente = r.id_ingrediente
WHERE i.situacao_estoque IN ('Crítico', 'Esgotado')
GROUP BY i.id_ingrediente, i.nome_ingrediente, i.estoque_kg, i.situacao_estoque
ORDER BY i.situacao_estoque DESC, i.estoque_kg;

-- ===============================================
-- FIM DO SCRIPT
-- ===============================================
