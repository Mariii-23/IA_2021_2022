% freguesia: Nome
freguesia('Sao Vitor').
freguesia('Nogueiró').
freguesia('Merelim').
freguesia('Frossos').
freguesia('Caldelas').
freguesia('Briteiros').
freguesia('Priscos').
freguesia('Adaúfe').
freguesia('Maximinos').
freguesia('Esporões').
freguesia('Lamas').
freguesia('Braga').

%rua: nome da rua, freguesia
rua('Rua do Taxa','Sao Vitor').
rua('Avenida Dom João II','Nogueiró').
rua('Rua de São Bento','Merelim').
rua('Rua Doutor José Alves Correia Da Silva','Frossos').
rua('Rua do Moinho','Caldelas').
rua('Rua Dr. Lindoso','Briteiros').
rua('Rua do Coucão','Priscos').
rua('Rua da Mota','Adaúfe').
rua('Rua Joãozinho Azeredo','Maximinos').
rua('Rua de Santa Marta','Esporões').
rua('Rua do Sol','Lamas').
rua('Rua da Universidade', 'Braga').

%aresta: Freguesia , Freguesia , custo, Distancia
aresta('Sao Vitor', 'Lamas',13, 6 ).
aresta('Nogueiró','Lamas' ,20,9).
aresta('Merelim','Nogueiró' ,31, 14).
aresta('Frossos', 'Merelim',19, 8).
aresta('Caldelas', 'Briteiros',60,28).
aresta('Briteiros', 'Priscos',53, 25).
aresta('Priscos', 'Adaúfe',31,14).
aresta('Adaúfe', 'Maximinos',28,11).
aresta('Maximinos', 'Esporões',6,3).
aresta('Esporões', 'Lamas',28,11).
aresta('Lamas', 'Frossos',26,10).
aresta('Caldelas', 'Braga',5, 15).

centroDistribuicao(rua('Rua da Universidade', 'Braga')).

% transporte: Id,Nome,Velocidade,Carga,Pontos_Ecologicos -> {V,F}
transporte(1,'bicicleta',10,5,5).
transporte(2,'mota',35,20,-2).
transporte(3,'carro',25,100,-5).
transporte(4,'bicicleta elétrica',40,15,3).
transporte(5,'bicicleta elétrica',40,15,3).
transporte(6,'bicicleta elétrica',40,15,3).
transporte(7,'carro',25,100,-5).
transporte(8,'carro',25,100,-5).
transporte(9,'carro',25,100,-5).
transporte(10,'carro',25,100,-5).
transporte(11,'mota',35,20,-2).
transporte(12,'mota',35,20,-2).
transporte(13,'mota',35,20,-2).
transporte(14,'mota',35,20,-2).
transporte(15,'bicicleta',10,5,5).
transporte(16,'bicicleta',10,5,5).
transporte(17,'bicicleta',10,5,5).

% estafeta: #ID,Nome -> {V,F}
estafeta(1,'Bernardo').
estafeta(2,'Sofia').
estafeta(3,'Costa').
estafeta(4,'Filipe').
estafeta(4,'Joana').
estafeta(5,'Filipa').
estafeta(6,'Pedro').
estafeta(7,'João').
estafeta(8,'Ricardo').
estafeta(8,'Catarina').
estafeta(9,'Mafalda').
estafeta(10,'Martim').

%ranking id estafeta, Classificacao
ranking(1,5).
ranking(2,4.3).
ranking(3,3.2).
ranking(4,1.3).
ranking(5,2.6).
ranking(6,4.2).
ranking(7,4.6).
ranking(8,3.5).
ranking(9,4.9).
ranking(10,4.4).

% cliente: #Id,Nome,Morada -> {V,F}
cliente(1,'Alexandra Epifânio', morada('Rua do Taxa','Sao Vitor')).
cliente(2,'Filipa Simão'  ,   morada('Rua do Coucão','Priscos')).
cliente(3,'Ana Reigada',  morada('Rua de Santa Marta','Esporões')).
cliente(4,'Maria Dinis',   morada('Santo Antonio','Taipas')).
cliente(5,'Mafalda Bravo', morada('Rua Dr. Lindoso','Briteiros')).
cliente(6,'Alexandre Rosas', morada('Rua da Mota','Adaúfe')).

% encomenda: #Id,Id Cliente, Peso, Volume, Dia Pedido: #D/M/Y/H/M , Limite: #D/H
encomenda(1, 1 ,7,  2,  10/11/2021/8/35, 0/2 ).
encomenda(2, 1 ,5,  10, 22/11/2021/23/45, 4/0 ).
encomenda(3, 3 ,2,  2,  23/11/2021/16/02, 1/0 ).
encomenda(4, 5 ,5,  2,  24/11/2021/9/03,  0/2 ).
encomenda(5, 6 ,10, 10, 03/12/2021/11/30, 4/0 ).

encomenda(6, 2 ,25,  2,  03/12/2021/17/0, 1/0 ).
encomenda(7, 3 ,20,  2,  03/12/2021/18/23, 2/0 ).
encomenda(8, 4 ,17,  2,  04/12/2021/17/0, 0/10 ).
encomenda(9, 2 ,80,  2,  10/12/2021/17/0, 0/8 ).
encomenda(10, 6 ,3,  2,  11/12/2021/17/0, 0/9 ).

% servico: #Id,Id_estafeta,Id_encomendas,Id Transporte,DiaEntrega:# D/M/Y/H/M,Classificacao, Caminho, CustoReal
servico(1, 3, [1], 3, 10/11/2021/9/11, 5, [], 4).
servico(2, 4, [3], 1, 24/11/2021/9/0, 4,  [], 42).
servico(3, 1, [2], 15, 24/11/2021/14/0, 3,[], 14).
% atrasada
servico(4, 2, [4], 1, 24/11/2021/20/43, 3, [], 12).
servico(5, 6, [5], 2, 03/12/2021/13/00, 5, [], 15).
servico(6, 2, [6], 7, 04/12/2021/07/03 ,4, [], 21).
servico(8, 5, [8], 11, 05/12/2021/08/21 ,3,[], 41).
servico(7, 3, [7], 14, 05/12/2021/18/23 ,1,[], 23).