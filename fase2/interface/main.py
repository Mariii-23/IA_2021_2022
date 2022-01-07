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
    r = list(prolog.query("Dias/Horas = " + hora))[0]
    return f"{r['Dias']} dia(s) e {r['Horas']} hora(s)"

def base_de_dados():
    # Ver base de dados
    def ver_estafetas():
        mostra_tabela(list(prolog.query("estafeta(Id, Nome)")))
    def novo_estafeta():
        id_estafeta = prompt("ID do estafeta")
        nome = prompt("Nome do estafeta")
        if len(list(prolog.query(f"newEstafeta({id_estafeta}, '{nome}')"))) != 0:
            cprint("Estafeta adicionado", attrs=['bold'])
        else:
            cprint("Invariante falhou, estafeta não foi adicionado", 'red', attrs=['bold'])
    def apaga_estafeta():
        f = prompt("ID do estafeta")
        if len(list(prolog.query(f"removeEstafeta({f})."))) != 0:
            cprint("Estafeta apagado", attrs=['bold'])
        else:
            cprint("Invariante falhou, estafeta não foi apagado", 'red', attrs=['bold'])


    def ver_encomendas():
        mostra_tabela(list(prolog.query("encomenda(Id, IdCliente, Peso, Volume, DiaPedido, Limite)")), options={
            'DiaPedido': ("Dia Pedido", format_data),
            'Limite': ("Tempo Limite", format_hora)
        })
    def nova_encomenda():
        id_enc = prompt("ID da encomenda")
        id_cliente = prompt("ID do cliente")
        peso = prompt("Peso")
        volume = prompt("Volume")
        dia = prompt("Data (Formato Dia/Mês/Ano/Hora/Mês)")
        limite = prompt("Tempo limite (Formato Dias/Horas)")
        if len(list(prolog.query(f"newEncomenda({id_enc}, {id_cliente}, {peso}, {volume}, {dia}, {limite})."))) != 0:
            cprint("Encomenda adicionada", attrs=['bold'])
        else:
            cprint("Invariante falhou, encomenda não foi adicionada", 'red', attrs=['bold'])
    def apaga_encomenda():
        f = prompt("ID da encomenda")
        if len(list(prolog.query(f"removeEncomenda({f})."))) != 0:
            cprint("Encomenda apagada", attrs=['bold'])
        else:
            cprint("Invariante falhou, encomenda não foi apagada", 'red', attrs=['bold'])


    def ver_servicos():
        mostra_tabela(list(prolog.query("servico(Id, Estafeta, Encomendas, Transporte, Dia, Classificacao, _, Custo)")), options={
            'Dia': ("Data", format_data)
        })
    def ver_ruas():
        mostra_tabela(list(prolog.query("rua(Rua, Freguesia, coordenada(X,Y))")))
    def nova_rua():
        rua = prompt("Nome da rua")
        freguesia = prompt("Nome da freguesia")
        x = prompt("Coordenada X")
        y = prompt("Coordenada Y")
        if len(list(prolog.query(f"newRua('{rua}', '{freguesia}', coordenada({x}, {y}))."))) != 0:
            cprint("Rua adicionada", attrs=['bold'])
        else:
            cprint("Invariante falhou, rua não foi adicionada", 'red', attrs=['bold'])
    def apaga_rua():
        f = prompt("Nome da rua")
        if len(list(prolog.query(f"removeRua('{f}')."))) != 0:
            cprint("Rua apagada", attrs=['bold'])
        else:
            cprint("Invariante falhou, rua não foi apagada", 'red', attrs=['bold'])


    def ver_freguesias():
        mostra_tabela(list(prolog.query("freguesia(Freguesia)")))
    def nova_freguesia():
        f = prompt("Nome da freguesia")
        if len(list(prolog.query(f"newFreguesia('{f}')."))) != 0:
            cprint("Freguesia criada", attrs=['bold'])
        else:
            cprint("Invariante falhou, freguesia não foi criada", 'red', attrs=['bold'])
    def apaga_freguesia():
        f = prompt("Nome da freguesia")
        if len(list(prolog.query(f"removeFreguesia('{f}')."))) != 0:
            cprint("Freguesia apagada", attrs=['bold'])
        else:
            cprint("Invariante falhou, freguesia não foi apagada", 'red', attrs=['bold'])
    
    def ver_clientes():
        mostra_tabela(list(prolog.query("cliente(Id, Nome, morada(Rua, Freguesia))")))
    def novo_cliente():
        id_cliente = prompt("ID do cliente")
        nome = prompt("Nome do cliente")
        rua = prompt("Nome da rua")
        freguesia = prompt("Freguesia")
        if len(list(prolog.query(f"newCliente({id_cliente}, '{nome}', morada('{rua}', '{freguesia}'))"))) != 0:
            cprint("Cliente criado", attrs=['bold'])
        else:
            cprint("Invariante falhou, cliente não foi criado", 'red', attrs=['bold'])
    def apaga_cliente():
        id_cliente = prompt("ID do cliente")
        if len(list(prolog.query(f"removeCliente({id_cliente})."))) != 0:
            cprint("Cliente apagado", attrs=['bold'])
        else:
            cprint("Invariante falhou, cliente não foi apagado", 'red', attrs=['bold'])
    
    def ver_arestas():
        mostra_tabela(list(prolog.query("aresta(morada(Rua1,Freguesia1),morada(Rua2,Freguesia2),Custo,Distancia)")))
    def nova_aresta():
        rua1 = prompt("Nome da rua 1")
        rua2 = prompt("Nome da rua 2")
        custo = prompt("Custo")
        distancia = prompt("Distância")
        if len(list(prolog.query(f"newAresta(morada('{rua1}',_),morada('{rua2}',_),{custo},{distancia})"))) != 0:
            cprint("Aresta criada", attrs=['bold'])
        else:
            cprint("Invariante falhou, aresta não foi criada", 'red', attrs=['bold'])
    
    def guarda_bd():
        ficheiro = prompt("Ficheiro")
        if len(list(prolog.query(f"saveIn('{ficheiro}')"))) != 0:
            cprint("Base de dados guardada em " + ficheiro, attrs=['bold'])
        else:
            cprint("Não foi possível guardar", 'red', attrs=['bold'])


    escolhe_opcoes({
        "Ver estafetas": ver_estafetas,
        "Novo estafeta": novo_estafeta,
        "Apagar um estafeta": apaga_estafeta,

        "Ver encomendas": ver_encomendas,
        "Nova encomenda": nova_encomenda,
        "Apagar uma encomenda": apaga_encomenda,

        "Ver serviços": ver_servicos,

        "Ver ruas": ver_ruas,
        "Nova rua": nova_rua,
        "Apagar uma rua": apaga_rua,

        "Ver freguesias": ver_freguesias,
        "Nova freguesia": nova_freguesia,
        "Apagar uma freguesia": apaga_freguesia,

        "Ver clientes": ver_clientes,
        "Novo cliente": novo_cliente,
        "Apagar um cliente": apaga_cliente,

        "Ver arestas": ver_arestas,
        "Nova aresta": nova_aresta,

        "Guardar base de dados": guarda_bd,

        "Voltar": lambda: None
    })

if __name__ == "__main__":
    while True:
        cprint("Bem vindo, o que deseja fazer?", 'yellow', attrs=["bold"])
        escolhe_opcoes({
            'Queries Fase 1': lambda: fase1_menu(prolog),
            'Queries Fase 2': lambda: fase2_menu(prolog),
            'Consultar e modificar base de dados': base_de_dados,
            'Sair': exit
        })