% Adjacente
adjacente(A,B,D) :-
    aresta(A,B),
    distancia(A,B,D).
adjacente(A,B,D) :-
    aresta(B,A),
    distancia(A,B,D).

goal(A) :- centroDistribuicao(A).

%% DISTANCIA
distancia(coordenada(X1,Y1), coordenada(X2,Y2), R):-
    Sum is ((X1 - X2)**2) + ((Y1 - Y2)**2),
    R is sqrt(Sum).
distancia(M1,M2,R):-
    coordenadaByMorada(M1,C1),
    coordenadaByMorada(M2,C2),
    distancia(C1,C2,R).

estima( A ,R):-
    coordenadaByMorada(A,M1),
    centroDistribuicao(X),
    coordenadaByMorada(X,M2),
    distancia(M1,M2,R).

% caminho acíclico P, que comeca no nó A para o nó B
caminho(A,B,P):- caminho1(A,[B],P).
caminho1(A,[A|P1],[A|P1]).
caminho1(A,[Y|P1],P):-
    adjacente(X,Y,_),
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
             adjacente(Act,X,_),
             \+ member(X,EstadoA)),
            Novos),
    append(Outros,Novos,Todos),
    bfs2(EstadoF,Todos,Solucao).


% Damos lhe todas as moradas q queremos q ele passe e ele encontra o caminho
% Exemplo de uso:
% bfs_complex([morada('Rua do Moinho','Caldelas'), morada('Rua do Sol','Lamas'), morada('Rua Dr. Lindoso','Briteiros')],S).
bfs_complex(Dest, Cam):-
    centroDistribuicao(X),
    bfsAux(Dest,[[X]],Cam).
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
             adjacente(Act,X,_),
             \+ member(X,EstadoA)),
            Novos),
    append(Outros,Novos,Todos),
    bfsAux(EstadoF,Todos,Solucao).

% Depth First
dfs(X, Y, S):-  dfs2(X, Y, [X], S).

dfs2(X, X, Cam, S):- reverse(Cam,S).
dfs2(X, Y, Cam, S):-
  adjacente(Novo,X,_),
  \+ member(Novo, Cam),
  dfs2(Novo, Y, [Novo|Cam], S).

% Damos lhe todas as moradas q queremos q ele passe e ele encontra o caminho
dfs_complex(Dest, S):-
    centroDistribuicao(X),
    dfsAux(X, Dest , [X], S).

dfsAux(_, Dest, Cam, S):-
    iguais(Dest,Cam,R),
    R = Dest,
    reverse(Cam,S).
dfsAux(X, Y, Cam, S):-
  adjacente(Novo,X,_),
  \+ member(Novo, Cam),
  dfsAux(Novo, Y, [Novo|Cam], S).

% Busca Iterativa Limitada em Profundidade
buscaIterativa(X, Y, L, S):-  buscaIterativa2(X, Y, [X], 1 , L, S).

buscaIterativa2(_, _, _, Ls , L , []):- Ls =:= (L+1) , !.
buscaIterativa2(X, X, Cam, _ , _ , S):- reverse(Cam,S).
buscaIterativa2(X, Y, Cam, N , L ,S):-
  adjacente(Novo,X,_),
  \+ member(Novo, Cam),
  N_ is N + 1,
  buscaIterativa2(Novo, Y, [Novo|Cam], N_ ,L, S).

% busca dando todos os destinos a ir
buscaIterativa_complex(Dest, L, S):-
    centroDistribuicao(X),
    buscaIterativaAux(X, Dest, [X], 1 , L, S).

buscaIterativaAux(_, _, _, Ls , L , []):- Ls =:= (L+1) , !.
buscaIterativaAux(_, Dest, Cam, _ , _ , S):-
    iguais(Dest,Cam,R),
    R = Dest,
    reverse(Cam,S).
buscaIterativaAux(X, Dest, Cam, N , L ,S):-
  adjacente(Novo,X,_),
  \+ member(Novo, Cam),
  N_ is N + 1,
  buscaIterativaAux(Novo, Dest, [Novo|Cam], N_ ,L, S).

%%%% A Estrela
%% TODO Fazer a pesquisa ou em funcao do custo ou do tempo
%% TODO adicionar Peso das encomendas
resolve_aestrela(Nodo, Caminho/Custo) :-
    estima(Nodo,  Estima),
    %No início o custo é 0
    aestrela([[Nodo]/0/Estima], InuCam/Custo/_),
    reverse(InuCam, Caminho).

aestrela(Caminhos,Caminho):-
    obtem_caminho(Caminhos,Caminho),
    Caminho=[Nodo|_]/_/_,
    goal(Nodo).

aestrela(Caminhos, SCaminho) :-
    %O Caminho é o ótimo dos vários Caminhos
    obtem_caminho(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCam),
    expande_aestrela(MelhorCaminho, ExpCam),
    append(OutrosCam, ExpCam, NCam),
    aestrela(NCam, SCaminho).

%Dá todos os caminhos adjacentes ao NovoCaminho
expande_aestrela([[Nodo|Caminho]/Custo/Est | T], [[Nodo|Caminho]/Custo/Est | T]):-
  centroDistribuicao(rua(A,B)),
  Nodo = morada(A,B).

expande_aestrela(Caminho, ExpCam) :-
    findall(NovoCaminho, adjacenteAux(Caminho, NovoCaminho), ExpCam).

adjacenteAux([Nodo|Caminho]/Custo/_, [ProxNodo, Nodo| Caminho]/NovoC/Est) :-
    %% FIXME se o A estrela for por custo -> fazer algo
    %%       se             for por tempo -> ver a cena de velocidade
    adjacente(Nodo,ProxNodo,EsteCusto),
    \+ member(ProxNodo, Caminho),
    NovoC is Custo+EsteCusto,
    estima(ProxNodo, Est).

% TODO Converter para funcionar para o AEstrela e para o Gulosa
%Obtem Caminho só serve para o AEstrela
obtem_caminho([Caminho], Caminho) :- !.
obtem_caminho([ Caminho1/Custo1/Estima1, _/Custo2/Estima2|Caminhos], MCam) :-
        Custo1+Estima1 =< Custo2+Estima2, !,
        obtem_caminho([Caminho1/Custo1/Estima1|Caminhos], MCam).

obtem_caminho([_|Caminhos], MCam) :- obtem_caminho(Caminhos, MCam).

%Tira da lista dos caminhos q tinhamos o melhor caminho
seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :-
    seleciona(E, Xs, Ys).

%% TODO fazer A estrela que recebe varias moradas e tem q passar
%% por todas elas

%% TODO Fazer a gulosa (ou adaptar as funcoes de cima ;)
