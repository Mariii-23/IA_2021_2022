
:-dynamic cargaEncomedaById/2.

% QUERY PEDIDA - identificar que estafetas entregaram determinada(s) encomenda(s) a um  cliente
estafetasQueEntregaram(IdsEncomendas, R) :-  maplist(estafetaQueEntregou, IdsEncomendas , R).
estafetaQueEntregou(IdEncomenda, R) :-
    servico(_,IdEstafeta,IdEncomenda,_,_,_),
    findall(estafeta(IdEstafeta,Nome),
    estafeta(IdEstafeta,Nome),[R|_]).

% QUERY PEDIDA - calcular a classificação média de satisfação de cliente para um determinado estafeta;
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
