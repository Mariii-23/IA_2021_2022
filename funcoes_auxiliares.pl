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
    %% not(P),
    findall(X,+P::X,R),
    inserir(P),
    valid(R).

% Remover um dado conhecimento, garantindo que este pode ser removido
remover_predicado(P):-
    %% P,
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

% Remover todos os elementos repetidos numa lista
% NAO SEI porque esta maneira nao da...
%eliminaRepetidos([X], [X]).
%eliminaRepetidos([X|T], R)
%    :- member(X,R), eliminaRepetidos(T,R).
%eliminaRepetidos([X|T], [X|R])
%:-  eliminaRepetidos(T,R).

eliminaRepetidos(X, R) :- eliminaRepAux(X,[],R).

eliminaRepAux([],Acc,Acc).
eliminaRepAux([X|XS],Acc,R) :- member(X,Acc),!, eliminaRepAux(XS,Acc,R).
eliminaRepAux([X|XS],Acc,R) :- eliminaRepAux(XS,[X|Acc],R).

% Soma de todos os elementos
sum([],0).
sum([X|T],N):- sum(T,R), N is R+X.

avg(L, R) :- sum(L,Soma), length(L,Len), R is Soma/Len.


% Como usar: freq([1,2,3,1,2,1,3,4], [], R).
freq([], R, R).
freq([X | Xs], Temp, R) :-
    select((N, X), Temp, Outros), % Encontra o elemento X e o seu numero de ocorrencias
    M is N + 1,
    freq(Xs, [ (M, X) | Outros], R).
freq([X | Xs], Temp, R) :-
    not(select((_, X), Temp, _)),
    freq(Xs, [ (1, X) | Temp], R).

maxFreq(L,R):-
    freq(L,[],RL),
    sort(1, @>=, RL, [(_,R)|_]).
