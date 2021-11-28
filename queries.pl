
:-dynamic cargaEncomedaById/2.

% QUERY 2 - identificar que estafetas entregaram determinada(s) encomenda(s)
% a um  cliente
estafetasQueEntregaram(IdsEncomendas, R) :-  maplist(estafetaQueEntregou, IdsEncomendas , R).
estafetaQueEntregou(IdEncomenda, R) :-
    servico(_,IdEstafeta,IdEncomenda,_,_,_),
    findall(estafeta(IdEstafeta,Nome),
    estafeta(IdEstafeta,Nome),[R|_]).

% QUERY 4 - calcular o valor faturado pela Green Distribution num determinado
% dia.
% 1- Obter todos os serviços num dia
% 2- Ordernar lista por hora
% 3- Maplist para freguesia
% 4- Somar valores
valorFaturado(Dia/Mes/Ano,Valor) :-
    findall(servico(A,B,C,D,Dia/Mes/Ano/Hora/Minuto,F),
    servico(A,B,C,D,Dia/Mes/Ano/Hora/Minuto,F),L),
    predsort(compara_servico_por_data_com_duplicados,L,LSorted),
    servicos_para_custo(LSorted,'',Valor).
    

% QUERY 6 - calcular a classificação média de satisfação de cliente para
% um determinado estafeta
classificacaoEstafeta(IdEstafeta, Media) :-
    findall(C, servico(_,IdEstafeta,_,_,_,C), [X|L]), avg([X|L], Media).


avg(L, R) :- sum(L,Soma), length(L,Len), R is Soma/Len.

encomendaById(Id, X):-
    findall(encomenda(Id,Id1,P,V,D,L),encomenda(Id,Id1,P,V,D,L),[X|_]).
encomendaByIdCliente(Id,R):-
    findall(encomenda(Id1,Id,P,V,D,L),encomenda(Id1,Id,P,V,D,L),R).

clienteByIdEncomenda(Id, jG):- findall(Id1,encomenda(Id,Id1,_,_,_,_),[_|_]).

%% retirar repetidos
%% TODO nao esta a funcionar
clientesByIdEstafeta(Id,R):-
    findall(E,servico(_,Id,E,_,_,_),R2),
    findall(Id,encomenda(Id,_,_,_,_,_),R1),     % id de todas as encomendas feitas
    iguais(R1,R2,R3),
    maplist(clienteByIdEncomenda,R3,R)
.

clientesById(Id1,R):-
    findall(Id,encomenda(Id,Id1,_,_,_,_),R2), % ids de todas as encomendas desse Cliente
    findall(Id,servico(_,_,Id,_,_,_),R1),     % id de todas as encomendas feitas
    iguais(R1,R2,R3),
    maplist(cargaEncomendaById,R3,R).


servicoByIdEstafeta(Id,R):- findall(servico(Id1,Id,E,T,D,C),servico(Id1,Id,E,T,D,C),R).

cargaEncomendaById(Id,R):- encomenda(Id,_,R,_,_,_).
cargaEncomendaByIdCliente(Id,R):- findall(P,encomenda(_,Id,P,_,_,_),R).


cargaEstafeta(Id1,R):-
    findall(Id,servico(Id,Id1,_,_,_,_),R1), % buscar os ids das encomendas q ele realizou
    maplist(cargaEncomendaById,R1,R).

cargaEstafetaDia(Id1,D/M/Y,R):-
    findall(Id,servico(_,Id1,Id,_,D/M/Y/_,_),R1), % buscar os ids das encomendas q ele realizou nesse dia
    maplist(cargaEncomendaById,R1,R).

cargaCliente(Id1,R):-
    find_all(Id,encomenda(Id,Id1,_,_,_,_),R2), % ids de todas as encomendas desse Cliente
    find_all(Id,servico(_,_,Id,_,_,_),R1),     % id de todas as encomendas feitas
    iguais(R1,R2,R3),
    maplist(cargaEncomendaById,R3,R).

totalCargaEstafeta(Id,R):- cargaEstafeta(Id,L), sum(L,R).

totalCargaEstafetaDia(Id,D,R):- cargaEstafetaDia(Id,D,L), sum(L,R).

totalCargaEncomendaCliente(Id,R):- cargaEncomendaByIdCliente(Id,L), sum(L,R).

totalCargaServicoCliente(Id,R):- cargaCliente(Id,L), sum(L,R).


compara_servico_por_data_com_duplicados(
    >, servico(_,_,_,_,D1,_), servico(_,_,_,_,D2,_)) :-
        compara_data(>,D1,D2).
compara_servico_por_data_com_duplicados(
    >, servico(_,_,_,_,D1,_), servico(_,_,_,_,D2,_)) :-
        compara_data(=,D1,D2).
compara_servico_por_data_com_duplicados(
    <, servico(_,_,_,_,D1,_), servico(_,_,_,_,D2,_)) :-
        compara_data(<,D1,D2).

compara_data(Op,Data1,Data2) :-
    data_em_minutos(Data1,Minutos1),
    data_em_minutos(Data2,Minutos2),
    compare(Op,Minutos1,Minutos2).

data_em_minutos(D/M/Y/H/Min,Minutos) :-
    Minutos is Min + (60 * H) + (1440 * D) + (44640 * M) + (535680 * Y).

servicos_para_custo([],_,0).
servicos_para_custo([servico(A,B,IDEnc,C,D,E)|S],Ultima,Total) :-
    encomenda(IDEnc,IDCliente,_,_,_,_),
    cliente(IDCliente,_,morada(_,Freguesia)),
    Freguesia \= Ultima,
    freguesia(Freguesia,Custo,_),
    servicos_para_custo(S,Freguesia,Resto),
    Total is Custo + Resto.
servicos_para_custo([servico(A,B,IDEnc,C,D,E)|S],Ultima,Total) :-
    encomenda(IDEnc,IDCliente,_,_,_,_),
    cliente(IDCliente,_,morada(_,Freguesia)),
    Freguesia = Ultima,
    freguesia(Freguesia,Custo,_),
    servicos_para_custo(S,Freguesia,Total).