-- =====================================================================
-- QUESTÃO 1
-- Relatório em tempo real do estoque disponível para cada produto
-- Colunas: Modelo, Nome, Quantidade Disponível, Local Armazenado,
--          Previsão de Chegada da Próxima Compra ao Fornecedor
-- =====================================================================
-- SELECT
--    p.modelo                          AS "Modelo do Produto",
--    p.nome                            AS "Nome do Produto",
--    e.quantidade_atual                AS "Quantidade Disponível",
--    la.nome                           AS "Local Armazenado",
--    (
 --       SELECT MIN(c2.data_prevista_entrega)
   --     FROM compra c2
    --    INNER JOIN item_has_compra ihc2
      --      ON c2.idcompra = ihc2.compra_idcompra
  --      WHERE ihc2.produto_idproduto  = p.idProduto
   --       AND c2.data_prevista_entrega > CURDATE()
  --  )                                 AS "Previsão da Próxima Entrega do Fornecedor"
-- FROM estoque e
--  INNER JOIN produto p
 --   ON e.produto_idproduto = p.idProduto
-- LEFT JOIN local_armazenamento la
 --   ON la.estoque_idestoque = e.idestoque
-- ORDER BY
--    p.nome ASC;

-- =====================================================================
-- QUESTÃO 2
-- Relatório de vendas por vendedor no mês corrente
-- Compara total vendido com a meta; indica se bateu e quanto falta
-- =====================================================================

 -- SELECT
  --  v.matricula                                       AS "Matrícula",
    -- v.nome                                            AS "Vendedor",	
    -- COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0)
   --                                                   AS "Total Vendido (R$)",
   -- COALESCE(mv.valor_meta, 0)                        AS "Meta do Mês (R$)",
   -- CASE
     --   WHEN COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0)
       --      >= COALESCE(mv.valor_meta, 0)
     --   THEN 'SIM ✔'
    --    ELSE 'NÃO ✘'
   -- END                                               AS "Bateu a Meta?",
    -- CASE
   --     WHEN COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0)
   --          < COALESCE(mv.valor_meta, 0)
   --     THEN COALESCE(mv.valor_meta, 0)
  --           - COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0)
 --       ELSE 0
--    END                                               AS "Falta para Bater a Meta (R$)"
-- FROM Vendedor v
-- LEFT JOIN vendas ve
 --   ON  v.idVendedor      = ve.Vendedor_idVendedor
 --   AND MONTH(ve.data_venda) = MONTH(CURDATE())
--    AND YEAR(ve.data_venda)  = YEAR(CURDATE())
-- LEFT JOIN item_venda iv
 --   ON ve.idvenda = iv.venda_idvenda
-- LEFT JOIN meta_vendedor mv
   -- ON  v.idVendedor  = mv.Vendedor_idVendedor
   -- AND mv.mes        = MONTH(CURDATE())
  --  AND mv.ano        = YEAR(CURDATE())
-- GROUP BY
 --   v.idVendedor,
 --   v.matricula,
 --   v.nome,
 --   mv.valor_meta
-- ORDER BY
--    `Total Vendido (R$)` DESC;

-- =====================================================================
-- QUESTÃO 3
-- Rastreamento da entrega de uma venda específica
-- Ordena por data/hora; informa se foi entregue e quem recebeu
-- =====================================================================
-- ⚠ Substitua o valor de @id_venda pelo ID real da venda desejada

SET @id_venda = 4;   -- << ALTERE AQUI

SELECT
    ve.idvenda                          AS "ID Venda",
    cl.nome                             AS "Cliente",
    p.nome                              AS "Produto",
    r.data_hora                         AS "Data / Hora Rastreamento",
    lo.nome                             AS "Local",
    lo.cidade                           AS "Cidade",
    lo.uf                               AS "UF",
    st.descricao                        AS "Status",
    CASE
        WHEN en.entregue = 1 THEN 'SIM ✔'
        ELSE 'NÃO - Em trânsito'
    END                                 AS "Entregue?",
    CASE
        WHEN en.entregue = 1 THEN en.recebido_por
        ELSE '---'
    END                                 AS "Recebido Por"
FROM vendas ve
INNER JOIN cliente cl
    ON ve.cliente_idcliente = cl.idCliente
INNER JOIN entrega en
    ON ve.idvenda = en.venda_idvenda
INNER JOIN rastreamento r
    ON en.identrega = r.entrega_identrega
INNER JOIN local lo
    ON r.idRastreamento = lo.rastreamento_idrastreamento
INNER JOIN status st
    ON r.idRastreamento = st.rastreamento_idrastreamento
INNER JOIN item_venda iv
    ON ve.idvenda = iv.venda_idvenda
INNER JOIN produto p
    ON iv.produto_idproduto = p.idProduto
WHERE ve.idvenda = @id_venda
ORDER BY
    r.data_hora ASC;


-- =====================================================================
-- QUESTÃO 4
-- Relatório de satisfação dos clientes
-- Contagem de avaliações por nota (1 = Muito Insatisfeito … 5 = Muito Satisfeito)
-- =====================================================================

SELECT
    a.nota                                    AS "Nota",
    CASE a.nota
        WHEN 1 THEN 'Muito Insatisfeito'
        WHEN 2 THEN 'Insatisfeito'
        WHEN 3 THEN 'Neutro'
        WHEN 4 THEN 'Satisfeito'
        WHEN 5 THEN 'Muito Satisfeito'
    END                                       AS "Classificação",
    COUNT(a.nota)                                  AS "Qtd. de Clientes",
    CONCAT(
        ROUND(COUNT(a.nota) * 100.0
              / (SELECT COUNT(*) FROM avaliacao), 2),
        ' %'
    )                                         AS "Percentual"
FROM avaliacao a
GROUP BY
    a.nota
ORDER BY
    a.nota ASC;