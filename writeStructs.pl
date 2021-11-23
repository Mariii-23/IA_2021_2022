writeTransporte(Stream):- transporte(Id,N,V,C,E),
                          write(Stream,'transporte('),
                          write(Stream,Id),
                          write(Stream,',\''), write(Stream,N), write(Stream,'\','),
                          write(Stream,V), write(Stream, ','),
                          write(Stream,C), write(Stream, ','),
                          write(Stream,C), write(Stream, ').\n'),
                        fail; true.


save :-
    open('ola.pl',write,Stream),
    write(Stream, '% transporte: #Id,Nome,Velocidade,Carga,Nivel_Ecologico -> {V,F}\n'),
    writeTransporte(Stream),
    close(Stream)
.
