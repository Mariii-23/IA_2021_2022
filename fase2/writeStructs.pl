writeFreguesia(Stream):- freguesia(Nome),
                          write(Stream,'freguesia('),
                          write(Stream,'\''), write(Stream,Nome), write(Stream,'\').\n'),
                          fail; true
.

writeRua(Stream):- rua(Nome,Freguesia,Coord),
                          write(Stream,'rua('),
                          write(Stream,'\''), write(Stream,Nome), write(Stream,'\','),
                          write(Stream,'\''), write(Stream,Freguesia), write(Stream,'\','),
                          write(Stream,Coord), write(Stream,').\n'),
                          fail; true
.

writeMorada(morada(A,B),Stream):-
                          write(Stream,'morada('),
                          write(Stream,'\''), write(Stream,A), write(Stream,'\',\''),
                          write(Stream,B), write(Stream,'\')'),
                          fail; true
.

writeAresta(Stream):- aresta(A,B,Custo,Distancia),
                          write(Stream,'aresta('),
                          writeMorada(A,Stream),
                          write(Stream,','),
                          writeMorada(B,Stream),
                          write(Stream,','),
                          write(Stream,Custo),
                          write(Stream,','),
                          write(Stream,Distancia), write(Stream, ').\n'),
                          fail; true
.

writeCentroDistribuicao(Stream):- centroDistribuicao(morada(A,B)),
                          write(Stream,'centroDistribuicao('),
                          write(Stream,'morada('),
                          write(Stream,'\''), write(Stream,A), write(Stream,'\',\''),
                          write(Stream,B), write(Stream,'\')).\n'),
                          fail; true
.

writeTransporte(Stream):- transporte(Id,N,V,C,E,Q),
                          write(Stream,'transporte('),
                          write(Stream,Id),
                          write(Stream,',\''), write(Stream,N), write(Stream,'\','),
                          write(Stream,V), write(Stream, ','),
                          write(Stream,C), write(Stream, ','),
                          write(Stream,E), write(Stream, ','),
                          write(Stream,Q), write(Stream, ').\n'),
                          fail; true
.

writeEstafeta(Stream):- estafeta(Id,Nome),
                          write(Stream,'estafeta('),
                          write(Stream,Id), write(Stream, ','),
                          write(Stream,'\''), write(Stream,Nome), write(Stream,'\').\n'),
                          fail; true
.

writeRanking(Stream):- ranking(Id,Nota),
                          write(Stream,'ranking('),
                          write(Stream,Id), write(Stream, ','),
                          write(Stream,Nota), write(Stream, ').\n'),
                          fail; true
.

writeCliente(Stream):- cliente(Id,Nome,morada(R,F)),
                          write(Stream,'cliente('),
                          write(Stream,Id), write(Stream, ','),
                          write(Stream,'\''), write(Stream,Nome), write(Stream,'\','),
                          write(Stream,'morada(\''),write(Stream,R), write(Stream,'\','),
                          write(Stream,'\''),write(Stream,F), write(Stream,'\')).\n'),
                          fail; true
.

writeEncomenda(Stream):- encomenda(Id, C, P,V,D,L),
                          write(Stream,'encomenda('),
                          write(Stream,Id), write(Stream, ','),
                          write(Stream,C), write(Stream, ','),
                          write(Stream,P), write(Stream, ','),
                          write(Stream,V), write(Stream, ','),
                          write(Stream,D), write(Stream, ','),
                          write(Stream,L), write(Stream, ').\n'),
                          fail; true
.

writeCaminho([X],Stream):-
    writeMorada(X,Stream),
    fail; true.
writeCaminho([X,C|T],Stream):-
    writeMorada(X,Stream),write(Stream, ','),
    writeCaminho([C|T],Stream),
    fail; true.
writeCaminho([],_):-
    fail; true.

writeServico(Stream):- servico(Id,Es,E,T,D,C,Cam,Custo),
                          write(Stream,'servico('),
                          write(Stream,Id), write(Stream, ','),
                          write(Stream,Es), write(Stream, ','),
                          write(Stream,E), write(Stream, ','),
                          write(Stream,T), write(Stream, ','),
                          write(Stream,D), write(Stream, ','),
                          write(Stream,C), write(Stream, ','),
                          write(Stream, '['), writeCaminho(Cam,Stream), write(Stream, '],'),
                          write(Stream,Custo), write(Stream, ').\n'),
                          fail; true
.

saveIn(X) :-
    open(X,write,Stream),
    write(Stream, '% freguesia: Nome -> {V,F}\n'),
    writeFreguesia(Stream),
    write(Stream, '\n% rua: Nome, Nome da Freguesia, Coordenada -> {V,F}\n'),
    writeRua(Stream),
    write(Stream, '\n% aresta: Morada, Morada, Custo, Distancia Real -> {V,F}\n'),
    writeAresta(Stream),
    write(Stream, '\n% centroDistribuicao: Morada -> {V,F}\n'),
    writeCentroDistribuicao(Stream),
    write(Stream, '\n% transporte: Id, Nome, Velocidade M??dia, Carga M??xima, N??vel Ecol??gico, Consumo Medio -> {V,F}\n'),
    writeTransporte(Stream),
    write(Stream, '\n% estafeta: Id, Nome -> {V,F}\n'),
    writeEstafeta(Stream),
    write(Stream, '\n% ranking: Id Estafeta, Classifica????o -> {V,F}\n'),
    writeRanking(Stream),
    write(Stream, '\n% cliente: Id, Nome, morada(Nome da Rua,Nome da Freguesia) -> {V,F}\n'),
    writeCliente(Stream),
    write(Stream, '\n% encomeda: Id, Id_Cliente, Peso, Volume, DiaPedido: D/M/Y/H/M, Limite: D/H, -> {V,F}\n'),
    writeEncomenda(Stream),
    write(Stream, '\n% servico: Id, Id_estafeta, Id_encomenda, Id_transporte, DiaEntrega: D/M/Y/H/M, Classificacao, Caminho, Custo -> {V,F}\n'),
    writeServico(Stream),
    close(Stream)
.

save:- saveIn('base_dados.pl').
