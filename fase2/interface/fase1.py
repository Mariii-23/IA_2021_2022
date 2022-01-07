from ui import *
from termcolor import cprint, colored

def fase1_menu(prolog):
    def format_data(data):
        r = list(prolog.query("Dia/Mes/Ano/Hora/Minuto = " + data))[0]
        return f"{r['Dia']:02}/{r['Mes']:02}/{r['Ano']} {r['Hora']:02}:{r['Minuto']:02}"
    def format_hora(hora):
        r = list(prolog.query("Hora/Minuto = " + hora))[0]
        return f"{r['Hora']:02}:{r['Minuto']:02}"

    def estafeta_ecologico():
        mostra_tabela(list(prolog.query("estafetaMaisEcologico(estafeta(Id, Nome))")))

    def estafetas_que_entregaram():
        ids = prompt("Introduza os ids das encomendas (formato [x, y, ...])")
        mostra_tabela(list(prolog.query("member(Encomenda, " + ids + "), estafetaQueEntregou(Encomenda, estafeta(Id, Nome))")), filter_out=['R'])

    def clientes_servidos_por_estafeta():
        estafeta = prompt("ID do estafeta")
        mostra_tabela(list(prolog.query(f"clientesServidosIdEstafeta({estafeta}, R), member(cliente(Id, Nome, morada(Rua, Freguesia)), R)")), filter_out=['R'])

    def valor_faturado():
        data = prompt("Introduza data (Dia/Mês/Ano)") # convert isto para sem ser string
        result = (list(prolog.query("valorFaturado("+ data+",Valor)"))[0]['Valor'])
        print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Valor faturado: ", attrs=['bold']) + str(result))

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

    def todas_encomendas_entre():
        data_inicio = prompt("Data de início (Dia/Mês/Ano/Hora/Minuto)")
        data_fim = prompt("Data de fim (Dia/Mês/Ano/Hora/Minuto)")
        encomendas = (list(prolog.query(f"todasEncomendas({data_inicio}, {data_fim}, Entregues, NaoEntregues)")))[0]
        l_entregues = f"[{','.join(list(map(lambda x: x.value, encomendas['Entregues'])))}]"
        l_naoentregues = f"[{','.join(list(map(lambda x: x.value, encomendas['NaoEntregues'])))}]"
        entregues = list(prolog.query(f"member(encomenda(Id,Cliente,Peso,Volume,Data,Limite), {l_entregues})"))
        naoentregues = list(prolog.query(f"member(encomenda(Id,Cliente,Peso,Volume,Data,Limite), {l_naoentregues})"))

        cprint(" Entregues:", 'yellow', attrs=['bold'])
        mostra_tabela(entregues, options={
            'Data': ("Dia Pedido", format_data),
            'Limite': ("Hora Limite", format_hora)
        })
        cprint(" Não Entregues:", 'yellow', attrs=['bold'])
        mostra_tabela(naoentregues, options={
            'Data': ("Dia Pedido", format_data),
            'Limite': ("Hora Limite", format_hora)
        })

    def peso_estafeta_dia():
        dia = prompt("Dia (Dia/Mês/Ano)")
        mostra_tabela(list(prolog.query("pesoTotalByEstafetaNoDia(estafeta(Id,Nome),{dia}, Peso)")))

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
        "Todas as encomendas entre duas datas": todas_encomendas_entre,
        "Peso por estafeta no dia": peso_estafeta_dia,
        "Voltar": lambda: None
    })
