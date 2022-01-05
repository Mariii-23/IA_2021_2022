import sys
import termios
import tty
from termcolor import cprint, colored

def escolhe_opcoes(opcoes):
    opcao_atual = 0
    done = False

    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        while not done:
            for i in range(len(opcoes.keys())):
                if i == opcao_atual:
                    cprint(" ❯", 'yellow', end='', attrs=['bold'])
                    cprint(f" {list(opcoes.keys())[i]}", attrs=['bold'])
                else:
                    print(f'   {list(opcoes.keys())[i]}')
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

    list(opcoes.values())[opcao_atual]()

def mostra_tabela(lista, filter_out=[], options={}):
    colunas = {}
    for i in lista:
        for coluna in i.keys():
            if coluna not in filter_out:
                column_name = coluna
                column_text = str(i[coluna])
                if coluna in options:
                    column_name = options[coluna][0]
                    column_text = str(options[coluna][1](column_text))
                if coluna in colunas:
                    colunas[coluna] = max(colunas[coluna], len(str(column_text)))
                else:
                    colunas[coluna] = max(len(column_name), len(column_text))
    # Imprimir cabeçalho
    s = ""
    for coluna in colunas.keys():
        column_name = coluna
        if coluna in options:
            column_name = options[coluna][0]
        s += f" {column_name.ljust(colunas[coluna])} "
    cprint(s, 'cyan', attrs=['bold'])
    # Imprimir colunas
    for linha in lista:
        s = ""
        for coluna in colunas.keys():
            column_text = str(linha[coluna])
            if coluna in options:
                column_text = str(options[coluna][1](column_text))

            s += f" {str(column_text).ljust(colunas[coluna])} "
        print(s)

def prompt(texto):
    prompt_text = colored(" ❯ ", 'yellow', attrs=['bold']) + colored(texto + ": ", attrs=['bold'])
    return input(prompt_text)