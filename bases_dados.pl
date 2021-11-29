% freguesia: Nome, custo de ir la, tempo: H/M
freguesia('Taipas',23, 0/15).
freguesia('Briteiros',10, 0/30).
freguesia('Sao Vitor',50, 1/30 ).

%rua: nome da rua, freguesia
rua('Nova','Taipas').
rua('Santo Antonio','Taipas').
rua('Velha','Briteiros').
rua('Bernardo','Sao Vitor').

% transporte: Id,Nome,Velocidade,Carga,Pontos_Ecologicos -> {V,F}
transporte(1,'bicicleta',10,5,5).
transporte(2,'mota',35,20,-2).
transporte(3,'carro',25,100,-5).
transporte(4,'bicicleta elétrica',40,15,3).

% estafeta: #ID,Nome -> {V,F}
estafeta(1,'Bernardo').
estafeta(2,'Sofia').
estafeta(3,'Costa').
estafeta(4,'Filipe').

%ranking id estafeta, Classifficacao
ranking(1,5).
ranking(2,4).
ranking(3,3).
ranking(4,1).

% cliente: #Id,Nome,Morada -> {V,F}
cliente(1,'Leonardo',      morada('Nova','Taipas')).
cliente(2,'Leonor'  ,      morada('Velha','Briteiros')).
cliente(3,'Alexandre',     morada('Bernardo','Sao Vitor')).
cliente(4,'Maria Dinis',   morada('Santo Antonio','Taipas')).
cliente(5,'Mafalda Bravo', morada('Velha','Briteiros')).
cliente(6,'Tomas Faria',   morada('Bernardo','Sao Vitor')).

% encomenda: #Id,Id Cliente, Peso, Volume, Dia Pedido: #D/M/Y/H/M , Limite: #D/H
encomenda(1, 1 ,2,  2,  10/11/2021/8/0, 0/2 ).
encomenda(2, 1 ,5,  10, 24/11/2021/23/0, 4/0 ).
encomenda(3, 3 ,2,  2,  23/11/2021/16/0, 1/0 ).
encomenda(4, 5 ,5,  2,  10/11/2021/9/0,  0/2 ).
encomenda(5, 6 ,10, 10, 12/10/2021/11/0, 4/0 ).
encomenda(6, 2 ,5,  2,  13/09/2021/17/0, 1/0 ).

% servico: #Id,Id_estafeta,Id_encomenda,Id Transporte,DiaEntrega:# D/M/Y/H/M,Classificacao
servico(1, 3, 4, 3, 10/11/2021/10/0, 5).
servico(2, 4, 5, 2, 14/10/2021/12/0, 2).
servico(3, 1, 6, 1, 14/09/2021/14/0, 4).
servico(4, 3, 2, 1, 14/09/2021/14/0, 4).
servico(5, 3, 1, 2, 10/11/2021/10/0, 5).
servico(6, 3, _, 1, _,_).
servico(7, 3, _, 4, _,_).
servico(8, 2, _, 4, _,_).
servico(9, 2, _, 4, _,_).
