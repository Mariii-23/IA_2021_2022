% QUERY 1 - Identificar o estafeta que utilizou mais vezes um meio de
% transporte mais ecológico
estafetaServicoEcologico(servico(_,IdEstafeta,_,IdT,_,_,_,_), IdEstafeta):-
    nivelEcologicoByIdTransporte(IdT,E),
    -1 < E.

estafetasServicoEcologico([], []).
estafetasServicoEcologico([X|T], [Id|R]) :-
    estafetaServicoEcologico(X,Id),
    estafetasServicoEcologico(T,R).
estafetasServicoEcologico([X|T], R) :-
    not(estafetaServicoEcologico(X,_)),
    estafetasServicoEcologico(T,R).

estafetaMaisEcologico(R):-
    findall(servico(Id,E,Enc,T,D,C,Cam,Cs),servico(Id,E,Enc,T,D,C,Cam,Cs),L),
    estafetasServicoEcologico(L,LS),
    maxFreq(LS,IdEstafeta),
    estafetaById(IdEstafeta,R).

% QUERY 2 - identificar que estafetas entregaram determinada(s) encomenda(s)
% a um  cliente
estafetasQueEntregaram(IdsEncomendas, R) :-  maplist(estafetaQueEntregou, IdsEncomendas , R).
estafetaQueEntregou(IdEncomenda, R) :-
    findall( Id ,(servico(_,Id,IdEncomendas,_,_,_,_,_), member(IdEncomenda,IdEncomendas)) ,[IdEstafeta|_]),
    findall(estafeta(IdEstafeta,Nome),
    estafeta(IdEstafeta,Nome),[R|_]).

% QUERY 3 - identificar os clientes servidos por um determinado estafeta
clientesServidosIdEstafeta(Id,C):-
    estafetaById(Id,_), % verificar se existe estafeta
    findall(IdEncomendas,servico(_,Id,IdEncomendas,_,_,_,_,_),Ls),
    junta(Ls,L),
    maplist(clienteByIdEncomenda,L,C_),
    eliminaRepetidos(C_,C).

% QUERY 4 - calcular o valor faturado pela Green Distribution num determinado
% dia.
valorFaturado(Dia/Mes/Ano,Valor) :-
    findall(Custo, servico(_,_,_,_,Dia/Mes/Ano/_/_,_,_,Custo),L),
    sum(L,Valor)
.

%% Query 5
getRua(morada(Rua,_), Rua).
getFreguesia(morada(_,Freguesia), Freguesia).
%% TODO MUDAR
moradasEncomendas(R) :-
    findall(Morada, (encomenda(_,CId,_,_,_,_), cliente(CId,_,Morada)), R).

ruasEncomendas(R) :-
    moradasEncomendas(L),
    maplist(getRua, L, R).

freguesiasEncomendas(R) :-
    moradasEncomendas(L),
    maplist(getFreguesia, L, R).

freguesiasMaisFrequentes(R) :-
    freguesiasEncomendas(Freguesias),
    freq(Freguesias, [], Freqs),
    sort(Freqs, R).

ruasMaisFrequentes(R) :-
    ruasEncomendas(Ruas),
    freq(Ruas, [], Freqs),
    sort(1, @>=, Freqs, R).

moradasMaisFrequentes(R) :-
    moradasEncomendas(Moradas),
    freq(Moradas, [], Freqs),
    sort(1, @>=, Freqs, R).

% QUERY 6 - calcular a classificação média de satisfação de cliente para
% um determinado estafeta
classificacaoEstafeta(IdEstafeta, Media) :-
    findall(C, servico(_,IdEstafeta,_,_,_,C,_,_), [X|L]), avg([X|L], Media).

% QUERY 7 - identificar o número total de entregas pelos diferentes meios de
% transporte, num determinado intervalo de tempo

total_entregas_por_transporte(D1/M1/Y1/H1/Min1,D2/M2/Y2/H2/Min2,Freq) :-
    findall(servico(A,B,C,D,E,F,Cam,Cs),
            (servico(A,B,C,D,E,F,Cam,Cs),isBetween(E,D1/M1/Y1/H1/Min1,D2/M2/Y2/H2/Min2)),
            Servicos), !,
            servicos_para_transportes(Servicos, Transportes),
            freq(Transportes,[],Freq).

total_entregas_por_transporte(D1/M1/Y1,D2/M2/Y2,Freq) :-
    findall(servico(A,B,C,D,E,F,Cam,Cs),
            (servico(A,B,C,D,E,F,Cam,Cs),isBetween(E,D1/M1/Y1/0/0,D2/M2/Y2/23/59)),
            Servicos),
            servicos_para_transportes(Servicos, Transportes),
            freq(Transportes,[],Freq).



servicos_para_transportes([],[]).
servicos_para_transportes([servico(_,_,_,IdTrs,_,_,_,_)|Ss],
                          [transporte(IdTrs,A,B,C,D,Q)|Ts]) :-
    transporte(IdTrs,A,B,C,D,Q),
    servicos_para_transportes(Ss,Ts).

%% Query 8
getEstafeta(servico(_,Id,_,_,_,_,_,_), R) :-
    estafetaById(Id, R).

% Trocamos a ordem dos argumentos do isBetween para funcionar como filtro
isBetweenFilter(I, F, servico(_,_,_,_,Data,_,_,_)) :- isBetween(Data, I, F).

servicosEntre(I, F, Servicos) :-
    findall(
        servico(Id,IdE,IdEnc,IdTrans,Data,Class,Cam,Custo),
        servico(Id,IdE,IdEnc,IdTrans,Data,Class,Cam,Custo),
        Lista),
    include(isBetweenFilter(I, F), Lista, Servicos).

servicosPorEstafetaEntre(I, F, R) :-
    servicosEntre(I, F, Servicos),
    maplist(getEstafeta, Servicos, Estafetas),
    freq(Estafetas, [], Freqs),
    sort(1, @>=, Freqs, R).

% QUERY 9 - calcular o número de encomendas entregues e não entregues
% pela Green Distribution, num determinado período de tempo

todasEncomendas(I,F,Entregues,NaoEntregues) :- encomendasEntregues(I,F,Entregues),encomendasNaoEntregues(Entregues,NaoEntregues).

encomendasEntregues(I,F,R) :-
    findall(E,
    foiEntregueEntre(E,I,F),
    R).

encomendasNaoEntregues(Entregues,R) :-
    findall(encomenda(Id,A,B,C,D,E),
    encomenda(Id,A,B,C,D,E), Todas),
    subtract(Todas,Entregues,R).

foiEntregueEntre(encomenda(Id,A,B,C,D,E), I,F) :-
    encomenda(Id,A,B,C,D,E),
    servico(_,_,Ids,_,Data,_,_,_),
    member(Id,Ids),
    isBetween(Data,I,F).

isBetween(D/Mon/Y/H/Min, D1/Mon1/Y1/H1/Min1, D2/Mon2/Y2/H2/Min2) :-
    Y/Mon/D/H/Min @< Y2/Mon2/D2/H2/Min2,
    Y/Mon/D/H/Min @> Y1/Mon1/D1/H1/Min1.

% QUERY 10 - calcular o peso total transportado por estafeta num determinado dia
pesoTotalByEstafetaNoDia(estafeta(Id,Nome),D, R) :-
    estafeta(Id,Nome), % verificar se o estafeta é válido
    totalCargaEstafetaDia(Id,D,R).

tuplePesoTotalByEstafetaByDia(E,D,(E,P)):- pesoTotalByEstafetaNoDia(E,D,P).

tuplePesoTotalByDia(D,R):-
    findall( Rs , (estafeta(Id,Nome),
        tuplePesoTotalByEstafetaByDia(estafeta(Id,Nome),D,Rs),
        Rs = (_,P),  P \== 0
    ) ,R).

pesoAllAux([],_,[]).
pesoAllAux([X|T],D,[ A | R ]):-
    tuplePesoTotalByEstafetaByDia(X,D,A),
    pesoAllAux(T,D,R).

pesoTotalAllEstafetaNoDia(D,R):-
    findall(estafeta(Id,Nome),estafeta(Id,Nome),L),
    pesoAllAux(L,D,R).

pesoTotalAux([],0).
pesoTotalAux([(_,N)|T], R):-
    pesoTotalAux(T,Rs),
    R is Rs + N.

pesoTotalByDia(D,R):-
    pesoTotalAllEstafetaNoDia(D,L),
    pesoTotalAux(L,R).

%%% ESTAFETA
estafetasIdByIdTransporte(Id,E):-
    findall(Id1,servico(_,Id1,_,Id,_,_,_,_),E).

estafetaMaisUtilizouIdTransporte(Id,E):-
    findall(Id1,servico(_,Id1,_,Id,_,_,_,_),R),
    maxFreq(R,IdE),
    estafetaById(IdE,E),!.
estafetaMaisUtilizouIdTransporte(_,[]).

estafetaMaisUtilizouTransporte(transporte(Id,_,_,_,_,_),E):-
    estafetaMaisUtilizouIdTransporte(Id,E).

tupleEstafetaMaisUtilizouTransporte(E, (E,R) ):-
    estafetaMaisUtilizouTransporte(E,R).

listaEstafetasUtilizouMaisTransporte(R):-
    findall(transporte(Id,N,V,C,E,Q),transporte(Id,N,V,C,E,Q),LT),
    maplist(tupleEstafetaMaisUtilizouTransporte,LT,R).

%%% CARGA
cargaEncomendaById(Id,R):-
    findall(C,encomenda(Id,_,C,_,_,_),[R|_]).

cargaEncomendaByIdCliente(Id,R):-
    findall(P,encomenda(_,Id,P,_,_,_),R).

cargaEstafeta(Id1,R):-
    findall(Id,servico(Id,Id1,_,_,_,_,_,_),R1), % buscar os ids das encomendas q ele realizou
    maplist(cargaEncomendaById,R1,R).

cargaEstafetaDia(Id1,D/M/Y,R):-
    findall(Id,(servico(_,Id1,Ids,_,D/M/Y/_/_,_,_,_),member(Id,Ids)),R1), % buscar os ids das encomendas q ele realizou nesse dia
    maplist(cargaEncomendaById,R1,R).

cargaCliente(Id1,R):-
    findall(Id,encomenda(Id,Id1,_,_,_,_),R2), % ids de todas as encomendas desse Cliente
    findall(Id,(servico(_,_,Ids,_,_,_,_,_),  member(Id,Ids)),Rs),
    junta(Rs, R1), % id de todas as encoendas feitas
    iguais(R1,R2,R3),
    maplist(cargaEncomendaById,R3,R).

%% Carga TOTAL
totalCargaEstafeta(Id,R):-
    cargaEstafeta(Id,L),
    sum(L,R).

totalCargaEstafetaDia(Id,D,R):-
    cargaEstafetaDia(Id,D,L),
    sum(L,R).

totalCargaEncomendaCliente(Id,R):-
    cargaEncomendaByIdCliente(Id,L),
    sum(L,R).

totalCargaServicoCliente(Id,R):-
    cargaCliente(Id,L),
    sum(L,R).

%%% Realizar encomendas

%% TEMPO DE ENTREGA
velocidadeMediaEntrega('bicicleta',Carga,R) :-
    velocidadeMediaByTransporteName('bicicleta',V),
    R is V - 0.7*Carga.

velocidadeMediaEntrega('bicicleta eletrica',Carga,R) :-
    velocidadeMediaByTransporteName('bicicleta eletrica',V),
    R is V - 0.7*Carga.

velocidadeMediaEntrega('carro',Carga,R) :-
    velocidadeMediaByTransporteName('carro',V),
    R is V - 0.1*Carga.

velocidadeMediaEntrega('mota',Carga,R) :-
    velocidadeMediaByTransporteName('mota',V),
    R is V - 0.5*Carga.

%% Custo do Gasoleo // aka comida se for bike
custoConsumoEntrega(IdVeiculo,Dist,R) :-
    mediaConsumoByIdTransporte(IdVeiculo,Media),
    Custo = 1.45, %% preco dos combustiveis
    R is (Dist * Media * Custo) / 100.

%% Calcula o peso das encomendas total que ainda nao entregou
%% [ morada/peso ] , Caminho, Resultado
calculaPesoTotalEmFuncaoDoCaminho( [], _, 0 ).
% Acabou de chegar a essa morada
calculaPesoTotalEmFuncaoDoCaminho( [ Morada/_ | T], Caminho , R ) :-
    member(Morada,Caminho),
    calculaPesoTotalEmFuncaoDoCaminho(T,Caminho, R).

% Encomenda ainda nao foi entregue
calculaPesoTotalEmFuncaoDoCaminho( [Morada/Peso | T], Caminho , R ):-
    \+ member(Morada, Caminho),
    calculaPesoTotalEmFuncaoDoCaminho(T,Caminho, R1),
    R is Peso + R1.

% Remover encomendas ja entregues
removeEncomendaLista( [] , _, []).
removeEncomendaLista( [M/_ | L] , Caminho , R):-
    removeEncomendaLista( L, Caminho, R ),
    member(M,Caminho).
removeEncomendaLista( [M/P | L] , Caminho , [M/P | R]):-
    removeEncomendaLista( L, Caminho, R ),
    \+ member(M,Caminho).

%% Id encomendas -> lista de freguesias a ir
freguesiasByIdEncomendas([],[]).
freguesiasByIdEncomendas([A|T],R):-
    freguesiaByIdEncomenda(A,L),
    freguesiasByIdEncomendas(T,Rt),
    eliminaRepetidos([L|Rt],R).

freguesiaByIdEncomenda(Id,Freguesia):-
    moradaByIdEncomenda(Id, morada(_,Freguesia)).


%%% Obter Caminho atraves de Id Encomendas, Estafeta e trasnporte
moradaAndPesoByIdEncomenda(Id, Morada/Peso):-
    moradaByIdEncomenda(Id,Morada),
    pesoByEncomendaId(Id,Peso).

%%% PROCURA NAO INFORMADA %%%

readNumber(X):-
    write('Introduza um numero: '),
    repeat, read(X), (X==end_of_file , !,fail;true ),
    number(X)
.

%% Procura -> tipo de procura
%% Enc -> lista de ids de encomendas
%% Caminho -> resultado
searchNaoInformadaCaminho(Procura, Enc, Caminho):-
    maplist(moradaByIdEncomenda, Enc, Encomendas),
    ((Procura == 'bfs', bfs_complex(Encomendas,Caminho));
    (Procura == 'dfs', dfs_complex(Encomendas,Caminho));
    (Procura == 'iterativa' , readNumber(X), buscaIterativa_complex(Encomendas,X,Caminho))).

searchNaoInformadaCaminhoIdaVolta(Procura, Enc, Caminho):-
    maplist(moradaByIdEncomenda, Enc, Encomendas),
    ((Procura == 'bfs', bfs_complexIdaVolta(Encomendas,Caminho));
    (Procura == 'dfs', dfs_complexIdaVolta(Encomendas,Caminho));
    (Procura == 'iterativa' , readNumber(X), buscaIterativa_complexIdaVolta(Encomendas,X,Caminho))).

%%% PROCURA INFORMADA
%% Procura -> tipo de procura
%% Funcao -> Custo podera ser calculado atraves do "tempo" ou do "custo" (custo do gasoleo)
%% Enc -> lista de ids de encomendas
%% Caminho -> resultado
searchInformadaCaminho(Procura, Funcao, Enc, Transporte,Caminho,Custo):-
    maplist(moradaAndPesoByIdEncomenda, Enc, Encomendas),
    resolve_procura_complex(Procura,Funcao, Encomendas ,Transporte,Caminho/Custo).

searchInformadaCaminhoIdaVolta(Procura, Funcao, Enc, Transporte,Caminho,Custo):-
    maplist(moradaAndPesoByIdEncomenda, Enc, Encomendas),
    resolve_procura_complex_idaVolta(Procura,Funcao, Encomendas ,Transporte,Caminho/Custo).

%% Query
%% Obter Servicos com maior número de entregas (por volume e peso)
calcularPesoByIdsEncomendas([],0).
calcularPesoByIdsEncomendas(L,R):-
    maplist(pesoByEncomendaId,L,Ls),
    sum(Ls,R).

calcularVolumeByIdsEncomendas([],0).
calcularVolumeByIdsEncomendas(L,R):-
    maplist(volumeByEncomendaId,L,Ls),
    sum(Ls,R).


calcularPesoByIdServico(Id,R):-
    encomendasByIdServico(Id,L),
    calcularPesoByIdsEncomendas(L,R).

calcularVolumeByIdServico(Id,R):-
    encomendasByIdServico(Id,L),
    calcularVolumeByIdsEncomendas(L,R).

servicosIdOrderByPeso(R):-
    findall( Id/Peso ,
             (servico(Id,_,E,_,_,_,_,_) ,
              calcularPesoByIdsEncomendas(E,Peso) ),L ),
    sort(2, @>=, L, R).

servicosIdOrderByVolume(R):-
    findall( Id/Volume ,
             (servico(Id,_,E,_,_,_,_,_) ,
              calcularVolumeByIdsEncomendas(E,Volume) ),L ),
    sort(2, @>=, L, R).

%% QUERY
% Identificar quais os circuitos com maior número de entregas (por volume e peso)

%% FIXME o unique nao da
caminhosMaiorPeso(R) :-
    findall(Caminho, servico(_,_,_,_,_,_,Caminho,_), X),
    sort(X,Caminhos),
    maplist(getSomaDePesosDoCaminho,Caminhos,L),
    sort(1, @>=, L, R).

getSomaDePesosDoCaminho(Ca, Soma/Ca) :-
    findall(Peso, (servico(Id,Id1,E,T,D,C,Ca,M),
                   pesoTotalByServico(servico(Id,Id1,E,T,D,C,Ca,M),Peso)),X),
    sum(X, Soma).

caminhosMaiorVolume(R) :-
    findall(Caminho, servico(_,_,_,_,_,_,Caminho,_), X),
    sort(X,Caminhos),
    maplist(getSomaDeVolumesDoCaminho,Caminhos,L),
    sort(1, @>=, L, R).


getSomaDeVolumesDoCaminho(Ca, Soma/Ca) :-
    findall(Peso, (servico(Id,Id1,E,T,D,C,Ca,M),
                   volumeTotalByServico(servico(Id,Id1,E,T,D,C,Ca,M),Peso)),X),
    sum(X, Soma).

%%%%%%

pesoTotalByServico(servico(_,_,E,_,_,_,_,_), Peso):-
    maplist(pesoByEncomendaId,E,Pesos),
    sum(Pesos,Peso).

tuplePesoTotalAndCaminhoByServico(S , Peso/Caminho):-
    S = servico(_,_,_,_,_,_,Caminho,_),
    pesoTotalByServico(S,Peso).

volumeTotalByServico(servico(_,_,E,_,_,_,_,_), Vol):-
    maplist(volumeByEncomendaId,E,Vols),
    sum(Vols,Vol).

tupleVolumeTotalAndCaminhoByServico(S , Vol/Caminho):-
    S = servico(_,_,_,_,_,_,Caminho,_),
    volumeTotalByServico(S,Vol).
