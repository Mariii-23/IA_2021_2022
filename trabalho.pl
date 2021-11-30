:- op(900,xfy,'::').

:- dynamic freguesia/3.
:- dynamic rua/2.
:- dynamic morada/2.
:- dynamic transporte/5.
:- dynamic estafeta/2.
:- dynamic ranking/3.
:- dynamic cliente/3.
:- dynamic encomenda/6.
:- dynamic servico/6.


:- include('bases_dados.pl').

:- include('funcoes_auxiliares.pl').
:- include('writeStructs.pl').
:- include('queries.pl').

%%%%%%%%%%%%%%%%%%%% Validar dados %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% TODO faltam adicinar muitos destes
%%% Freguesia %%%
% Garantir que o nome de cada freguesia é único
+freguesia(Nome,_,_) :: (findall(Nome,freguesia(Nome,_,_),R),
                         len(R,1)).

% Garantir que o Custo, as Horas e os Minutos inseridos são números válidos
+freguesia(_,Custo,H/M) :: (number(Custo),number(H),number(M)
                            , -1 < H, H < 25 , -1 < M, M < 61, C > 0
                           ).

% Garantir que não é possível remover nenhuma freguesia que pertença a uma
% morada de algum cliente
-freguesia(Nome,_,_) :: (findall(Nome,cliente(_,_,morada(_,Nome)),R),
                       len(R,0)).

%%% Rua %%%
% Garantir que o nome de cada rua é único
+rua(Nome,_) :: (findall(Nome,rua(Nome,_),R),
                       len(R,1)).

+rua(_,NomeFreguesia) :: (freguesia(NomeFreguesia,_,_)).

% Garantir que não é possível remover nenhuma rua no caso de esta encontrar-se
% associada a alguma morada de um cliente
-rua(Nome,_) :: (findall(Nome,cliente(_,_,morada(Nome,_)),R),
                       len(R,0)).

%%%  Transportes  %%%%
% Garantir que o id dos transportes é único
+transporte(Id,_,_,_,_) :: (findall(Id,transporte(Id,_,_,_,_), R),
                            len(R,1)).

% Garantir que os dados inseridos encontram-se no formato certo
+transporte(Id,_,V,C,E) :: (number(Id), number(V),number(C),number(E)
                             ,-1 < V, -1 < C, -6 < E, E < 6
                            ).

% Garantir que um transporte só pode ser removido no caso de não estar presente
% em nenhum serviço
-transporte(Id,_,_,_,_) :: (findall(Id,servico(_,_,_,Id,_,_),R),
                            len(R,0)).

%%%  Estafeta  %%%%
% Garantir que o id dos estafetas é único
+estafeta(Id,_) :: (findall(Id,estafeta(Id,_),R),
                   len(R,1)).

% Garantir que os dados inseridos encontram-se no formato certo
+estafeta(Id,_) :: (number(Id)).

% Garantir que um estafeta só pode ser removido no caso de não estar associado a nenhum serviço
-estafeta(Id,_) :: (findall(Id,servico(_,Id,_,_,_,_),R),
                    len(R,0)).

%%--------- Cliente
+cliente(Id,_,Morada) :: (
     number(Id),
     Morada,
     findall(Id, cliente(Id,_,_), R),
     len(R,1)
 ).

-cliente(Id,_,_) :: (
     findall(Id, encomenda(_,Id,_,_,_,_),R),
     len(R,0)
 ).

%%--------- Encomenda
+encomenda(Id,C,P,V,D/M/Y/H,D1,H1) :: (
     number(Id),number(C), number(P),
     number(V),number(D), number(M),
     number(Y),number(H), number(D1),
     number(H1)).

+encomenda(Id,C,_,_,_,_) :: (
     findall(Id,encomenda(Id,_,_,_,_,_),R),
     len(R,1),
     findall(C,cliente(C,_,_),R1),
     len(R1,1)
 ).


% -------- Adicionar predicados ---
newRua(Nome,F):- new_predicado(rua(Nome,F)).

newFreguesia(Nome,C,T):- new_predicado(freguesia(Nome,C,T)).

newTransporte(Id,N,V,C,E):- new_predicado(transporte(Id,N,V,C,E)).

newEstafeta(Id,Nome):- new_predicado(estafeta(Id,Nome)).

newCliente(Id,Nome,M):- new_predicado(cliente(Id,Nome,M)).

newEncomenda(Id,C,P,V,D,L):- new_predicado(encomenda(Id,C,P,V,D,L)).

newServico(Id,E,En,C,D,C):- new_predicado(servico(Id,E,En,C,D,C)).

% -------- Remover predicados ---
removeRua(Nome):- rua(Nome,F), remover_predicado(rua(Nome,F)).

removeFreguesia(Nome):- freguesia(Nome,C,T), remover_predicado(freguesia(Nome,C,T)).

removeTransporte(Id):- transporte(Id,N,V,C,E) , remover_predicado( transporte(Id,N,V,C,E)).

removeEstafeta(Id):- estafeta(Id,Nome) , remover_predicado( estafeta(Id,Nome)).

removeCliente(Id):- cliente(Id,Nome,M), remover_predicado(cliente(Id,Nome,M)).

removeEncomenda(Id):- encomenda(Id,C,P,V,D,L), remover_predicado(encomenda(Id,C,P,V,D,L)).

removeServico(Id):-  servico(Id,E,En,C,D,C), encomenda(E,C1,P1,V1,D1,L1) ,
                     remover_predicado(servico(Id,E,En,C,D,C)),
                     remover_predicado(encomenda(E,C1,P1,V1,D1,L1))
.

% ----------
morada(R,F):- rua(R,F), freguesia(F,_,_).
