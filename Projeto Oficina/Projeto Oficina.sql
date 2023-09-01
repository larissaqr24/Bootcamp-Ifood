-- Criação de Banco de Dados para o cenário de OFICINA.
create database oficina;
use oficina;

create table clientes(
	Id_cliente int auto_increment primary key,
    Nome_cliente varchar(255),
    End_cliente varchar(255),
    Tel_cliente char(11)
);

create table veiculos(
	Id_veiculo int auto_increment primary key,
    Modelo varchar(50),
    Ano char(4),
    Placa char(10),
    constraint FK_clientes_veiculos foreign key (Id_veiculo) references clientes(Id_cliente)
);

create table ordem_servico(
	Id_servico int auto_increment primary key,
    Descricao varchar(50),
    Valor char(10),
    Data_emissao char(10),
    Status_servico enum('Em manutencao', 'Servico finalizado'),
    Data_conclusao char(10)
);

create table agendamentos(
	Id_agendamento int auto_increment primary key,
    Id_cliente int, 
    Id_veiculo int, 
    Id_servico int,
    Tipo_servico varchar(100),
    Data_agendamento char(10),
    Horario char(5),
    constraint FK_clientes_agendamentos foreign key (Id_cliente) references clientes(Id_cliente),
    constraint FK_veiculos_agendamentos foreign key (Id_veiculo) references veiculos(Id_veiculo),
    constraint FK_servico_agendamentos foreign key (Id_servico) references ordem_servico(Id_servico)
);

create table pecas_utilizadas(
	Id_peca int auto_increment primary key,
    Nome_peca varchar(50),
    Valor_peca char(10),
    Quantidade_estoque char(5)
);

create table mao_de_obra(
	Id_mao_de_obra int auto_increment primary key,
    Id_agendamento int,
    Id_peca int,
    Quantidade_usada int,
    constraint FK_agendamentos_mao_de_obra foreign key (Id_agendamento) references agendamentos(Id_agendamento),
    constraint fk_peca_agendamento foreign key (Id_peca) references pecas_utilizadas(Id_peca)
);

create table pagamento(
	Id_pagamento int primary key,
    Valor char(10),
    Data_pagamento char(10),
    constraint FK_agendamentos_pagamento foreign key (Id_pagamento) references agendamentos(Id_agendamento)
);

-- inserção de dados e queries.
insert into clientes (Id_cliente, Nome_cliente, End_cliente, Tel_cliente)
			values(1, 'Pedro da Silva Rodrigues', 'Rua Maria Isabel 503, Centro - Sao Paulo', 99164738272),
				  (2, 'Leticia Pereira', 'Av das Hortensias 444, Centro - Gramado', 58724904439),
                  (3, 'Lucas de Souza', 'Rua Alameda das Flores 179, Centro - Rio de Janeiro', 54987612354),
                  (4, 'Madalena da Rocha', 'Clarimundo Marques Pires 888, Santa Monica - Ribeirão Preto', 78943256738),
                  (5, 'Terezinha Francisca', 'Rua Benedito Ramos 510, Centro - Araraquara', 89632144578);
                  
insert into veiculos(Id_veiculo, Modelo, Ano, Placa)
			values(1, 'Corsa', 2004,'JWA2972'),
				  (2, 'Jeep', 2023,'MPZ6513'),
				  (3, 'Onix', 2021,'KOV8135'),
                  (4, 'Civic', 2020,'HPI9958'),
                  (5, 'Fiat Toro', 2019, 'NEO9135');

insert into ordem_servico(Id_servico, Descricao, Valor, Data_emissao, Status_servico, Data_conclusao)
			values(1, 'Troca de oleo', 299, '10/06/2023','Servico finalizado', '10/06/2023'),
				  (2, 'Manutencao de embreagem', 800, '24/03/2023','Servico finalizado', '15/04/2013'),
                  (3, 'Balanceamento', 550, '29/08/2023','Em manutencao', '03/08/2023'),
                  (4, 'Revisao dos componentes do freio', 1450, '10/07/2023','Em manutencao', '29/08/2023'),
                  (5, 'Manutencao no sistema de arrefecimento', 1800, '01/08/2023','Em manutencao', '29/08/2023');
                  
insert into agendamentos(Id_agendamento, Id_cliente, Id_veiculo, Id_servico, Tipo_servico, Data_agendamento, Horario)
			values(1, 1, 1,1, 'Troca de oleo', '29/09/2023', '09:00'),
				  (2, 2, 2,2, 'Balanceamento', '05/09/2023', '11:00'),
                  (3, 3, 3,3, 'Revisao', '01/10/2023', '07:00'),
                  (4, 4, 4,4, 'Troca de Filtros', '31/08/2023', '10:30'),
                  (5, 5, 5,5, 'Revisao', '15/10/2023', '16:00');
                
insert into pecas_utilizadas(Id_peca, Nome_peca, Valor_peca, Quantidade_estoque)
			values(1, 'Chave para filtro de oleo com 3 garras', 150, 4),
				  (2, 'chave de roda', 250, 2),
                  (3, 'Radiador', 980, 1),
                  (4, 'Filtro', 40, 8),
                  (5, 'Disco de Freios', 80, 50);

insert into mao_de_obra(Id_mao_de_obra, Id_agendamento, Id_peca, Quantidade_usada)
			values(1, 1, 1, 2),
				  (2, 2, 2, 1),
                  (3, 3, 3, 1),
                  (4, 4, 4, 2),
                  (5, 5, 5, 2);
                  
insert into pagamento(Id_pagamento, Valor, Data_pagamento)
			values(1, 150, '10/06/2023'),
				  (2, 250, '15/04/2013'),
                  (3, 980, '03/08/2023'),
                  (4, 40, '29/08/2023'),
                  (5, 80, '29/08/2023');
                  
-- Recuperar informações do veículo de um cliente:
SELECT Nome_cliente, Modelo, Placa
FROM clientes
INNER JOIN veiculos ON Id_cliente = Id_cliente;


-- Listar todos os agendamentos de um cliente com detalhes do veículo e serviço:
SELECT nome_cliente, Modelo, descricao
FROM clientes C
INNER JOIN veiculos V ON C.Id_cliente = V.Id_veiculo
INNER JOIN ordem_servico OS ON C.Id_cliente = OS.Id_servico;


-- Mostre a quantidade de servicos realizados para cada cliente:
SELECT nome_cliente, COUNT(Id_agendamento) AS 'Quantidade de Servicos'
FROM clientes C
LEFT JOIN agendamentos A ON C.Id_cliente = A.Id_cliente
GROUP BY nome_cliente;


-- Verificar o estoque de peças para serviço de Troca de Oleo:
SELECT  Quantidade_estoque
FROM pecas_utilizadas PU
INNER JOIN ordem_servico OS ON  PU.Id_peca = OS.Id_servico
WHERE OS.descricao = 'Troca de oleo';


-- Obter detalhes de pagamento para um agendamento:
SELECT Data_pagamento, tipo_servico
FROM pagamento P
INNER JOIN agendamentos A ON P.Id_pagamento = A.Id_agendamento
GROUP BY Data_pagamento, tipo_servico;


-- Obter detalhes de pagamento para um agendamento QUE SEJA MAIOR QUE 300 REAIS:
SELECT Data_pagamento, tipo_servico
FROM pagamento P
INNER JOIN agendamentos A ON P.Id_pagamento = A.Id_agendamento
GROUP BY Data_pagamento, tipo_servico
HAVING sum(P.valor) > 300;

-- Informe a soma de peças utilizadas pela mão de obra:
SELECT A.Id_agendamento, SUM(Quantidade_usada)  AS 'TOTAL DE PECAS UTILIZADAS'
FROM agendamentos A
LEFT JOIN ordem_servico OS ON A.Id_agendamento = OS.Id_servico
LEFT JOIN mao_de_obra MO ON OS.Id_servico = MO.Id_peca
GROUP BY A.Id_agendamento;
    

-- Mostre no estoque os valores das peças entre 200 reais e 1500 reais:
SELECT *
FROM pecas_utilizadas
WHERE valor_peca between 200 AND 1500;


