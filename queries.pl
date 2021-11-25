
encomendaById(Id,R):- findall(encomenda(Id,C,P,V,D,L),encomenda(Id,C,P,V,D,L),R).
encomendaByIdCliente(Id,R):- findall(encomenda(Id1,Id,P,V,D,L),encomenda(Id1,Id,P,V,D,L),R).

servicoByIdEstafeta(Id,R):- findall(servico(Id1,Id,E,T,D,C),servico(Id1,Id,E,T,D,C),R).

cargaEncomendaById(Id,R):- encomenda(Id,_,R,_,_,_).
cargaEncomendaByIdCliente(Id,R):- findall(P,encomenda(_,Id,P,_,_,_),R).

cargaEncomendasId([],[]).
cargaEncomendasId([X|T],[C|R]):-
    cargaEncomendaById(X,C),
    cargaEncomendasId(T,R).

cargaEstafeta(Id1,R):-
    findall(Id,servico(Id,Id1,_,_,_,_),R1), % buscar os ids das encomendas q ele realizou
    cargaEncomendasId(R1,R).

cargaEstafetaDia(Id1,D/M/Y,R):-
    findall(Id,servico(_,Id1,Id,_,D/M/Y/_,_),R1), % buscar os ids das encomendas q ele realizou
    cargaEncomendasId(R1,R).

%cargaCliente(Id1,R):-
%    find_all(Id,servico(_,_,Id,_,_,_),R1),
%    find_all(Id,encomenda(Id,Id1,_,_,_,_),R2),
%    iguais(R1,R2,R3),
%    cargaEncomendasId(R3,R).

totalCargaEstafeta(Id,R):- cargaEstafeta(Id,L), sum(L,R).

totalCargaEstafetaDia(Id,D,R):- cargaEstafetaDia(Id,D,L), sum(L,R).

totalCargaEncomendaCliente(Id,R):- cargaEncomendaByIdCliente(Id,L), sum(L,R).

%totalCargaServicoCliente(Id,R):- cargaCliente(Id,L), sum(L,R).
