from pyswip import Prolog
from termcolor import cprint
from ui import *

prolog = Prolog()
prolog.consult("../trabalho.pl")

def format_data(data):
    r = list(prolog.query("Dia/Mes/Ano/Hora/Minuto = " + data))[0]
    return f"{r['Dia']:02}/{r['Mes']:02}/{r['Ano']} {r['Hora']:02}:{r['Minuto']:02}"
def format_hora(hora):
    r = list(prolog.query("Hora/Minuto = " + hora))[0]
    return f"{r['Hora']:02}:{r['Minuto']:02}"

def estafeta_ecologico():
    cprint("\nEstafeta mais ecológico\n", 'yellow', attrs=['bold'])
    mostra_tabela(list(prolog.query("estafetaMaisEcologico(estafeta(Id, Nome))")))

def estafetas_que_entregaram():
    ids = prompt("Introduza os Ids das encomendas")
    mostra_tabela(list(prolog.query("member(IdEncomenda, " + ids + "), estafetaQueEntregou(IdEncomenda, estafeta(Id, Nome))")), filter_out=['R'])

def clientes_servidos_por_estafeta():
    estafeta = prompt("ID do estafeta")
    mostra_tabela(list(prolog.query(f"clientesServidosIdEstafeta({estafeta}, R), member(cliente(Id, Nome, morada(Rua, Freguesia)), R)")), filter_out=['R'])

def valor_faturado():
    data = prompt("Introduza data (Dia/Mês/Ano/Hora/Minuto)") # convert isto para sem ser string
    result = (list(prolog.query("valorFaturado("+ data+",Valor)"))[0]['Valor'])
    print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Valor faturado: ", attrs=['bold']) + result)

def moradas_mais_frequentes():
    mostra_tabela(list(prolog.query(f"moradasMaisFrequentes(R), member((Ocorrencias, morada(Rua, Freguesia)), R)")), filter_out=['R'])

def ruas_mais_frequentes():
    mostra_tabela(list(prolog.query("ruasMaisFrequentes(R), member((Ocorrencias, Rua), R)")), filter_out=['R'])

def classificacao_estafeta():
    estafeta = prompt("ID do estafeta")
    result = (list(prolog.query(f"classificacaoEstafeta({estafeta}, R)")))[0]['R']
    print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Classificação: ", attrs=['bold']) + str(result))

def total_entregas_por_transporte():
    data_inicio = prompt("Data de início (Dia/Mês/Ano)")
    data_fim = prompt("Data de fim (Dia/Mês/Ano)")
    mostra_tabela(list(prolog.query(f"total_entregas_por_transporte({data_inicio}, {data_fim}, R)," +
        "member((Entregas, transporte(Id, Tipo, Velocidade, Carga, PontosEcologicos, MediaConsumo)), R)")), filter_out=['R'], options={
            'PontosEcologicos': ('Pontos Ecológicos', lambda x: x),
            'MediaConsumo': ('Média de Consumo', lambda x: x)
        })

def servicos_por_estafeta_entre():
    data_inicio = prompt("Data de início (Dia/Mês/Ano/Hora/Minuto)")
    data_fim = prompt("Data de fim (Dia/Mês/Ano/Hora/Minuto)")
    mostra_tabela(list(prolog.query(f"servicosPorEstafetaEntre({data_inicio}, {data_fim}, R), member((Servicos,estafeta(Id,Nome)),R)")), filter_out=['R'])

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
    cprint("Bem vindo, o que deseja fazer?", 'green', attrs=["bold"])
    escolhe_opcoes({
        "Estafeta mais ecológico": estafeta_ecologico,
        "Estafetas que entregaram": estafetas_que_entregaram,
        "Clientes servidos por estafeta": clientes_servidos_por_estafeta,
        "Valor faturado": valor_faturado,
        "Moradas mais frequentes": moradas_mais_frequentes,
        "Ruas mais frequentes": ruas_mais_frequentes,
        "Classificação de um estafeta": classificacao_estafeta,
        "Total de entregas por transporte": total_entregas_por_transporte,
        "Serviços por estafeta entre duas datas": servicos_por_estafeta_entre,
        "Ver base de dados": base_de_dados
    })
