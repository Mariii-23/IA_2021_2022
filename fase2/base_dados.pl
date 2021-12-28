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

%rua: Nome da Rua, Freguesia, Coordenada: x, y
rua('Rua do Taxa','Sao Vitor',coordenada(0,1)).
rua('Avenida Dom João II','Nogueiró',coordenada(3,7)).
rua('Rua de São Bento','Merelim',coordenada(4,5)).
rua('Rua Doutor José Alves Correia Da Silva','Frossos',coordenada(2,6)).
rua('Rua do Moinho','Caldelas',coordenada(3,1)).
rua('Rua Dr. Lindoso','Briteiros',coordenada(2,3)).
rua('Rua do Coucão','Priscos',coordenada(3,0)).
rua('Rua da Mota','Adaúfe',coordenada(1,1)).
rua('Rua Joãozinho Azeredo','Maximinos',coordenada(0,2)).
rua('Rua de Santa Marta','Esporões',coordenada(1,4)).
rua('Rua do Sol','Lamas',coordenada(1,8)).
rua('Rua da Universidade', 'Braga',coordenada(5,1)).

%aresta: Freguesia , Freguesia -> {V,F}
aresta(morada('Rua do Taxa','Sao Vitor'), morada('Avenida Dom João II','Nogueiró')).
aresta(morada('Avenida Dom João II','Nogueiró'), morada('Rua do Moinho','Caldelas')).
aresta(morada('Rua de São Bento','Merelim'), morada('Rua Doutor José Alves Correia Da Silva','Frossos')).
aresta(morada('Rua Dr. Lindoso','Briteiros'),  morada('Rua da Mota','Adaúfe')).
aresta(morada('Rua do Coucão','Priscos'), morada('Rua Joãozinho Azeredo','Maximinos')).
aresta(morada('Rua da Mota','Adaúfe'), morada('Rua do Sol','Lamas')).
aresta(morada('Rua Joãozinho Azeredo','Maximinos'), morada('Rua do Sol','Lamas')).
aresta(morada('Rua de Santa Marta','Esporões'), morada('Rua do Sol','Lamas')).
aresta(morada('Rua do Sol','Lamas'), morada('Rua do Moinho','Caldelas')).
aresta(morada('Rua da Universidade', 'Braga'), morada('Rua de Santa Marta','Esporões')).
% aresta('Sao Vitor', 'Lamas',6 ).
% aresta('Nogueiró','Lamas' ,20,9).
% aresta('Merelim','Nogueiró' ,31, 14).
% aresta('Frossos', 'Merelim',19, 8).
% aresta('Caldelas', 'Briteiros',60,28).
% aresta('Briteiros', 'Priscos',53, 25).
% aresta('Priscos', 'Adaúfe',31,14).
% aresta('Adaúfe', 'Maximinos',28,11).
% aresta('Maximinos', 'Esporões',6,3).
% aresta('Esporões', 'Lamas',28,11).
% aresta('Lamas', 'Frossos',26,10).
% aresta('Caldelas', 'Braga',5, 15).

% centroDistribuicao: Morada
centroDistribuicao(morada('Rua da Universidade', 'Braga')).

% transporte: Id,Nome,Velocidade,Carga,Pontos_Ecologicos, MediaConsumo -> {V,F}
transporte(1,'bicicleta',10,5,5, 1).
transporte(2,'mota',35,20,-2,6).
transporte(3,'carro',25,100,-5,8).
transporte(4,'bicicleta elétrica',40,15,3, 2).
transporte(5,'bicicleta elétrica',40,15,3, 2).
transporte(6,'bicicleta elétrica',40,15,3, 2).
transporte(7,'carro',25,100,-5,8).
transporte(8,'carro',25,100,-5,8).
transporte(9,'carro',25,100,-5,8).
transporte(10,'carro',25,100,-5,8).
transporte(11,'mota',35,20,-2,4).
transporte(12,'mota',35,20,-2,4).
transporte(13,'mota',35,20,-2,4).
transporte(14,'mota',35,20,-2,4).
transporte(15,'bicicleta',10,5,5,1).
transporte(16,'bicicleta',10,5,5,1).
transporte(17,'bicicleta',10,5,5,1).

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
