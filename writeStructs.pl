writeTransporte(Stream):- transporte(Id,N,V,C,E),
                          write(Stream,'transporte('),
                          write(Stream,Id),
                          write(Stream,',\''), write(Stream,N), write(Stream,'\','),
                          write(Stream,V), write(Stream, ','),
                          write(Stream,C), write(Stream, ','),
                          write(Stream,E), write(Stream, ').\n'),
                          fail; true.

writeEstafeta(Stream):- estafeta(Id,Nome),
                          write(Stream,'estafeta('),
                          write(Stream,Id), write(Stream, ','),
                          write(Stream,'\''), write(Stream,Nome), write(Stream,'\').\n'),
                          fail; true.


save :-
    open('ola.pl',write,Stream),
    write(Stream, '% transporte: Id, Nome, Velocidade Média, Carga Máxima, Nível Ecológico\n'),
    writeTransporte(Stream),
    write(Stream, '\n% estafeta: Id, Nome\n'),
    writeEstafeta(Stream),
    close(Stream)
.
