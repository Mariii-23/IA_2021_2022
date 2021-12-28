:- op(900,xfy,'::').

:- dynamic freguesia/1.
:- dynamic rua/3.
:- dynamic morada/2.
:- dynamic aresta/3.
:- dynamic transporte/6.
:- dynamic ranking/2.
:- dynamic estafeta/2.
:- dynamic ranking/3.
:- dynamic cliente/3.
:- dynamic encomenda/6.
:- dynamic servico/8.
:- dynamic custoTempo/4.
:- dynamic custoGasoleo/4.

:- include('base_dados.pl').

:- include('funcoes_auxiliares.pl').
:- include('identificacoes.pl').
:- include('writeStructs.pl').
:- include('queries.pl').
:- include('procura.pl').

%%%%%%%%%%%%%%%%%%%% Validar dados %%%%%%%%%%%
%%% Freguesia %%%
% Garantir que o nome de cada freguesia é único
+freguesia(Nome) :: (findall(Nome,freguesia(Nome),R),
                     len(R,1)).


% Garantir que o Custo, as Horas e os Minutos inseridos são números válidos
%+freguesia(_,Custo,H/M) :: (number(Custo),number(H),number(M)
%                            , -1 < H, H < 24 , -1 < M, M < 60, Custo > 0
%                           ).

% Garantir que não é possível remover nenhuma freguesia que pertença a uma
% morada de algum cliente
-freguesia(Nome) :: (findall(Nome,cliente(_,_,morada(_,Nome)),R),
                       len(R,0)).

%%% Rua %%%
% Garantir que o nome de cada rua é único
+rua(Nome,_,_) :: (findall(Nome,rua(Nome,_,_),R),
                       len(R,1)).

 % Garantir que o nome de freguesia dado é verdadeiro e existe na nossa
 % base de conhecimento
+rua(_,NomeFreguesia,_) :: (freguesia(NomeFreguesia,_,_)).

% Garantir que não é possível remover nenhuma rua no caso de esta encontrar-se
% associada a alguma morada de um cliente
-rua(Nome,_,_) :: (findall(Nome,cliente(_,_,morada(Nome,_)),R),
                       len(R,0)).

%%%  Transportes  %%%%
% Garantir que o id dos transportes é único
+transporte(Id,_,_,_,_,_) :: (findall(Id,transporte(Id,_,_,_,_,_), R),
                            len(R,1)).

% Garantir que os dados inseridos encontram-se no formato certo
+transporte(Id,_,V,C,E,Q) :: (number(Id), number(V),number(C),number(E),number(Q),
                             ,-1 < V, -1 < C, -6 < E, E < 6
                            ).

% Garantir que um transporte só pode ser removido no caso de não estar presente
% em nenhum serviço
-transporte(Id,_,_,_,_,_) :: (findall(Id,servico(_,_,_,Id,_,_,_,_),R),
                            len(R,0)).

%%%  Estafeta  %%%%
% Garantir que o id dos estafetas é único
+estafeta(Id,_) :: (findall(Id,estafeta(Id,_),R),
                   len(R,1)).

% Garantir que os dados inseridos encontram-se no formato certo
+estafeta(Id,_) :: (number(Id)).

% Garantir que um estafeta só pode ser removido no caso de não estar associado a nenhum serviço
-estafeta(Id,_) :: (findall(Id,servico(_,Id,_,_,_,_,_,_),R),
                    len(R,0)).

%%% Ranking %%%
% Garantir que só se consegue associar um ranking a um estafeta já existente
+ranking(Id,_) :: ( findall(Id,estafeta(Id,_),R), len(R,N), 0 < N).

% Garantir que só existe 1 ranking para cada estafeta
+ranking(Id,_) :: ( findall(Id,ranking(Id,_),R), len(R,1)).

% Garantir que o valor do ranking encontra-se entre 0 e 5.
+ranking(Id,C) :: (number(Id),number(C), -1 < C, C < 6).

%%% Cliente %%%
% Garantir que o id dos clientes são únicos e a morada dada é válida.
+cliente(Id,_,Morada) :: (
     number(Id),
     Morada,
     findall(Id, cliente(Id,_,_), R),
     len(R,1)).

% Garantir que não é possível remover nenhum cliente que se encontre associado a uma dada encomenda.
-cliente(Id,_,_) :: (
     findall(Id, encomenda(_,Id,_,_,_,_),R),
     len(R,0)).

%%% Encomenda %%%
% Garantir que os dados inseridos encontram-se no formato correto.
+encomenda(Id,C,P,V,D/M/Y/H/Min,D1/H1) :: (
     number(Id),number(C), number(P),
     number(V),number(D), number(M),
     number(Y),number(H), number(D1),
     -1 < D, D < 32 ,
     -1 < M, M < 60,
     -1 < H, H < 24 ,
     -1 < P,
     -1 < V,
     -1 < Min, Min < 60,
     number(H1), number(Min),
     -1 < H1, H1 < 24).

% Garantir que o id das encomendas é único e o cliente associado a ela é válido.
+encomenda(Id,C,_,_,_,_) :: (
     findall(Id,encomenda(Id,_,_,_,_,_),R),
     len(R,1),
     findall(C,cliente(C,_,_),R1),
     len(R1,1)
     ).

% Garantir que não é possível remover uma encomenda no caso de esta, se
% encontrar associada a um serviço
-encomenda(Id,_,_,_,_,_) :: (
     findall(Id,(servico(_,_,LId,_,_,_,_,_), member(Id,LId) ),R),
     len(R,0)).

%%% Serviço %%%
% Garantir que o id dos serviços são únicos
+servico(Id,_,_,_,_,_,_,_) :: (
    findall(Id,servico(Id,_,_,_,_,_,_,_),R),
    len(R,1)).

% Garantir que os estafetas associados são válidos
+servico(_,E,_,_,_,_,_,_) :: (
     findall(E,estafeta(E,_),R1),
     len(R1,1)).

% Garantir que as encomendas associadas são válidos
% TODO

% Garantir que os transportes associados são válidos
+servico(_,_,_,T,_,_,_,_) :: (
     findall(T,transporte(T,_,_,_,_,_),R3),
     len(R3,1)).

% Garantir que os dados inseridos encontram-se no formato correto.
+servico(Id,E,_,T,D/M/Y/H/Min,C,_,Custo) :: (
     number(Id),number(E),
     number(T),number(D), number(M),
     number(Y),number(H), number(C), number(Custo),
     -1 < D, D < 32 ,
     -1 < M, M < 60,
     -1 < H, H < 24 ,
     -1 < Min, Min < 60,
     -1 < E,
     -1 < Id,
     -1 < C,
     number(Min)).


% -------- Adicionar predicados ---
newRua(Nome,F,Cor):- new_predicado(rua(Nome,F,Cor)).

newFreguesia(Nome):- new_predicado(freguesia(Nome)).

newTransporte(Id,N,V,C,E,Q):- new_predicado(transporte(Id,N,V,C,E,Q)).

newEstafeta(Id,Nome):- new_predicado(estafeta(Id,Nome)).

newRanking(Id,Ranking):- new_predicado(ranking(Id,Ranking)).

newCliente(Id,Nome,M):- new_predicado(cliente(Id,Nome,M)).

newEncomenda(Id,C,P,V,D,L):- new_predicado(encomenda(Id,C,P,V,D,L)).

newServico(Id,E,En,C,D,C,Cam,Custo):- new_predicado(servico(Id,E,En,C,D,C,Cam,Custo)).

% -------- Remover predicados ---
removeRua(Nome):- rua(Nome,F,Coor), remover_predicado(rua(Nome,F,Coor)).

removeFreguesia(Nome):- freguesia(Nome), remover_predicado(freguesia(Nome)).

removeTransporte(Id):- transporte(Id,N,V,C,E,Q) , remover_predicado( transporte(Id,N,V,C,E,Q)).

removeRanking(Id):- ranking(Id,C),remover_predicado(ranking(Id,C)).

removeEstafeta(Id):- estafeta(Id,Nome) , remover_predicado( estafeta(Id,Nome)).

removeCliente(Id):- cliente(Id,Nome,M), remover_predicado(cliente(Id,Nome,M)).

removeEncomenda(Id):- encomenda(Id,C,P,V,D,L), remover_predicado(encomenda(Id,C,P,V,D,L)).

% TODO
%removeServico(Id):-  servico(Id,E,En,C,D,C,Cam,Custo), encomenda(E,C1,P1,V1,D1,L1) ,
%                     remover_predicado(servico(Id,E,En,C,D,C)),
%                     remover_predicado(encomenda(E,C1,P1,V1,D1,L1)).

% ----------
morada(R,F):- rua(R,F,_), freguesia(F).
