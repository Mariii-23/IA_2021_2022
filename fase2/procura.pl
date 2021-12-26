% Adjacente
%adjacente(X,Y,C,T) :- aresta(X,Y,C,T).
%adjacente(X,Y,C,T) :- aresta(Y,X,C,T).

% %% ou
% Adjacente
adjacente(morada(A,X),morada(B,X),0,0):-  rua(A,X), rua(B,X).
adjacente(morada(A,X),morada(B,Y),C,D) :- rua(A,X), rua(B,Y) ,aresta(X,Y,C,D).
adjacente(morada(A,X),morada(B,Y),C,D) :- rua(A,X), rua(B,Y) ,aresta(Y,X,C,D).

estima(tempo, _, morada(_,X) , morada(_,X) ,0).
estima(custo, _, morada(_,X) , morada(_,X) ,0).

estima(tempo, Id_Transporte, morada(_,X) , morada(_,Y) , T):-
    aresta(X,Y,_,D),
    transporteById(Id_Transporte,transporte(Id_Transporte,_,V,_,_)),
    T is div(D,V).
estima(tempo, Id_Transporte, morada(_,X) , morada(_,Y) , D):-
    estima(tempo, Id_Transporte, morada(_,Y) , morada(_,X) , D).

estima(custo, _, morada(_,X) , morada(_,Y) , C):- aresta(X,Y,C,_).
estima(custo, _, morada(_,X) , morada(_,Y) , C):- aresta(Y,X,C,_).

% caminho acíclico P, que comeca no nó A para o nó B
caminho(A,B,P):- caminho1(A,[B],P).
caminho1(A,[A|P1],[A|P1]).
caminho1(A,[Y|P1],P):-
    adjacente(X,Y,_,_),
    \+ member(X,[Y|P1]),
    caminho1(A,[X,Y|P1],P).

% Breadth First
% Apenas ir para uma dada morada
bfs(Orig, Dest, Cam):- bfs2(Dest,[[Orig]],Cam).

bfs2(X,[[X|T]|_],Solucao)  :- reverse([X|T],Solucao).
bfs2(EstadoF,[EstadoA|Outros],Solucao) :-
    EstadoA = [Act|_],
    findall([X|EstadoA],
            (EstadoF\==Act,
             adjacente(Act,X,_,_),
             \+ member(X,EstadoA)),
            Novos),
    append(Outros,Novos,Todos),
    bfs2(EstadoF,Todos,Solucao).


% Damos lhe todas as moradas q queremos q ele passe e ele encontra o caminho
% Exemplo de uso:
% bfs_complex([morada('Rua do Moinho','Caldelas'), morada('Rua do Sol','Lamas'), morada('Rua Dr. Lindoso','Briteiros')],S).
bfs_complex(Dest, Cam):-
    centroDistribuicao(rua(X,Y)),
    bfsAux(Dest,[[morada(X,Y)]],Cam).
bfsAux( Dest,[[X|T]|_],Solucao)  :-
    iguais(Dest,[X|T],R),
    R = Dest,
    reverse([X|T],Solucao).
bfsAux( EstadoF,[[X|T]|Outros],Solucao)  :-
    member(X,EstadoF),
    delete(EstadoF,X,R),
    bfsAux(R,[[X|T]|Outros],Solucao).
bfsAux(EstadoF,[EstadoA|Outros],Solucao) :-
    EstadoA = [Act|_],
    findall([X|EstadoA],
            ( \+ member(Act,EstadoF),
             adjacente(Act,X,_,_),
             \+ member(X,EstadoA)),
            Novos),
    append(Outros,Novos,Todos),
    bfsAux(EstadoF,Todos,Solucao).

% Depth First
dfs(X, Y, S):-  dfs2(X, Y, [X], S).

dfs2(X, X, Cam, S):- reverse(Cam,S).
dfs2(X, Y, Cam, S):-
  adjacente(Novo,X,_,_),
  \+ member(Novo, Cam),
  dfs2(Novo, Y, [Novo|Cam], S).

% Damos lhe todas as moradas q queremos q ele passe e ele encontra o caminho
dfs_complex(Dest, S):-
    centroDistribuicao(rua(X,Y)),
    dfsAux(morada(X,Y), Dest , [morada(X,Y)], S).

dfsAux(_, Dest, Cam, S):-
    iguais(Dest,Cam,R),
    R = Dest,
    reverse(Cam,S).
dfsAux(X, Y, Cam, S):-
  adjacente(Novo,X,_,_),
  \+ member(Novo, Cam),
  dfsAux(Novo, Y, [Novo|Cam], S).

% Busca Iterativa Limitada em Profundidade
buscaIterativa(X, Y, L, S):-  buscaIterativa2(X, Y, [X], 1 , L, S).

buscaIterativa2(_, _, _, Ls , L , []):- Ls =:= (L+1) , !.
buscaIterativa2(X, X, Cam, _ , _ , S):- reverse(Cam,S).
buscaIterativa2(X, Y, Cam, N , L ,S):-
  adjacente(Novo,X,_,_),
  \+ member(Novo, Cam),
  N_ is N + 1,
  buscaIterativa2(Novo, Y, [Novo|Cam], N_ ,L, S).

% busca dando todos os destinos a ir
buscaIterativa_complex(Dest, L, S):-
    centroDistribuicao(rua(X,Y)),
    buscaIterativaAux(morada(X,Y), Dest, [morada(X,Y)], 1 , L, S).

buscaIterativaAux(_, _, _, Ls , L , []):- Ls =:= (L+1) , !.
buscaIterativaAux(_, Dest, Cam, _ , _ , S):-
    iguais(Dest,Cam,R),
    R = Dest,
    reverse(Cam,S).
buscaIterativaAux(X, Dest, Cam, N , L ,S):-
  adjacente(Novo,X,_,_),
  \+ member(Novo, Cam),
  N_ is N + 1,
  buscaIterativaAux(Novo, Dest, [Novo|Cam], N_ ,L, S).

% GULOSA
obtem_caminho([Caminho], Caminho) :- !.
obtem_caminho([ Caminho1/Custo1/Estima1, _/Custo2/Estima2|Caminhos], MCam) :-
        Custo1+Estima1 =< Custo2+Estima2, !,
        obtem_caminho([Caminho1/Custo1/Estima1|Caminhos], MCam).
obtem_caminho([_|Caminhos], MCam) :- obtem_caminho(Caminhos, MCam).

%% Construir o caminho
%% Por tempo e por Custo

% dou lhe as moradas q tem q ir e a respetiva carga da encomeda, o id do transporte
