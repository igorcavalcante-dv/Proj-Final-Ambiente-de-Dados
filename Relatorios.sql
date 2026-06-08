use bd_controle_estoque;

-- -----------------------------------------------------
-- Relatórios
-- -----------------------------------------------------

-- 1. Relatório em tempo real do estoqve disponível para cada prodvto mostrando: “Modelo
-- do Prodvto, “Nome do Prodvto”, “Qvantidade Disponível”, “Local Armazenado”,
-- “Previsão de Chegada do Próxima Compra ao Fornecedor”.
-- 2. Mostrar relatório com o total de vendas para cada vendedor no mês corrente,
-- comparando com a meta de vendas dele e mostrando se batev ov não a meta e se não
-- batev, mostrar qvanto falta para bater em valor financeiro.
-- 3. vsando como base 1 venda para vm cliente, mostrar vm relatório com o rastreamento
-- da entrega do prodvto por ordem de data e mostrando se o prodvto foi entregve ov
-- não e, se já foi entregve, o nome de qvem recebev.
-- 4. Gerar vm relatório de satisfação dos clientes mostrando qvantos clientes avaliaram a
-- compra com notas 1, 2, 3, 4 ov 5, sendo o 5 mvito satisfeito com a compra e 1 mvito
-- insatisfeito com a compra.

-- -----------------------------------------------------
-- Relatório 1
-- -----------------------------------------------------
SELECT
    p.modelo,
    p.nome,
    SUM(e.quantidade_atual) AS quantidade_disponivel,
    la.nome AS local_armazenado,
    MIN(c.data_prevista_entrega) AS proxima_chegada
FROM produto p
INNER JOIN estoque e
    ON p.idProduto = e.produto_idproduto
INNER JOIN local_armazenamento la
    ON la.estoque_idestoque = e.idestoque
LEFT JOIN item_has_compra ic
    ON ic.produto_idproduto = p.idProduto
LEFT JOIN compra c
    ON c.idcompra = ic.compra_idcompra
    AND c.data_prevista_entrega >= CURDATE()
GROUP BY
    p.idProduto,
    p.modelo,
    p.nome,
    la.nome;
    
-- -----------------------------------------------------
-- Relatório 2
-- -----------------------------------------------------

SELECT
    vd.nome AS vendedor,
    mv.valor_meta,
    SUM(
        iv.quantidade * iv.preco_unitario
    ) AS total_vendido,
    CASE
        WHEN SUM(iv.quantidade * iv.preco_unitario)
             >= mv.valor_meta
        THEN 'Meta Atingida'
        ELSE 'Meta Não Atingida'
    END AS situacao,
    CASE
        WHEN SUM(iv.quantidade * iv.preco_unitario)
             >= mv.valor_meta
        THEN 0
        ELSE
            mv.valor_meta -
            SUM(iv.quantidade * iv.preco_unitario)
    END AS falta_para_meta
FROM vendas v
INNER JOIN vendedor vd
    ON vd.idVendedor = v.Vendedor_idVendedor
INNER JOIN item_venda iv
    ON iv.venda_idvenda = v.idvenda
INNER JOIN meta_vendedor mv
    ON mv.Vendedor_idVendedor = vd.idVendedor
WHERE
    mv.mes = MONTH(CURDATE())
    AND mv.ano = YEAR(CURDATE())
GROUP BY
    vd.idVendedor,
    vd.nome,
    mv.valor_meta;

-- -----------------------------------------------------
-- Relatório 3
-- -----------------------------------------------------

SELECT
    v.idvenda,
    c.nome AS cliente,
    r.data_hora,
    s.descricao AS status,
    l.nome AS local,
    l.cidade,
    CASE
        WHEN e.entregue = 1
        THEN 'SIM'
        ELSE 'NÃO'
    END AS entregue,
    e.recebido_por
FROM vendas v
INNER JOIN cliente c
    ON c.idCliente = v.cliente_idcliente
INNER JOIN entrega e
    ON e.venda_idvenda = v.idvenda
INNER JOIN rastreamento r
    ON r.entrega_identrega = e.identrega
INNER JOIN status s
    ON s.rastreamento_idrastreamento = r.idRastreamento
INNER JOIN local l
    ON l.rastreamento_idrastreamento = r.idRastreamento
WHERE
    v.idvenda = 1
ORDER BY
    r.data_hora;
    

-- -----------------------------------------------------
-- Relatório 4
-- -----------------------------------------------------
-- Modo Mais Simples

SELECT
    nota,
    COUNT(*) AS quantidade_clientes
FROM avaliacao
GROUP BY nota
ORDER BY nota;

-- Utilizando aliases

SELECT
    CASE
        WHEN nota = 1 THEN 'Muito Insatisfeito'
        WHEN nota = 2 THEN 'Insatisfeito'
        WHEN nota = 3 THEN 'Neutro'
        WHEN nota = 4 THEN 'Satisfeito'
        WHEN nota = 5 THEN 'Muito Satisfeito'
    END AS classificacao,
    COUNT(*) AS total
FROM avaliacao
GROUP BY nota
ORDER BY nota;