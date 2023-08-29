-- criação de bando de dados para o cenário de E-commerce.
create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(255),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(255),
    type_client enum ('PF','PJ'),
    constraint unique_cpf_cliente unique (CPF)
);
alter table clients
modify Address varchar(255);

-- criar tabela produto
create table product(
	idProduct int auto_increment primary key, 
    Pname varchar(100) not null,
    Classification_kids bool default False, 
    Category enum('Eletronico', 'Vestimenta', 'Brinquedos', 'Alimentos','Móveis') not null,
    Avaliação float default 0,
    size varchar(10)
);

create table payment_type(
	idPayment int auto_increment primary key,
    typePayment varchar(100),
	constraint unique_payment unique(typePayment)
);


create table pagaments(
	idClient int,
    idPayment int, 
    limitAvailable float,
    primary key(idClient, idPayment),
	constraint fk_payments_pagaments foreign key (idPayment) references payment_type(idPayment)
);

-- criar tabela pedido
create table orders(
	idOrder int auto_increment primary key, 
	idOrderClient int,
    orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10, 
    paymentCash bool default False,
    IdDelivery int,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
);
alter table orders add constraint fk_delivery_orders foreign key (IdDelivery) references delivery(idDelivery);


-- criar tabela estoque
create table productStorage(
	idProductStorage int auto_increment primary key, 
    storageLocation varchar(255),
    quantity int default 0
);

-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key, 
    SocialName varchar(255)not null,
    CNPJ char(15)not null,
    contact char(11)not null,
    constraint unique_supplier unique(CNPJ)
);

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key, 
    SocialName varchar(255),
    AbstName varchar(255)not null,
    CNPJ char(15),
    CPF char(9),
    Location varchar(255),
    contact char(11)not null,
    constraint unique_cpf_seller unique(CPF),
    constraint unique_cnpj_seller unique(CNPJ)
);

create table productSeller(
	idPseller int,
    idProduct int,
    prodQuantity int default 1,
    primary key (idPseller, idProduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idProduct) references product(idProduct)
);

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível', 
    primary key (idPOproduct, idPOorder),
	constraint fk_product_order foreign key (idPOproduct) references product(idProduct),
    constraint fk_product_product_order foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    Location varchar(255) not null,
    primary key (idLproduct, idLstorage),
	constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProductStorage)
);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct ),
	constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);


create table delivery(
	idDelivery int auto_increment primary key,
    statusOrders enum ('Produto em transito', 'Produto entregue ao destinatário', 'Produto esta em rota de entrega'),
    codeTracking int
);
alter table delivery add constraint fk_product_delivery foreign key (idDelivery) references orders(idOrderClient);

-- inserção de dados  e queries
insert into Clients (Fname, Minit, Lname, CPF, Address, type_client)
		values('Maria', 'M', 'Silva', 12346789, 'Rua Silva de Prata 29, Carangola - Cidade das Flores', 'PJ'),
			  ('Matheus', 'O', 'Pimentel', 987654321, 'Rua Alameda 289, Centro - Cidade das Flores', 'PF'),
              ('Ricardo', 'F', 'Silva', 45678913, 'Rua Almeda Vinha 1009, Centro - Cidade das Flores', 'PF'),
              ('Julia', 'S', 'França', 789123456, 'Rua Lareijras 861, Centro - Cidade das Flores', 'PJ'),
              ('Roberta','G', 'Assis', 98745631, 'Avenidade Koller 19, Centro - Cidade das Flores','PF'),
              ('Isabela', 'M', 'Cruz', 654789123, 'Rua Alameda das Flores 28, Centro - Cidade das Flores', 'PJ');


insert into product (Pname, Classification_kids, Category, Avaliação, size)
		values('Fonde de ouvido',false,'Eletronico','4', null),
			  ('Barbie Elsa',true,'Brinquedos','3', null),
              ('Body Carters',true,'Vestimenta','5', null),
              ('Microfone Vedo Youtuber',false,'Eletronico','4', null),
              ('Sofá retrátil',false,'Móveis','3','3x57x80'),
              ('Farinha de Arroz',false,'Alimentos','2', null),
              ('Fire Stick Amazon',false,'Eletronico','3', null);

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
		values(1, default, 'compra via aplicativo', null, 1),
			  (2, default, 'compra via aplicativo', 50, 0),
			  (3, 'Confirmado', null, null, 1),
              (4, default, 'compra via web site', 150,0);
          
          
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
		 values(1,1,2,null),
			   (2,1,1,null),
			   (3,2,1,null);
               
insert into productStorage (storageLocation, quantity)
		values('Rio de Janeiro', 1000),
              ('Rio de Janeiro', 500),
		      ('São Paulo', 10),
              ('São Paulo', 100),
              ('São Paulo',10),
              ('Brasília', 60);
              
insert into storageLocation (idLproduct,idLstorage,location)
			values(1,2,'RJ'),
                  (2,6,'GO');

insert into supplier (SocialName, CNPJ, contact)
		values('Almeida e filhos', 123456789123456,'21985474'),
		      ('Eletronicos Silva', 854519649143457, '21985484'),
              ('Eletronicos Valma', 934567893934695, '21975474');
              
insert into productSupplier (idPsSupplier, idPsProduct, quantity)
		values(1,1,500),
              (1,2,400),
              (2,4,633),
              (3,3,5),
              (2,5,10);
              
              
insert into seller(SocialName, AbstName, CNPJ, CPF, location, contact)
		values('Tech eletronics', 'Tech eletronics', 123456789456321, null,'Rio de Janeiro', 219946287),
              ('Botique Durgas', 'Botique Durgas',null, 123456783, 'Rio de Janeiro', 219567895),
              ('Kids World', 'Kids World', 456789123654485, null, 'São Paulo', 1198657484);
              
              
insert into productSeller (idPseller, idProduct, prodQuantity)
		values(1,6,80),
              (2,7,10);
              
insert into delivery (idDelivery, statusOrders,codeTracking)
		       values(1, 'Produto entregue ao destinatário', 12345678),
					 (2, 'Produto em transito', 45678923),
                     (3, 'Produto esta em rota de entrega', 34512367),
                     (4, 'Produto em transito', 76548329);
                     
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
		values(2,default, 'compra via aplicativo', null, 1);
        
update orders set IdDelivery = '1'
where idOrder = 1;
update orders set IdDelivery = '2'
where idOrder = 2;
update orders set IdDelivery = '3'
where idOrder = 3;
update orders set IdDelivery = '4'
where idOrder = 4;

-- Quantos pedidos foram feitos por cada cliente?
select c.idClient, Fname, count(*) as Number_of_orders from clients c
			inner join orders o ON c.idClient = o.idOrderClient
			group by idClient;
            
		
-- Algum vendedor também é fornecedor?
select s.idSeller, p.idSupplier
	from seller s
    inner join supplier p ON s.SocialName = p.SocialName;
    

--  Relação de produtos cadastrados na base. ORDENE POR IdProduct, Pname, Category, Avaliação, size, Classification_kids, size
select IdProduct, Pname, Category, Avaliação, size, Classification_kids
from Product
order by IdProduct, Pname, Category, Avaliação, size, Classification_kids;


-- RELAÇÃO DOS PRODUTOS VENDIDOS PARA O CLIENTE "Matheus".
SELECT Pname AS 'Nome do Produto'
FROM Product P
INNER JOIN productOrder PO ON p.idProduct = PO.idPOproduct
INNER JOIN orders O ON O.idOrder = PO.idPOorder
INNER JOIN clients C ON C.idClient = O.idOrderClient
WHERE C.fName = 'Matheus';

-- Relação de nomes dos fornecedores e nomes dos produtos. 
select SocialName, Pname AS 'Nome dos Produtos'
from supplier s
inner join product p ON s.idSupplier = p.idProduct;

-- Quantidade total de produtos que foram vendidos da categoria "ELETRONICO".
SELECT sum(i.prodQuantity) AS "QUANTIDADE TOTAL", p.Category, p.Pname
FROM Product P
INNER JOIN productSeller I ON P.idProduct = I.idProduct
WHERE p.Category IN ('Eletronico')
GROUP BY Category, p.Pname;

-- 	Relação de produtos, fornecedores e estoques;
select SocialName, Pname AS 'Nome dos Produtos'
from supplier s
inner join product p ON s.idSupplier = p.idProduct
inner join storageLocation SL ON idLproduct = p.idProduct;

-- Somar a quantidade total de todos os produtos e filtrar apenas os que a somatoria é maior que 10.
SELECT sum(i.prodQuantity) AS "QUANTIDADE TOTAL", p.Category, p.Pname
FROM Product P
INNER JOIN productSeller I ON P.idProduct = I.idProduct
-- WHERE p.Category IN ('Eletronico')
GROUP BY Category, p.Pname
Having sum(i.prodQuantity) > 10;
