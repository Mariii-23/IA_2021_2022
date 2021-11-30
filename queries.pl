:- dynamic cargaEncomedaById/2.

% QUERY 1 - dentificar o estafeta que utilizou mais vezes um meio de
% transporte mais ecológico

estafetasEcologicos(R):-
    transportesEcologicos(T),
    maplist(tupleEstafetaMaisUtilizouTransporte,T,R).

% QUERY 2 - identificar que estafetas entregaram determinada(s) encomenda(s)
% a um  cliente
estafetasQueEntregaram(IdsEncomendas, R) :-  maplist(estafetaQueEntregou, IdsEncomendas , R).
estafetaQueEntregou(IdEncomenda, R) :-
    servico(_,IdEstafeta,IdEncomenda,_,_,_),
    findall(estafeta(IdEstafeta,Nome),
    estafeta(IdEstafeta,Nome),[R|_]).

% QUERY 3 - identificar os clientes servidos por um determinado estafeta
clientesServidosIdEstafeta(Id,C):-
    estafetaById(Id,_), % verificar se existe estafeta
    findall(IdEncomenda,servico(_,Id,IdEncomenda,_,_,_),L),
    maplist(clienteByIdEncomenda,L,C_),
    eliminaRepetidos(C_,C)
.

% QUERY 4 - calcular o valor faturado pela Green Distribution num determinado
% dia.
valorFaturado(Dia/Mes/Ano,Valor) :-
    findall(servico(A,B,C,D,Dia/Mes/Ano/Hora/Minuto,F),
    servico(A,B,C,D,Dia/Mes/Ano/Hora/Minuto,F),L),
    servicos_para_custo(L,Valor).

servicos_para_custo([],0).
servicos_para_custo([servico(_,_,IDEnc,_,_,_)|S],Total) :-
    encomenda(IDEnc,IDCliente,_,_,_,_),
    cliente(IDCliente,_,morada(_,Freguesia)),
    freguesia(Freguesia,Custo,_),
    servicos_para_custo(S,Resto),
    Total is Custo + Resto.


% QUERY 6 - calcular a classificação média de satisfação de cliente para
% um determinado estafeta
classificacaoEstafeta(IdEstafeta, Media) :-
    findall(C, servico(_,IdEstafeta,_,_,_,C), [X|L]), avg([X|L], Media).

% QUERY 7 - identificar o número total de entregas pelos diferentes meios de
% transporte, num determinado intervalo de tempo

total_entregas_por_transporte(Init,Fin,Freq) :-
    findall(servico(A,B,C,D,E,F),
            (servico(A,B,C,D,E,F),isBetween(E,Init,Fin)),
            Servicos),
            servicos_para_transportes(Servicos, Transportes),
            freq(Transportes,[],Freq).

servicos_para_transportes([],[]).
servicos_para_transportes([servico(_,_,_,IdTrs,_,_)|Ss],[transporte(IdTrs,A,B,C,D)|Ts]) :-
    transporte(IdTrs,A,B,C,D),
    servicos_para_transportes(Ss,Ts).
    
    

% QUERY 9 - calcular o número de encomendas entregues e não entregues
% pela Green Distribution, num determinado período de tempo
% INCOMPLETA

todasEncomendas(I,F,Entregues,NaoEntregues) :- encomendasEntregues(I,F,Entregues),encomendasNaoEntregues(Entregues,NaoEntregues).

encomendasEntregues(I,F,R) :-
    findall(E,
    foiEntregueEntre(E,I,F),
    R).

encomendasNaoEntregues(Entregues,R) :- findall(encomenda(Id,A,B,C,D,E),
    encomenda(Id,A,B,C,D,E), Todas), subtract(Todas,Entregues,R).

foiEntregueEntre(encomenda(Id,A,B,C,D,E), I,F) :-
    encomenda(Id,A,B,C,D,E), servico(_,_,Id,_,Data,_),
    isBetween(Data,I,F).

isBetween(D/Mon/Y/H/Min, D1/Mon1/Y1/H1/Min1, D2/Mon2/Y2/H2/Min2)
    :- Y/Mon/D/H/Min @< Y2/Mon2/D2/H2/Min2, Y/Mon/D/H/Min @> Y1/Mon1/D1/H1/Min1.

% QUERY 10 - calcular o peso total transportado por estafeta num determinado dia
pesoTotalByEstafetaNoDia(estafeta(Id,Nome),D, R) :-
    estafeta(Id,Nome), % verificar se o estafeta é válido
    totalCargaEstafetaDia(Id,D,R)
.

%% TRANSPORTE
transporteById(Id,T):- findall(transporte(Id,N,V,C,P),transporte(Id,N,V,C,P),[T|_]).

nivelEcologicoByIdTransporte(Id,E):- transporte(Id,_,_,_,E).

onlyEcologicos([],[]).
onlyEcologicos([transporte(I,N,V,C,P)|T], [transporte(I,N,V,C,P)|R]):-
    P>0,
    onlyEcologicos(T,R),!
.
onlyEcologicos([transporte(_,_,_,_,P)|T], R):- P<1,onlyEcologicos(T,R).

transportesEcologicos(R):-
    findall(transporte(I,N,V,C,P), transporte(I,N,V,C,P),T),
    onlyEcologicos(T,R)
.

%% ESTAFETA
estafetaById(Id,E):- findall(estafeta(Id,N),estafeta(Id,N),[E|_]).

%% pode ter repetidos
estafetasIdByIdTrasnporte(Id,E):-
    findall(Id1,servico(_,Id1,_,Id,_,_),E).

estafetaMaisUtilizouIdTransporte(Id,E):-
    findall(Id1,servico(_,Id1,_,Id,_,_),R),
    maxRepeated(R, (IdE,_)),
    estafetaById(IdE,E),!
.

estafetaMaisUtilizouTransporte(transporte(Id,_,_,_,_),E):-
    estafetaMaisUtilizouIdTransporte(Id,E)
.

tupleEstafetaMaisUtilizouTransporte(E, (E,R) ):-
    estafetaMaisUtilizouTransporte(E,R).

%%%%% ENCOMENDA
encomendaById(Id, X):-
    findall(encomenda(Id,Id1,P,V,D,L),encomenda(Id,Id1,P,V,D,L),[X|_]).
% encomenda by id cliente
encomendaByIdCliente(Id,R):-
    findall(encomenda(Id1,Id,P,V,D,L),encomenda(Id1,Id,P,V,D,L),R).

%% clienteByIdEncomenda(Id, jG):- findall(Id1,encomenda(Id,Id1,_,_,_,_),[_|_]).
%%%% CLIENTE
clienteById(Id, X):-
    findall(cliente(Id,N,M),cliente(Id,N,M),[X|_]).

clienteByIdEncomenda(Id, R):-
    idClienteByIdEncomenda(Id, X),
    clienteById(X,R).

idClienteByIdEncomenda(Id, X):- findall(Id1,encomenda(Id,Id1,_,_,_,_),[X|_]).

clienteByIdServico(Id,C):-
    servico(Id,Id1,_,_,_,_),
    encomenda(Id1,CId,_,_,_,_),
    clienteById(CId,C).

%% retirar repetidos
%% TODO nao esta a funcionar
clientesByIdEstafeta(Id,R):-
    findall(E,servico(_,Id,E,_,_,_),R2),
    findall(Id,encomenda(Id,_,_,_,_,_),R1),     % id de todas as encomendas feitas
    iguais(R1,R2,R3),
    maplist(clienteByIdEncomenda,R3,R)
.


%%% SERVICOS
servicoById(Id,R):- findall(servico(Id,Id1,E,T,D,C),servico(Id,Id1,E,T,D,C),[R|_]).

servicoByIdEstafeta(Id,R):- findall(servico(Id1,Id,E,T,D,C),servico(Id1,Id,E,T,D,C),R).


%% CARGA
cargaEncomendaById(Id,R):- findall(C,encomenda(Id,_,C,_,_,_),[R|_]).
cargaEncomendaByIdCliente(Id,R):- findall(P,encomenda(_,Id,P,_,_,_),R).

cargaEstafeta(Id1,R):-
    findall(Id,servico(Id,Id1,_,_,_,_),R1), % buscar os ids das encomendas q ele realizou
    maplist(cargaEncomendaById,R1,R).

cargaEstafetaDia(Id1,D/M/Y,R):-
    findall(Id,servico(_,Id1,Id,_,D/M/Y/_/_,_),R1), % buscar os ids das encomendas q ele realizou nesse dia
    maplist(cargaEncomendaById,R1,R).

cargaCliente(Id1,R):-
    findall(Id,encomenda(Id,Id1,_,_,_,_),R2), % ids de todas as encomendas desse Cliente
    findall(Id,servico(_,_,Id,_,_,_),R1),     % id de todas as encomendas feitas
    iguais(R1,R2,R3),
    maplist(cargaEncomendaById,R3,R).

%% Carga TOTAL
totalCargaEstafeta(Id,R):- cargaEstafeta(Id,L), sum(L,R).

totalCargaEstafetaDia(Id,D,R):- cargaEstafetaDia(Id,D,L), sum(L,R).

totalCargaEncomendaCliente(Id,R):- cargaEncomendaByIdCliente(Id,L), sum(L,R).

totalCargaServicoCliente(Id,R):- cargaCliente(Id,L), sum(L,R).

% compara_servico_por_data_com_duplicados(
%     >, servico(_,_,_,_,D1,_), servico(_,_,_,_,D2,_)) :-
%         compara_data(>,D1,D2).
% compara_servico_por_data_com_duplicados(
%     >, servico(_,_,_,_,D1,_), servico(_,_,_,_,D2,_)) :-
%         compara_data(=,D1,D2).
% compara_servico_por_data_com_duplicados(
%     <, servico(_,_,_,_,D1,_), servico(_,_,_,_,D2,_)) :-
%         compara_data(<,D1,D2).
% 
% compara_data(Op,Data1,Data2) :-
%     data_em_minutos(Data1,Minutos1),
%     data_em_minutos(Data2,Minutos2),
%     compare(Op,Minutos1,Minutos2).
% 
% data_em_minutos(D/M/Y/H/Min,Minutos) :-
%     Minutos is Min + (60 * H) + (1440 * D) + (44640 * M) + (535680 * Y).

%% Query 5
getRua(morada(Rua,_), Rua).
getFreguesia(morada(_,Freguesia), Freguesia).

moradasEncomendas(R) :-
    findall(CId, encomenda(_,CId,_,_,_,_), _),
    findall(Morada, cliente(CId,_,Morada), R).

ruasEncomendas(R) :-
    moradasEncomendas(L),
    maplist(getRua, L, R).

freguesiasEncomendas(R) :-
    moradasEncomendas(L),
    maplist(getFreguesia, L, R).

% Como usar: freq([1,2,3,1,2,1,3,4], [], R).
freq([], R, R).
freq([X | Xs], Temp, R) :-
    select((N, X), Temp, Outros), % Encontra o elemento X e o seu numero de ocorrencias
    M is N + 1,
    freq(Xs, [ (M, X) | Outros], R).
freq([X | Xs], Temp, R) :-
    not(select((_, X), Temp, _)),
    freq(Xs, [ (1, X) | Temp], R).

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

%% Query 8
getEstafeta(servico(_,Id,_,_,_,_), R) :-
    estafetaById(Id, R).

% Trocamos a ordem dos argumentos do isBetween para funcionar como filtro
isBetweenFilter(I, F, servico(_,_,_,_,Data,_)) :- isBetween(Data, I, F).

servicosEntre(I, F, Servicos) :-
    findall(
        servico(Id,IdE,IdEnc,IdTrans,Data,Class),
        servico(Id,IdE,IdEnc,IdTrans,Data,Class),
        Lista),
    include(isBetweenFilter(I, F), Lista, Servicos).

servicosPorEstafetaEntre(I, F, R) :-
    servicosEntre(I, F, Servicos),
    maplist(getEstafeta, Servicos, Estafetas),
    freq(Estafetas, [], Freqs),
    sort(1, @>=, Freqs, R).

