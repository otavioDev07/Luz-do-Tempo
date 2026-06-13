extends Node

var player_name = ""
var player_email = ""

var erros_fase1 = 0
var tempo_fase1: float = 0.0

var erros_fase1_2 = 0
var tempo_fase1_2: float = 0.0

var erros_fase2 = 0
var tempo_fase2: float = 0.0

var lista_historico_jogadores: Array = []


func registrar_jogador_atual_no_historico() -> void:
	var total_erros = erros_fase1 + erros_fase1_2 + erros_fase2
	
	# Cria a lista de tempos coletados
	var lista_tempos = [tempo_fase1, tempo_fase1_2, tempo_fase2]
	
	# 🌟 CORREÇÃO 2 (BUG DO 00:00): Filtra a lista para remover tempos zerados (fases puladas ou bugs)
	var tempos_validos = []
	for t in lista_tempos:
		if t > 0.01:
			tempos_validos.append(t)
			
	# Se por acaso tudo estiver zerado (teste rápido), evita quebrar o código
	if tempos_validos.size() == 0:
		tempos_validos = [0.0]
	
	# Cálculos matemáticos corrigidos e baseados apenas em fases realmente jogadas
	var tempo_total: float = 0.0
	for t in tempos_validos:
		tempo_total += t
		
	var tempo_medio = tempo_total / float(tempos_validos.size())
	var pior_tempo = tempos_validos.max()
	var melhor_tempo = tempos_validos.min()
	
	# Porcentagem de acertos (Base 23)
	var acertos_brutos = 23 - total_erros
	var porcentagem_acertos = (float(acertos_brutos) / 23.0) * 100.0
	porcentagem_acertos = clamp(porcentagem_acertos, 0.0, 100.0)
	
	# Cálculo da Nota Conceito
	var tempo_extra_total = max(0.0, tempo_fase1 - 300.0) + max(0.0, tempo_fase1_2 - 300.0) + max(0.0, tempo_fase2 - 300.0)
	var pontuacao: float = clamp(100.0 - (total_erros * 3.5) - (tempo_extra_total / 5.0), 0.0, 100.0)
	
	var nota_conceito = "F"
	if pontuacao >= 90.0: nota_conceito = "A"
	elif pontuacao >= 75.0: nota_conceito = "B"
	elif pontuacao >= 60.0: nota_conceito = "C"
	elif pontuacao >= 45.0: nota_conceito = "D"
	elif pontuacao >= 25.0: nota_conceito = "E"
	
	var dados_aluno = {
		"nome": player_name,
		"porcentagem": "%.1f%%" % porcentagem_acertos,
		"tempo_medio": tempo_medio,
		"maior_tempo": pior_tempo,
		"menor_tempo": melhor_tempo,
		"nota": nota_conceito,
		"feedback": obter_feedback_pedagogico(nota_conceito)
	}
	
	lista_historico_jogadores.append(dados_aluno)
	print("💾 Módulo de Contingência: Dados de '" + player_name + "' processados com sucesso.")


# --- NOVO: Lógica de negócio para os Feedbacks ---
func obter_feedback_pedagogico(nota: String) -> String:
	match nota:
		"A": return "Excelente aproveitamento. O aluno compreendeu perfeitamente a evolucao historica dos objetos e organizou as categorias com extrema agilidade."
		"B": return "Bom aproveitamento. O aluno demonstra otimo entendimento dos conceitos, cometendo apenas erros esporadicos durante as transicoes."
		"C": return "Aproveitamento satisfatorio. O aluno compreendeu a dinamica do tempo, embora tenha apresentado dificuldades pontuais em algumas categorias."
		"D": return "Aproveitamento regular. O aluno conseguiu concluir as tarefas, mas necessita de mais tempo ou tentativas para fixar a diferenca dos periodos."
		"E": return "Aproveitamento insuficiente. O aluno demonstrou alta Hesitacao e confusao na triagem dos objetos antigos e novos."
		_: return "Aproveitamento critico. O aluno apresentou extrema dificuldade na retencao do conteudo das fases, demandando reforco pedagogico."

func resetar_jogador_atual() -> void:
	player_name = ""
	erros_fase1 = 0
	tempo_fase1 = 0.0
	erros_fase1_2 = 0
	tempo_fase1_2 = 0.0
	erros_fase2 = 0
	tempo_fase2 = 0.0
