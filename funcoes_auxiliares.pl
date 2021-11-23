% Procurar solocoes
find_solucoes(X, XS, R) :- XS, assert(tmp(X)), fail.
find_solucoes(X, XS, R) :- solucoesAux([], R).

solucoesAux(L, R) :- retract(tmp(X)), !, solucoesAux([X|L], R).
solucoesAux(R, R).

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
new_predicado(P):- find_solucoes(X,+P::X,R),
                   inserir(P),
                   valid(R).

% Remover um dado conhecimento, garantindo que este pode ser removido
remover_predicado(P):- find_solucoes(X,-P::X,R),
                       remover(P),
                       valid(R).
