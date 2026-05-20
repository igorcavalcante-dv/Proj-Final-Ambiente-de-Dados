create database bd_controle_estoque;
use bd_controle_estoque;


-- -----------------------------------------------------
-- Modulo 1 - Produtos
-- -----------------------------------------------------

create table produto(
idProduto int not null,
nome varchar(45) not null,
descricao text null,
lucro_percentual decimal(5,2) not null default 0,
unidade_venda varchar(45) not null default 0,
tamanho varchar(45) null,
modelo varchar(45) null,
primary key(idProduto)
);

create table caracteristica(
idCaracteristica int not null,
nome varchar(45) not null,
primary key(idCaracteristica)
);

create table Produto_Has_Caracteristica(
idProdutoCaracteristica int not null auto_increment,
Produto_IdProduto int not null,
Caracteristica_IdCaracteristica int not null,
valor varchar(45) not null,
primary key(idProdutoCaracteristica)
);

-- -----------------------------------------------------
-- Modulo 2 - Preços
-- -----------------------------------------------------

create table Usuario(
idUsuario int not null,
matricula varchar(45) unique not null,
nome varchar(45) not null,
primary key(idUsuario)
);

create table preco(
idPreco int not null,
valor decimal(10,2) not null,
data_inicio date not null,
data_fim date null default("Sem Vencimento"),
Produto_IdProduto int not null,
Usuario_IdUsuario int not null,
primary key(idPreco)
);

-- -----------------------------------------------------
-- Modulo 3 - Fornecedores
-- -----------------------------------------------------

create table fornecedor(
idFornecedor int not null,
nome varchar(45) not null,
cnpj varchar(14) not null,
primary key(idFornecedor)
);

create table produto_has_fornecedor(
idProdutoFornecedor int not null auto_increment,
produto_idproduto int not null,
fornecedor_idfornecedor int not null,
primary key(idProdutoFornecedor)
);

-- -----------------------------------------------------
-- Modulo 4 - Compras e Estoque
-- -----------------------------------------------------

create table compra(
idcompra int not null,
fornecedor_idfornecedor int not null,
data_compra date not null,
data_pagamento date null,
condicao_prevista_pagamento varchar(45) null,
data_prevista_entrega date,
primary key(idcompra)
);

create table item_has_compra(
idItemCompra int not null auto_increment,
compra_idcompra int not null,
produto_idProduto int not null,
quantidade int not null,
valor_negociado decimal(10,2) not null,
primary key(idItemCompra)
);

create table estoque(
idestoque int not null,
Itemcompra_idItemCompra int not null,
quantidade_recebida int not null,
quantidade_atual int not null,
data_validade date null,
numero_lote varchar(45) null,
local_armazenamento varchar(45) null,
primary key(idestoque)
);

-- -----------------------------------------------------
-- Modulo de Apoio - Telefone e Endereço
-- -----------------------------------------------------
create table telefone(
numero varchar(45) not null,
cliente_idcliente int not null,
fornecedor_idfornecedor int not null,
primary key(numero,cliente_idcliente,fornecedor_idfornecedor)
);

create table endereco(
idEndereco int not null,
logradouro varchar(45) not null,
numero varchar(45) null,
complemento varchar(45) null,
bairro varchar(45) null,
cidade varchar(45) null,
uf varchar(2) null,
cep varchar(8),
cliente_idcliente int not null,
fornecedor_idfornecedor int not null,
primary key(idEndereco)
);

-- -----------------------------------------------------
-- Modulo 5 - Clientes
-- -----------------------------------------------------

create table cliente(
idCliente int not null,
nome varchar(45) not null,
cpf varchar(11) not null,
email varchar(100) not null,
primary key(idCliente)
);

create table produto_favorito(
idProdutoFavorito int not null,
cliente_idcliente int not null,
produto_idproduto int not null,
primary key(idProdutoFavorito)
);

-- -----------------------------------------------------
-- Modulo 6 - Vendas
-- -----------------------------------------------------

create table vendas(
idvenda int not null,
cliente_idcliente int not null,
vendedor_idvendedor int not null,
data_venda datetime not null,
primary key(idvenda)
);

create table item_venda(
idItemVenda int not null,
venda_idvenda int not null,
produto_idproduto int not null,
quantidade int not null,
preco_unitario decimal(10,2) not null,
primary key(idItemVenda)
);

-- -----------------------------------------------------
-- Modulo 7 - Entrega e Rastreamento
-- -----------------------------------------------------

create table transportadora(
idtransportadora int not null,
nome varchar(45) not null,
cnpj varchar(14) not null,
primary key(idtransportadora)
);

create table entrega(
identrega int not null,
venda_idvenda int not null,
transportadora_idtransportadora int not null,
endereco_idendereco int not null,
data_envio date null,
meio_transporte varchar(45) null,
previsao_entrega date null,
primary key(identrega)
);

create table rastreamento(
idRastreamento int not null,
status varchar(45) null ,
local varchar(45) not null,
data_hora datetime not null,
entrega_identrega int not null,
primary key(idRastreamento)
);

-- -----------------------------------------------------
-- Modulo 8 - Criação de FK
-- -----------------------------------------------------

create index fk_Produto_Has_Caracteristica_produto_idx on Produto_Has_Caracteristica (Produto_IdProduto asc);

alter table produto_has_caracteristica
add constraint fk_Produto_Has_Caracteristica_produto
	foreign key (produto_idproduto)
    references produto (idproduto)
    on delete no action
    on update no action;

create index fk_produto_has_caracteristica_caracteristica_idx on produto_has_caracteristica (caracteristica_idcaracteristica asc);

alter table produto_has_caracteristica
add constraint fk_Produto_Has_Caracteristica_caracteristica
	foreign key(caracteristica_idcaracteristica)
    references caracteristica (idcaracteristica)
    on delete no action
    on update no action;

create index fk_preco_produto_idx on preco (produto_idproduto asc);

create index fk_preco_usuario_idx on preco (usuario_idusuario asc);

alter table preco
add constraint fk_preco_produto
	foreign key (produto_idproduto)
    references produto (idproduto)
    on delete no action
    on update no action,
add constraint fk_preco_usuario
	foreign key(usuario_idusuario)
    references usuario (idusuario)
    on delete no action
    on update no action;

create index fk_produto_has_fornecedor_produto_idx on produto_has_fornecedor (produto_idproduto asc);

create index fk_produto_has_fornecedor_fornecedor_idx on produto_has_fornecedor (fornecedor_idfornecedor asc);

alter table produto_has_fornecedor
add constraint fk_produto_has_fornecedor_produto
	foreign key(produto_idproduto)
    references produto(idproduto)
	on delete no action
    on update no action,
add constraint fk_produto_has_fornecedor_fornecedor
	foreign key(fornecedor_idfornecedor)
    references fornecedor(idfornecedor)
    on delete no action
    on update no action;

create index fk_compra_fornecedor_idx on compra (fornecedor_idfornecedor asc);

alter table compra
add constraint fk_compra_fornecedor
	foreign key(fornecedor_idfornecedor)
    references fornecedor (idfornecedor)
    on delete no action
    on update no action;

create index fk_item_has_compra_compra_idx on item_has_compra(compra_idcompra asc);

create index fk_item_has_compra_produto_idx on item_has_compra(produto_idproduto asc);

alter table item_has_compra
add constraint fk_item_has_compra_compra
	foreign key(compra_idcompra)
    references compra (idcompra)
    on delete no action
    on update no action,
add constraint fk_item_has_compra_produto
	foreign key(produto_idproduto)
    references produto (idproduto)
    on delete no action
    on update no action;

create index fk_estoque_item_has_compra_idx on estoque(Itemcompra_idItemCompra asc);

alter table estoque
add constraint fk_estoque_item_has_compra
	foreign key(Itemcompra_idItemCompra)
    references item_has_compra (idItemCompra)
    on delete no action
    on update no action;

create index fk_telefone_cliente_idx on telefone (cliente_idcliente asc);

alter table telefone
add constraint fk_telefone_cliente
	foreign key(cliente_idcliente)
    references cliente (idcliente)
    on delete no action
    on update no action;
    
create index fk_telefone_fornecedor_idx on telefone (fornecedor_idfornecedor asc);

alter table telefone
add constraint fk_telefone_fornecedor
	foreign key(fornecedor_idfornecedor)
    references fornecedor (idfornecedor)
    on delete no action
    on update no action;

create index fk_endereco_cliente_idx on endereco (cliente_idcliente asc);

alter table telefone
add constraint fk_endereco_cliente
	foreign key(cliente_idcliente)
    references cliente (idcliente)
    on delete no action
    on update no action;
    
create index fk_endereco_fornecedor_idx on endereco (fornecedor_idfornecedor asc);

alter table telefone
add constraint fk_endereco_fornecedor
	foreign key(fornecedor_idfornecedor)
    references fornecedor (idfornecedor)
    on delete no action
    on update no action;

create index fk_produto_favorito_cliente_idx on produto_favorito(cliente_idcliente asc);
create index fk_produto_favorito_produto_idx on produto_favorito(produto_idproduto asc);

alter table produto_favorito
add constraint fk_produto_favorito_cliente
	foreign key(cliente_idcliente)
    references cliente (idcliente)
    on delete no action
    on update no action,
add constraint fk_produto_favorito_produto
	foreign key(produto_idproduto)
    references produto(idproduto)
    on delete no action
    on update no action;

create index fk_vendas_cliente_idx on vendas (cliente_idcliente asc);

create index fk_vendas_usuario_idx on vendas (vendedor_idvendedor asc);

alter table vendas
add constraint fk_vendas_cliente
	foreign key(cliente_idcliente)
    references cliente (idcliente)
    on delete no action
    on update no action,
add constraint fk_vendas_usuario
	foreign key(vendedor_idvendedor)
	references usuario(idusuario)
    on delete no action
    on update no action;

create index fk_item_venda_venda_idx on item_venda (venda_idvenda asc);
create index fk_item_venda_produto_idx on item_venda (produto_idproduto asc);

alter table item_venda
add constraint fk_item_venda_venda
	foreign key(venda_idvenda)
    references vendas (idvenda)
    on delete no action
    on update no action,
add constraint fk_item_venda_produto
	foreign key(produto_idproduto)
	references produto(idproduto)
    on delete no action
    on update no action;

create index fk_entrega_vendas_idx on entrega(venda_idvenda asc);
create index fk_entrega_transportadora_idx on entrega(transportadora_idtransportadora asc);
create index fk_entrega_endereco_idx on entrega(endereco_idendereco asc);

alter table entrega
add constraint fk_entrega_vendas
	foreign key(venda_idvenda)
    references vendas(idvenda)
    on delete no action
    on update no action,
add constraint fk_entrega_transportadora
	foreign key(transportadora_idtransportadora)
    references transportadora(idtransportadora)
    on delete no action
    on update no action,
add constraint fk_entrega_endereco
	foreign key(endereco_idendereco)
    references endereco (idendereco)
    on delete no action
    on update no action;

create index fk_rastreamento_entrega_idx on rastreamento (entrega_identrega asc);

alter table rastreamento
add constraint fk_rastreamento_entrega
	foreign key(entrega_identrega)
    references entrega(identrega)
    on delete no action
    on update no action;

-- commit;