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

%% Calcular o custo tendo em conta a distancia, o veiculo e o peso da encomenda
custoTempo(Id,Peso,Dist,EsteCusto):-
    transporteById(Id, transporte(_,Veiculo,_,_,_,_)),
    velocidadeMediaEntrega(Veiculo,Peso,V),
    EsteCusto is Dist / V
.

%% Calcular o custo que se gastaria de gasoleo de um dado transporte
% relacao a uma dada distancia
custoConsumo(Id,_,Dist,Custo):-
    custoConsumoEntrega(Id,Dist,Custo).

%%%% A Estrela
resolve_aestrela(Nome, Nodo, Id ,Peso, Caminho/Custo) :-
    resolve_procura('aestrela',Nome, Nodo , Id, Peso, Caminho/Custo).
resolve_aestrela(Nome, Nodo, Final, Id, Peso, Caminho/Custo):-
    resolve_procura('aestrela',Nome, Nodo, Final, Id, Peso, Caminho/Custo).

%%%% Gulosa
resolve_gulosa(Nome, Nodo, Id ,Peso, Caminho/Custo) :-
    resolve_procura('gulosa',Nome, Nodo , Id, Peso, Caminho/Custo).
resolve_gulosa(Nome, Nodo, Final, Id, Peso, Caminho/Custo):-
    resolve_procura('gulosa',Nome, Nodo, Final, Id, Peso, Caminho/Custo).

% PROCURA

% No caso de nao ser dado o Nodo final, presume se que é o centro
resolve_procura(Procura,Funcao, Nodo, Id ,Peso, Caminho/Custo) :-
    goal(Final),
    resolve_procura(Procura,Funcao, Nodo, Final, Id, Peso, Caminho/Custo).
% Resolve procura
% Procura -> é o nome do tipo de procura que queremos, pode ser gulosa ou a Aestrela
% Nome -> Nome da Funcao que calcula o custo real
% Nodo -> Nodo que pretendemos chegar
% Final -> Nodo inicial do caminho
% Peso -> Peso da encomenda
% Caminho/Custo -> Solucao
resolve_procura(Procura, Nome, Nodo, Final, Id, Peso, Caminho/Custo):-
    estima(Nodo,  Estima),
    ((Nome == tempo, Funcao = custoTempo) ;
     (Nome == custo, Funcao = custoConsumo) ),
    procura(Procura,Funcao, Id, Peso, Final, [[Nodo]/0/Estima], InuCam/Custo/_),
    reverse(InuCam, Caminho).

procura(Procura,_,_,_,Nodo,Caminhos,Caminho):-
    obtem_caminho(Procura,Caminhos,Caminho),
    Caminho=[Nodo|_]/_/_.

procura(Procura, Funcao,Id,Peso,Final,Caminhos,SCaminho):-
    obtem_caminho(Procura,Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCam),
    expande(Funcao, Id, Peso,Final,MelhorCaminho, ExpCam),
    append(OutrosCam, ExpCam, NCam),
    procura(Procura,Funcao, Id, Peso, Final, NCam, SCaminho).

%Dá todos os caminhos adjacentes ao NovoCaminho
expande(_,_,_,Nodo,[[Nodo|Caminho]/Custo/Est | T], [[Nodo|Caminho]/Custo/Est | T]).

expande(Funcao, Id, Peso,_,Caminho, ExpCam) :-
    findall(NovoCaminho, adjacenteAux(Funcao, Id, Peso, Caminho, NovoCaminho), ExpCam).

adjacenteAux(Funcao, Id, Peso, [Nodo|Caminho]/Custo/_, [ProxNodo, Nodo| Caminho]/NovoC/Est) :-
    adjacente(Nodo,ProxNodo,Distancia),
    \+ member(ProxNodo, Caminho),
    call(Funcao,Id,Peso,Distancia,EsteCusto),
    NovoC is Custo+EsteCusto,
    estima(ProxNodo, Est).

obtem_caminho(_,[Caminho], Caminho) :- !.
obtem_caminho('aestrela',[ Caminho1/Custo1/Estima1, _/Custo2/Estima2|Caminhos], MCam) :-
        Custo1+Estima1 =< Custo2+Estima2, !,
        obtem_caminho('aestrela',[Caminho1/Custo1/Estima1|Caminhos], MCam).
obtem_caminho('gulosa',[ Caminho1/Custo1/Estima1, _/_/Estima2|Caminhos], MCam) :-
        Estima1 =< Estima2, !,
        obtem_caminho('gulosa',[Caminho1/Custo1/Estima1|Caminhos], MCam).
obtem_caminho(A,[_|Caminhos], MCam) :- obtem_caminho(A,Caminhos, MCam).

%Tira da lista dos caminhos q tinhamos o melhor caminho
seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :-
    seleciona(E, Xs, Ys).

%% TODO fazer A estrela que recebe varias moradas e tem q passar
%% por todas elas

%% TODO Fazer a gulosa (ou adaptar as funcoes de cima ;)
