from ui import *

def fase2_menu(prolog):
    def search_informada_caminho():
        mostrar_todas = prompt_multiplechoice("Mostrar todos os caminhos?", {'Sim': True, 'Não': False})
        tipo = prompt_multiplechoice("Tipo de pesquisa", {'A*': 'aestrela', 'Gulosa': 'gulosa'})
        funcao = prompt_multiplechoice("Calcular custo em função de", {'Tempo': 'tempo', 'Preço': 'custo'})
        transporte = prompt("ID do transporte")
        encomendas = prompt("IDs das encomendas (Formato [a, b, ...])")
        res = list(prolog.query(f"searchInformadaCaminho('{tipo}', '{funcao}', {encomendas}, {transporte}, Caminho, Custo)"))
        for i, r in enumerate(res):
            if i % 2 != 0:
                continue
            caminho = list(map(lambda x: {'Rua': x[0], 'Localidade': x[1]}, map(lambda x: list(map(str, x.args)), r['Caminho'])))
            mostra_tabela(caminho)
            print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Custo: ", attrs=['bold']) + str(r['Custo']))
            if not mostrar_todas:
                break

    def search_informada_caminho_volta():
        mostrar_todas = prompt_multiplechoice("Mostrar todos os caminhos?", {'Sim': True, 'Não': False})
        tipo = prompt_multiplechoice("Tipo de pesquisa", {'A*': 'aestrela', 'Gulosa': 'gulosa'})
        funcao = prompt_multiplechoice("Calcular custo em função de", {'Tempo': 'tempo', 'Preço': 'custo', 'Distância': 'distancia'})
        transporte = prompt("ID do transporte")
        encomendas = prompt("IDs das encomendas (Formato [a, b, ...])")
        res = list(prolog.query(f"searchInformadaCaminhoIdaVolta('{tipo}', '{funcao}', {encomendas}, {transporte}, Caminho, Custo)"))
        caminho = list(map(lambda x: {'Rua': x[0], 'Localidade': x[1]}, map(lambda x: list(map(str, x.args)), res['Caminho'])))
        mostra_tabela(caminho)
        print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Custo: ", attrs=['bold']) + str(res['Custo']))
        for i, r in enumerate(res):
            if i % 2 != 0:
                continue
            caminho = list(map(lambda x: {'Rua': x[0], 'Localidade': x[1]}, map(lambda x: list(map(str, x.args)), r['Caminho'])))
            mostra_tabela(caminho)
            print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Custo: ", attrs=['bold']) + str(r['Custo']))
            if not mostrar_todas:
                break


    def search_nao_informada_caminho():
        mostrar_todas = prompt_multiplechoice("Mostrar todos os caminhos?", {'Sim': True, 'Não': False})
        tipo = prompt_multiplechoice("Tipo de pesquisa", {'Depth-First Search': 'dfs', 'Breadth-First Search': 'bfs', 'Iterative Deepening Search': 'iterativa'})
        encomendas = prompt("IDs das encomendas (Formato [a, b, ...])")
        caminho = list(prolog.query(f"searchNaoInformadaCaminho('{tipo}', {encomendas}, R)"))
        for i, r in enumerate(caminho):
            if i % 2 != 0:
                continue
            mostra_tabela(list(map(lambda x: {'Rua': x[0], 'Localidade': x[1]}, map(lambda x: list(map(str, x.args)), r['R']))))
            if not mostrar_todas:
                break

    def search_nao_informada_caminho_volta():
        mostrar_todas = prompt_multiplechoice("Mostrar todos os caminhos?", {'Sim': True, 'Não': False})
        tipo = prompt_multiplechoice("Tipo de pesquisa", {'Depth-First Search': 'dfs', 'Breadth-First Search': 'bfs', 'Iterative Deepening Search': 'iterativa'})
        encomendas = prompt("IDs das encomendas (Formato [a, b, ...]")
        caminho = list(prolog.query(f"searchNaoInformadaCaminhoIdaVolta('{tipo}', {encomendas}, R)"))
        for i, r in enumerate(caminho):
            if i % 2 != 0:
                continue
            mostra_tabela(list(map(lambda x: {'Rua': x[0], 'Localidade': x[1]}, map(lambda x: list(map(str, x.args)), r['R']))))
            if not mostrar_todas:
                break

    def realizar_encomenda():
        id_servico = prompt("ID do serviço")
        encomendas = prompt("IDs das encomendas (Formato [a, b, ...]")
        id_estafeta = prompt("ID do estafeta")
        id_transporte = prompt("ID do transporte")
        dia = prompt("Data de entrega (Formato Dia/Mês/Ano/Hora/Minuto)")
        classificacao = prompt("Classificação")
        valor = prompt("Valor pago")
        tipo = prompt_multiplechoice("Tipo de pesquisa", {'A*': 'aestrela', 'Gulosa': 'gulosa', 'Depth-First Search': 'dfs', 'Breadth-First Search': 'bfs', 'Iterative Deepening Search': 'ids'})
        funcao = prompt_multiplechoice("Calcular custo em função de", {'Tempo': 'tempo', 'Preço': 'custo', 'Distância': 'distancia'})
        if len(list(prolog.query(f"realizarEncomendas({id_servico},{encomendas},{id_estafeta},{id_transporte},{dia},{valor},{tipo},{funcao},{classificacao})"))) > 0:
            print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Encomenda realizada", attrs=['bold']))
        else:
            print(colored(" ❯ ", 'red', attrs=['bold']) + colored("Erro ao realizar encomenda", attrs=['bold']))

    def peso_por_encomendas():
        encomendas = prompt("IDs das encomendas (Formato [a, b, ...]")
        resultado = list(prolog.query(f"calcularPesoByIdsEncomendas({encomendas},R)"))[0]['R']
        print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Peso total: ", attrs=['bold']) + str(resultado))

    def volume_por_encomendas():
        encomendas = prompt("IDs das encomendas (Formato [a, b, ...]")
        resultado = list(prolog.query(f"calcularVolumeByIdsEncomendas({encomendas},R)"))[0]['R']
        print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Volume total:", attrs=['bold']) + str(resultado))

    def caminhos_maior_peso():
        res = next(prolog.query(f"caminhosMaiorPeso(R)"))
        for a in res['R']:
            atoms = a.args
            peso = atoms[0]

            print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Peso total: ", attrs=['bold']) + str(peso))
            caminho = atoms[1]
            if (len(caminho) == 0):
                cprint(" (Caminho vazio)", 'cyan', attrs=['bold'])
            else:
                mostra_tabela(list(map(lambda x: {'Rua': x[0], 'Localidade': x[1]}, map(lambda x: list(map(str, x.args)), caminho))))

    def caminhos_maior_volume():
        res = next(prolog.query(f"caminhosMaiorVolume(R)"))
        for a in res['R']:
            atoms = a.args
            volume = atoms[0]

            print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Volume total: ", attrs=['bold']) + str(volume))
            caminho = atoms[1]
            if (len(caminho) == 0):
                cprint(" (Caminho vazio)", 'cyan', attrs=['bold'])
            else:
                mostra_tabela(list(map(lambda x: {'Rua': x[0], 'Localidade': x[1]}, map(lambda x: list(map(str, x.args)), caminho))))

    def peso_total_by_servico():
        servico = prompt("ID do serviço")
        r = next(prolog.query(f"servico({servico},_,E,_,_,_,_,_), pesoTotalByServico(servico(_,_,E,_,_,_,_,_), R)"))['R']
        print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Peso total: ", attrs=['bold']) + str(r))

    def volume_total_by_servico():
        servico = prompt("ID do serviço")
        r = next(prolog.query(f"servico({servico},_,E,_,_,_,_,_), volumeTotalByServico(servico(_,_,E,_,_,_,_,_), R)"))['R']
        print(colored(" ❯ ", 'yellow', attrs=['bold']) + colored("Volume total: ", attrs=['bold']) + str(r))

    def servicos_order_peso():
        mostra_tabela(list(prolog.query("servicosIdOrderByPeso(R), member(Servico/Peso, R)")), filter_out=['R'], options={'Servico': ('Serviço', lambda x: x)})
    def servicos_order_volume():
        mostra_tabela(list(prolog.query("servicosIdOrderByVolume(R), member(Servico/Volume, R)")), filter_out=['R'], options={'Servico': ('Serviço', lambda x: x)})

    def custos_servico():
        servico = prompt("ID do serviço")
        mostra_tabela(list(prolog.query(f"custosServico({servico}, Distancia, Custo, Tempo, ValorGanho)")), options={
            'Distancia': ('Distância', lambda x: x),
            'ValorGanho': ('Valor Ganho', lambda x: x)
        })

    escolhe_opcoes({
        'Pesquisa informada de caminho': search_informada_caminho,
        'Pesquisa informada de caminho de ida e volta': search_informada_caminho_volta,

        'Pesquisa não informada de caminho': search_nao_informada_caminho,
        'Pesquisa não informada de caminho de ida e volta': search_nao_informada_caminho_volta,

        'Realizar encomendas': realizar_encomenda,

        'Peso total por encomendas': peso_por_encomendas,
        'Volume total por encomendas': volume_por_encomendas,

        'Caminhos com maior peso total': caminhos_maior_peso,
        'Caminhos com maior volume total': caminhos_maior_volume,

        'Peso total por serviço': peso_total_by_servico,
        'Volume total por serviço': volume_total_by_servico,

        'Serviços ordenados por peso': servicos_order_peso,
        'Serviços ordenados por volume': servicos_order_volume,

        'Custos de um serviço': custos_servico,

        'Voltar': lambda: None
    })
