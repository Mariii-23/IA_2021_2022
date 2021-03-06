% freguesia: Nome -> {V,F}
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

% rua: Nome, Nome da Freguesia, Coordenada -> {V,F}
rua('Rua do Taxa','Sao Vitor',coordenada(1,4)).
rua('Avenida Dom João II','Nogueiró',coordenada(1,1)).
rua('Rua de São Bento','Merelim',coordenada(3,3)).
rua('Rua Doutor José Alves Correia Da Silva','Frossos',coordenada(4,0)).
rua('Rua do Moinho','Caldelas',coordenada(3,5)).
rua('Rua Dr. Lindoso','Briteiros',coordenada(6,4)).
rua('Rua do Coucão','Priscos',coordenada(5,1)).
rua('Rua da Mota','Adaúfe',coordenada(7,2)).
rua('Rua Joãozinho Azeredo','Maximinos',coordenada(6,0)).
rua('Rua de Santa Marta','Esporões',coordenada(7,5)).
rua('Rua do Sol','Lamas',coordenada(3,1)).
rua('Rua da Universidade','Braga',coordenada(0,2)).

% aresta: Morada, Morada, Custo, Distancia Real -> {V,F}
aresta(morada('Rua da Universidade', 'Braga'), morada('Rua do Taxa','Sao Vitor'),2,11).
aresta(morada('Rua da Universidade', 'Braga'), morada('Avenida Dom João II','Nogueiró'),10,12).
aresta(morada('Rua do Taxa','Sao Vitor'),morada('Rua do Moinho','Caldelas'),1,13).
aresta(morada('Rua do Taxa','Sao Vitor'),morada('Rua de São Bento','Merelim'),3,14).
aresta(morada('Avenida Dom João II','Nogueiró'), morada('Rua do Sol','Lamas'),3,13).
aresta(morada('Avenida Dom João II','Nogueiró'), morada('Rua Doutor José Alves Correia Da Silva','Frossos'),3,10).
aresta(morada('Rua do Moinho','Caldelas'),morada('Rua Dr. Lindoso','Briteiros'),1,13).
aresta(morada('Rua de São Bento','Merelim'),morada('Rua Dr. Lindoso','Briteiros'),2,15).
aresta(morada('Rua de São Bento','Merelim'),morada('Rua do Coucão','Priscos'),2,12).
aresta(morada('Rua do Sol','Lamas'),morada('Rua do Coucão','Priscos'),5,13).
aresta(morada('Rua Doutor José Alves Correia Da Silva','Frossos'),morada('Rua do Coucão','Priscos'),12,13).
aresta(morada('Rua Doutor José Alves Correia Da Silva','Frossos'),morada('Rua Joãozinho Azeredo','Maximinos'),4,13).
aresta(morada('Rua Doutor José Alves Correia Da Silva','Frossos'),morada('Rua da Mota','Adaúfe'),3,15).
aresta(morada('Rua Dr. Lindoso','Briteiros'),morada('Rua da Mota','Adaúfe'),5,12).
aresta(morada('Rua Dr. Lindoso','Briteiros'),morada('Rua de Santa Marta','Esporões'),5,10).

% centroDistribuicao: Morada -> {V,F}
centroDistribuicao(morada('Rua da Universidade','Braga')).

% transporte: Id, Nome, Velocidade Média, Carga Máxima, Nível Ecológico, Consumo Medio -> {V,F}
transporte(1,'bicicleta',10,5,5,1).
transporte(2,'mota',35,20,-2,6).
transporte(3,'carro',25,100,-5,8).
transporte(4,'bicicleta elétrica',40,15,3,2).
transporte(5,'bicicleta elétrica',40,15,3,2).
transporte(6,'bicicleta elétrica',40,15,3,2).
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

% estafeta: Id, Nome -> {V,F}
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

% ranking: Id Estafeta, Classificação -> {V,F}
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

% cliente: Id, Nome, morada(Nome da Rua,Nome da Freguesia) -> {V,F}
cliente(1,'Alexandra Epifânio',morada('Rua do Taxa','Sao Vitor')).
cliente(2,'Filipa Simão',morada('Rua do Coucão','Priscos')).
cliente(3,'Ana Reigada',morada('Rua de Santa Marta','Esporões')).
cliente(4,'Maria Dinis',morada('Rua Dr. Lindoso','Briteiros')).
cliente(5,'Mafalda Bravo',morada('Rua Dr. Lindoso','Briteiros')).
cliente(6,'Alexandre Rosas',morada('Rua da Mota','Adaúfe')).

% encomeda: Id, Id_Cliente, Peso, Volume, DiaPedido: D/M/Y/H/M, Limite: D/H, -> {V,F}
encomenda(1,1,7,2,10/11/2021/8/35,0/2).
encomenda(2,1,5,10,22/11/2021/23/45,4/0).
encomenda(3,3,2,2,23/11/2021/16/2,1/0).
encomenda(4,5,5,2,24/11/2021/9/3,0/2).
encomenda(5,6,10,10,3/12/2021/11/30,4/0).
encomenda(6,2,25,2,3/12/2021/17/0,1/0).
encomenda(7,3,20,2,3/12/2021/18/23,2/0).
encomenda(8,4,17,2,4/12/2021/17/0,0/10).
encomenda(9,2,80,2,10/12/2021/17/0,0/8).
encomenda(10,6,3,2,4/12/2021/17/0,0/9).

% servico: Id, Id_estafeta, Id_encomenda, Id_transporte, DiaEntrega: D/M/Y/H/M, Classificacao, Caminho, Custo -> {V,F}
servico(1,2,[4],11,24/11/2021/20/43,3,[morada('Rua da Universidade','Braga'),morada('Rua do Taxa','Sao Vitor'),morada('Rua do Moinho','Caldelas'),morada('Rua Dr. Lindoso','Briteiros'),morada('Rua do Moinho','Caldelas'),morada('Rua do Taxa','Sao Vitor'),morada('Rua da Universidade','Braga')],25).
servico(2,3,[5,6,7],7,4/12/2021/9/0,5,[morada('Rua da Universidade','Braga'),morada('Rua do Taxa','Sao Vitor'),morada('Rua de São Bento','Merelim'),morada('Rua do Coucão','Priscos'),morada('Rua de São Bento','Merelim'),morada('Rua Dr. Lindoso','Briteiros'),morada('Rua da Mota','Adaúfe'),morada('Rua Dr. Lindoso','Briteiros'),morada('Rua de Santa Marta','Esporões'),morada('Rua Dr. Lindoso','Briteiros'),morada('Rua do Moinho','Caldelas'),morada('Rua do Taxa','Sao Vitor'),morada('Rua da Universidade','Braga')],60).
servico(3,1,[2,3],15,24/11/2021/10/30,4,[morada('Rua da Universidade','Braga'),morada('Rua do Taxa','Sao Vitor'),morada('Rua do Moinho','Caldelas'),morada('Rua Dr. Lindoso','Briteiros'),morada('Rua de Santa Marta','Esporões'),morada('Rua Dr. Lindoso','Briteiros'),morada('Rua do Moinho','Caldelas'),morada('Rua do Taxa','Sao Vitor'),morada('Rua da Universidade','Braga')],25).
