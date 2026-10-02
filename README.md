# Banco-de-Dados-Fabrica

# db_fabrica

Script SQL (MySQL) que cria e popula o banco de dados de uma fábrica de chocolates, inspirado em *A Fantástica Fábrica de Chocolate*.

## O que o script faz

- Cria o banco `db_fabrica` e suas tabelas.
- Insere dados de exemplo (setores, funcionários, produtos, clientes e pedidos).
- Altera tabelas com `ALTER TABLE` (adicionar, modificar e renomear colunas).

## Tabelas

| Tabela | Descrição |
|---|---|
| `tb_setor` | Setores da fábrica e o pavimento em que ficam |
| `tb_funcionario` | Funcionários, cargo, salário, data de admissão e setor |
| `tb_fornecedor` | Fornecedores e país de origem |
| `tb_ingrediente` | Ingredientes, preço por kg, estoque e fornecedor |
| `produto` | Produtos à venda, categoria, preço e estoque |
| `receita` | Ingredientes (em kg) usados em cada produto |
| `cliente` | Clientes (atacado ou varejo) e cidade |
| `pedido` | Pedidos dos clientes, com data e status |
| `item_pedido` | Produtos, quantidades e preços de cada pedido |

## Conceitos praticados

- `CREATE DATABASE` / `CREATE TABLE`
- Chaves primárias, estrangeiras e chaves compostas
- `NOT NULL`, `DEFAULT` e `CHECK`
- `INSERT`, `ALTER TABLE` (`ADD`, `MODIFY`, `RENAME COLUMN`)
- Relacionamentos 1:N e N:N

## Como usar

Requer MySQL 8.0 ou superior.

```bash
mysql -u seu_usuario -p < diogo_sqp.sql
```

## Autor

Diogo
