import termios
import tty
from pyswip import Prolog
from termcolor import cprint, colored
import sys

prolog = Prolog()
prolog.consult("../trabalho.pl")

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

def format_data(data):
    r = list(prolog.query("Dia/Mes/Ano/Hora/Minuto = " + data))[0]
    return f"{r['Dia']:02}/{r['Mes']:02}/{r['Ano']} {r['Hora']:02}:{r['Minuto']:02}"
def format_hora(hora):
    r = list(prolog.query("Hora/Minuto = " + hora))[0]
    return f"{r['Hora']:02}:{r['Minuto']:02}"

if __name__ == "__main__":
    cprint("Bem vindo, o que deseja fazer?", 'green', attrs=["bold"])
    op = escolhe_opcoes([
        "Estafeta mais ecológico",
        "Estafetas que entregaram",
        "Valor faturado",
        "Ver base de dados"
    ])

    if op == 0:
        cprint("\nEstafeta mais ecológico\n", 'yellow', attrs=['bold'])
        mostra_tabela(list(prolog.query("estafetaMaisEcologico(estafeta(Id, Nome))")))
    elif op == 1:
        # por uma forma mais fixe de pedir a lista de valores
        ids = prompt("Introduza os Ids das encomendas")
        mostra_tabela(list(prolog.query("member(IdEncomenda, " + ids + "), estafetaQueEntregou(IdEncomenda, estafeta(Id, Nome))")), filter_out=['R'])
    elif op == 2:
        data = prompt("Introduza data") # convert isto para sem ser string

        result = (list(prolog.query("valorFaturado("+ data+",Valor)"))[0]['Valor'])
        print("Valor Faturado: ", result)
    elif op == 3:
        # Ver base de dados
        op = escolhe_opcoes([
            "Estafetas",
            "Encomendas",
            "Ruas",
            "Freguesias",
        ])

        if op == 0:
            mostra_tabela(list(prolog.query("estafeta(Id, Nome)")))
        elif op == 1:
            mostra_tabela(list(prolog.query("encomenda(Id, IdCliente, Peso, Volume, DiaPedido, Limite)")), options={
                'DiaPedido': ("Dia Pedido", format_data),
                'Limite': ("Hora Limite", format_hora)
            })
