%% FREGUESIA
freguesiaByName(N,R):- findall(freguesia(N,C,T),freguesia(N,C,T),[R|_]).

freguesiaByCusto(C,R):- findall(freguesia(N,C,T),freguesia(N,C,T),R).

freguesiaByTempo(T,R):- findall(freguesia(N,C,T),freguesia(N,C,T),R).

%% RUA
ruaByName(N,R):- findall(rua(N,F),rua(N,F),[R|_]).

ruaByNomeFreguesia(N,R):- findall(rua(N,F),rua(N,F),R).

ruaByFreguesia(freguesia(F,_,_),R):- findall(rua(N,F),rua(N,F),R).

%% TRANSPORTE
transporteById(Id,T):-
    findall(transporte(Id,N,V,C,P), transporte(Id,N,V,C,P),[T|_]).

transporteByName(N,T):-
    findall(transporte(Id,N,V,C,P), transporte(Id,N,V,C,P),T).

transporteByVelocidade(V,T):-
    findall(transporte(Id,N,V,C,P), transporte(Id,N,V,C,P),T).

transporteByCarga(C,T):-
    findall(transporte(Id,N,V,C,P), transporte(Id,N,V,C,P),T).

transporteByPontosEcologicos(P,T):-
    findall(transporte(Id,N,V,C,P), transporte(Id,N,V,C,P),T).

%
nivelEcologicoByIdTransporte(Id,E):-
    transporte(Id,_,_,_,E).

transportesEcologicos(R):-
    findall(transporte(I,N,V,C,P), (transporte(I,N,V,C,P), P > 0),R).

%% ESTAFETA
estafetaById(Id,E):-
    findall(estafeta(Id,N),estafeta(Id,N),[E|_]).

estafetaByNome(N,E):-
    findall(estafeta(Id,N),estafeta(Id,N),[E|_]).

%% RANKING
rankingByIdEstafeta(Id,R):- findall(ranking(Id,C),ranking(Id,C),[R|_]).

rankingByClassificacao(C,R):- findall(ranking(Id,C),ranking(Id,C),R).


%%%% CLIENTE
clienteById(Id, X):-
    findall(cliente(Id,N,M),cliente(Id,N,M),[X|_]).

clienteByNome(N, R):-
    findall(cliente(Id,N,M),cliente(Id,N,M),R).

clienteByMorada(M, R):-
    findall(cliente(Id,N,M),cliente(Id,N,M),R).

%
clienteByIdEncomenda(Id, R):-
    idClienteByIdEncomenda(Id, X),
    clienteById(X,R).

idClienteByIdEncomenda(Id, X):- findall(Id1,encomenda(Id,Id1,_,_,_,_),[X|_]).

clienteByIdServico(Id,C):-
    servico(Id,Id1,_,_,_,_),
    encomenda(Id1,CId,_,_,_,_),
    clienteById(CId,C).

%% ENCOMENDA
encomendaById(Id, X):-
    findall(encomenda(Id,Id1,P,V,D,L),encomenda(Id,Id1,P,V,D,L),[X|_]).

encomendaByIdCliente(Id,R):-
    findall(encomenda(Id1,Id,P,V,D,L),encomenda(Id1,Id,P,V,D,L),R).

encomendaByPeso(P,R):-
    findall(encomenda(Id1,Id,P,V,D,L),encomenda(Id1,Id,P,V,D,L),R).

encomendaByVolume(V,R):-
    findall(encomenda(Id1,Id,P,V,D,L),encomenda(Id1,Id,P,V,D,L),R).

encomendaByDiaDePedido(D/M/Y,R):-
    findall(encomenda(Id1,Id,P,V,D/M/Y/H/Min,L),
            encomenda(Id1,Id,P,V,D/M/Y/H/Min,L),R).

encomendaByDiaDePedidoCompelto(D,R):-
    findall(encomenda(Id1,Id,P,V,D,L),encomenda(Id1,Id,P,V,D,L),R).

encomendaByLimite(L,R):-
    findall(encomenda(Id1,Id,P,V,D,L),encomenda(Id1,Id,P,V,D,L),R).

%%% SERVICOS
servicoById(Id,R):-
    findall(servico(Id,Id1,E,T,D,C),servico(Id,Id1,E,T,D,C),[R|_]).

servicoByIdEstafeta(Id,R):-
    findall(servico(Id1,Id,E,T,D,C),servico(Id1,Id,E,T,D,C),R).

servicoByIdEncomenda(E,R):-
    findall(servico(Id,Id1,E,T,D,C),servico(Id,Id1,E,T,D,C),R).

servicoByIdTransporte(T,R):-
    findall(servico(Id,Id1,E,T,D,C),servico(Id,Id1,E,T,D,C),R).

servicoByDiaEntregaCompleto(D,R):-
    findall(servico(Id,Id1,E,T,D,C),servico(Id,Id1,E,T,D,C),R).

servicoByDiaEntrega(D/M/Y,R):-
    findall(servico(Id,Id1,E,T,D/M/Y/H/Min,C),
            servico(Id,Id1,E,T,D/M/Y/H/Min,C),R).

servicoByClassificacao(C,R):-
    findall(servico(Id,Id1,E,T,D,C),servico(Id,Id1,E,T,D,C),R).
