% % TODO apagar antes de entregar
% Procurar solucoes
%find_all(X, XS, _) :- XS, assert(tmp(X)), fail.
%find_all(_, _, R) :- findAux([], R).
%
%findAux(L, R) :- retract(tmp(X)), !, findAux([X|L], R).
%findAux(R, R).

% length lista
len([],0).
len([_|T],NS) :-
    len(T,N), NS is N+1.

% Verificar se é valido
valid([]).
valid([A|T]):- A, valid(T).

% Inserir um novo conhecimento
inserir(New):- assert(New).
inserir(New):- retract(New), !, fail.

% Remover conhecimento
remover(X):- retract(X).
remover(X):- assert(X), !, fail.

% Inserir um novo conhecimento verificando se este se encontra valido
new_predicado(P):-
    not(P),
    findall(X,+P::X,R),
    inserir(P),
    valid(R).

% Remover um dado conhecimento, garantindo que este pode ser removido
remover_predicado(P):-
    P,
    findall(X,-P::X,R),
    remover(P),
    valid(R).
% Retorna apenas os elementos iguais
iguais([],_,[]).
iguais([X|T],L2,[X|R]):-
    member(X,L2), !,
    iguais(T,L2,R)
    %not(member(X,R)),
.

iguais([_|T],L2,R):-
    iguais(T,L2,R).

% Soma de todos os elementos
sum([],0).
sum([X|T],N):- sum(T,R), N is R+X.

avg(L, R) :- sum(L,Soma), length(L,Len), R is Soma/Len.
