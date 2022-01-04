import termios
import tty
from pyswip import Prolog
from termcolor import cprint
import sys


def escolhe_opcoes(opcoes):
    opcao_atual = 0
    done = False

    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        while not done:
            for i in range(len(opcoes)):
                if i == opcao_atual:
                    cprint(" ❯", 'yellow', end='', attrs=['bold'])
                    cprint(f" {opcoes[i]}", attrs=['bold'])
                else:
                    print(f'   {opcoes[i]}')
                print('\r', end='', flush=True)

            ch = sys.stdin.read(1)
            if ch == '\x1b':
                ch2 = sys.stdin.read(1)
                if ch2 == '[':
                    ch3 = sys.stdin.read(1)
                    if ch3 == 'A':
                        opcao_atual = (opcao_atual - 1) % len(opcoes)
                    elif ch3 == 'B':
                        opcao_atual = (opcao_atual + 1) % len(opcoes)
                    elif ch3 == 'C':
                        done = True
                    elif ch3 == 'D':
                        done = True
            elif ch == '\r':
                done = True

            if not done:
                print(f'\x1b[{len(opcoes)}F', end='', flush=True)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)

    return opcao_atual

def mostra_tabela(lista):
    colunas = {}
    for i in lista:
        for coluna in i.keys():
            if coluna in colunas:
                colunas[coluna] = max(colunas[coluna], len(str(i[coluna])))
            else:
                colunas[coluna] = max(len(coluna), len(str(i[coluna])))
    # Imprimir cabeçalho
    s = ""
    for coluna in colunas.keys():
        s += f" {coluna.ljust(colunas[coluna])} "
    cprint(s, 'cyan', attrs=['bold'])
    # Imprimir colunas
    for linha in lista:
        s = ""
        for coluna in colunas.keys():
            s += f" {str(linha[coluna]).ljust(colunas[coluna])} "
        print(s)


prolog = Prolog()
prolog.consult("../trabalho.pl")

cprint("Bem vindo, o que deseja fazer?", 'green', attrs=["bold"])
op = escolhe_opcoes([
    "Estafeta mais ecológico",
    "Valor faturado",
    "Opção 3"
])

if op == 0:
    cprint("\nEstafeta mais ecológico\n", 'yellow', attrs=['bold'])
    mostra_tabela(list(prolog.query("estafetaMaisEcologico(estafeta(Id, Nome))")))
