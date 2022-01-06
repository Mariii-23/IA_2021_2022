from pyswip import Prolog
from termcolor import cprint
from fase1 import fase1_menu
from fase2 import fase2_menu
from ui import *

prolog = Prolog()
prolog.consult("../trabalho.pl")

def format_data(data):
    r = list(prolog.query("Dia/Mes/Ano/Hora/Minuto = " + data))[0]
    return f"{r['Dia']:02}/{r['Mes']:02}/{r['Ano']} {r['Hora']:02}:{r['Minuto']:02}"
def format_hora(hora):
    r = list(prolog.query("Hora/Minuto = " + hora))[0]
    return f"{r['Hora']:02}:{r['Minuto']:02}"

def base_de_dados():
    # Ver base de dados
    def ver_estafetas():
        mostra_tabela(list(prolog.query("estafeta(Id, Nome)")))
    def ver_encomendas():
        mostra_tabela(list(prolog.query("encomenda(Id, IdCliente, Peso, Volume, DiaPedido, Limite)")), options={
            'DiaPedido': ("Dia Pedido", format_data),
            'Limite': ("Hora Limite", format_hora)
        })
    def ver_servicos():
        mostra_tabela(list(prolog.query("servico(Id, Estafeta, Encomendas, Transporte, Dia, Classificacao, _, Custo)")), options={
            'Dia': ("Data", format_data)
        })
    def ver_ruas():
        mostra_tabela(list(prolog.query("rua(Rua, Freguesia, coordenada(X,Y))")))
    def ver_freguesias():
        mostra_tabela(list(prolog.query("freguesia(Freguesia)")))

    escolhe_opcoes({
        "Estafetas": ver_estafetas,
        "Encomendas": ver_encomendas,
        "Serviços": ver_servicos,
        "Ruas": ver_ruas,
        "Freguesias": ver_freguesias,
    })

if __name__ == "__main__":
    while True:
        cprint("Bem vindo, o que deseja fazer?", 'yellow', attrs=["bold"])
        escolhe_opcoes({
            'Queries Fase 1': lambda: fase1_menu(prolog),
            'Queries Fase 2': lambda: fase2_menu(prolog),
            'Consultar base de dados': base_de_dados,
            'Sair': exit
        })