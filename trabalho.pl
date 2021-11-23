
:- op(900,xfy,'::').

:- dynamic transporte/5.
:- dynamic estafeta/2.
:- dynamic cliente/3.
:- dynamic encomenda/6.
:- dynamic servico/6.


:- include('bases_dados.pl').

:- include('funcoes_auxiliares.pl').
:- include('writeStructs.pl').

%%%%%%%%%%%%%%%%%%%% Validar dados %%%%%%%%%%%
%%%  Transportes  %%%%

% Garantir que o id dos transportes é único
+transporte(Id,_,_,_,_) :: (find_solucoes(Id,transporte(Id,_,_,_,_), R),
                            len(R,1)).

% Garantir que os dados inseridos encontram-se no formato certo
+transporte(Id,_,V,C,E) :: (number(Id), number(V),number(C),number(E)).

% Garantir que um transporte só pode ser removido no caso de não estar presente em nenhum serviço
-transporte(Id,_,_,_,_) :: (find_solucoes(Id,servico(_,_,_,Id,_,_),R),
                            len(R,0)
                           ).
%%%  Estafeta  %%%%
% Garantir que o id dos estafetas é único
+estafeta(Id,_) :: (find_solucoes(Id,estafeta(Id,_),R),
                   len(R,1)).

% Garantir que os dados inseridos encontram-se no formato certo
+estafeta(Id,_) :: (number(Id)).

% Garantir que um estafeta só pode ser removido no caso de não estar associado a nenhum serviço
-estafeta(Id,_) :: (find_solucoes(Id,servico(_,Id,_,_,_,_),R),
                   len(R,0)).

% -------- Adicionar predicados ---
newTransporte(Id,N,V,C,E):- new_predicado(transporte(Id,N,V,C,E)).

newEstafeta(Id,Nome):- new_predicado(estafeta(Id,Nome)).

% -------- Remover predicados ---
removeTransporte(Id):- transporte(Id,N,V,C,E) , remover_predicado( transporte(Id,N,V,C,E)).

removeEstafeta(Id):- estafeta(Id,Nome) , remover_predicado( estafeta(Id,Nome)).


% ----------
morada(R,F):- rua(R,F), freguesia(F,_).
