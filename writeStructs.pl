writeFreguesia(Stream):- freguesia(Nome,Custo,Tempo),
                          write(Stream,'freguesia('),
                          write(Stream,'\''), write(Stream,Nome), write(Stream,'\','),
                          write(Stream,Custo), write(Stream, ','),
                          write(Stream,Tempo), write(Stream, ').\n'),
                          fail; true
.

writeRua(Stream):- rua(Nome,Freguesia),
                          write(Stream,'rua('),
                          write(Stream,'\''), write(Stream,Nome), write(Stream,'\','),
                          write(Stream,'\''), write(Stream,Freguesia), write(Stream,'\').\n'),
                          fail; true
.

writeTransporte(Stream):- transporte(Id,N,V,C,E),
                          write(Stream,'transporte('),
                          write(Stream,Id),
                          write(Stream,',\''), write(Stream,N), write(Stream,'\','),
                          write(Stream,V), write(Stream, ','),
                          write(Stream,C), write(Stream, ','),
                          write(Stream,E), write(Stream, ').\n'),
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
                          %write(Stream,'\''),write(Stream,R), write(Stream,'\'/'),
                          %write(Stream,E), write(Stream, ').\n'),
                          fail; true
.

writeServico(Stream):- servico(Id,Es,E,T,D,C),
                          write(Stream,'servico('),
                          write(Stream,Id), write(Stream, ','),
                          write(Stream,Es), write(Stream, ','),
                          write(Stream,E), write(Stream, ','),
                          write(Stream,T), write(Stream, ','),
                          write(Stream,D), write(Stream, ','),
                          write(Stream,C), write(Stream, ').\n'),
                          fail; true
.

saveIn(X) :-
    open(X,write,Stream),
    write(Stream, '\n% freguesia: Nome, Custo, Tempo: H/M -> {V,F}\n'),
    writeFreguesia(Stream),
    write(Stream, '\n% rua: Nome, Nome da Freguesia -> {V,F}\n'),
    writeRua(Stream),
    write(Stream, '\n% transporte: Id, Nome, Velocidade Média, Carga Máxima, Nível Ecológico -> {V,F}\n'),
    writeTransporte(Stream),
    write(Stream, '\n% estafeta: Id, Nome -> {V,F}\n'),
    writeEstafeta(Stream),
    write(Stream, '\n% ranking: Id Estafeta, Classificação -> {V,F}\n'),
    writeRanking(Stream),
    write(Stream, '\n% cliente: Id, Nome, morada(Nome da Rua,Nome da Freguesia) -> {V,F}\n'),
    writeCliente(Stream),
    write(Stream, '\n% encomeda: Id, Id_Cliente, Peso, Volume, DiaPedido: D/M/Y/H/M, Limite: D/H, -> {V,F}\n'),
    writeEncomenda(Stream),
    write(Stream, '\n% servico: Id, Id_estafeta, Id_encomenda, Id_transporte, DiaEntrega: D/M/Y/H/M, Classificacao -> {V,F}\n'),
    writeServico(Stream),
    close(Stream)
.

save:- saveIn('ola.pl').
