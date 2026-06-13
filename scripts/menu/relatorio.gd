extends Node2D

func _ready() -> void:
	gerar_relatorio()
	MusicManager.tocar_menu()

func gerar_relatorio() -> void:
	# ---------------------------------------------------------
	# 1. CÁLCULO DE ERROS TOTAIS
	# ---------------------------------------------------------
	var total_erros = PlayerName.erros_fase1 + PlayerName.erros_fase1_2 + PlayerName.erros_fase2

	# ---------------------------------------------------------
	# 2. CÁLCULO DO TEMPO MÉDIO
	# ---------------------------------------------------------
	var tempo_total = PlayerName.tempo_fase1 + PlayerName.tempo_fase1_2 + PlayerName.tempo_fase2
	var tempo_medio = tempo_total / 3.0

	# ---------------------------------------------------------
	# 3. PIOR (MAIOR) E MELHOR (MENOR) TEMPO
	# ---------------------------------------------------------
	var lista_tempos = [PlayerName.tempo_fase1, PlayerName.tempo_fase1_2, PlayerName.tempo_fase2]
	var pior_tempo_valor = lista_tempos.max()
	var melhor_tempo_valor = lista_tempos.min()

	# ---------------------------------------------------------
	# 4. ESTRUTURA E CÁLCULO DA NOTA FINAL (FÓRMULA CONCEITO)
	# ---------------------------------------------------------
	# Alimentamos o dicionário da fórmula diretamente com os dados do PlayerName
	var relatorio_fases = {
		"fase1_1": {"tempo": PlayerName.tempo_fase1, "erros": PlayerName.erros_fase1},
		"fase1_2": {"tempo": PlayerName.tempo_fase1_2, "erros": PlayerName.erros_fase1_2},
		"fase2":   {"tempo": PlayerName.tempo_fase2, "erros": PlayerName.erros_fase2}
	}
	
	var nota_conceito = calcular_nota_final(relatorio_fases)

	# ---------------------------------------------------------
	# 5. EXIBIR OS DADOS NOS LABELS
	# ---------------------------------------------------------
	$PorAcerto.text += " " + str(total_erros)
	$MedTempo.text += " " + formatar_tempo_relogio(tempo_medio)
	$MaiorTempo.text += " " + formatar_tempo_relogio(pior_tempo_valor)
	$MenorTempo.text += " " + formatar_tempo_relogio(melhor_tempo_valor)
	
	# Exibe o conceito final (A, B, C, D, E ou F) na tela
	# Nota: Certifique-se de que seu nó Label se chama exatamente "Nota" na cena
	if has_node("Nota"):
		$Nota.text += " " + nota_conceito


# ---------------------------------------------------------
# FUNÇÃO DE CÁLCULO DA NOTA CONCEITO (FÓRMULA MATEMÁTICA)
# ---------------------------------------------------------
func calcular_nota_final(relatorio_final: Dictionary) -> String:
	var total_erros: int = 0
	var tempo_extra_total: float = 0.0
	
	# 1. Varre o dicionário calculando o tempo extra individual de cada fase
	for nome_fase in relatorio_final:
		var dados = relatorio_final[nome_fase]
		# Acumula os erros totais (E)
		total_erros += dados["erros"]
		# Calcula o max(0, t - 300) de cada fase (Meta de 5 minutos = 300 segundos)
		var tempo_fase = dados["tempo"]
		var extra_fase = max(0.0, tempo_fase - 300.0)
		# Acumula no T_extra
		tempo_extra_total += extra_fase
		
	# Pontuação base máxima
	var pontuacao: float = 100.0
	
	# 2. Aplica as deduções da fórmula
	pontuacao -= total_erros * 3.5              # Penalidade por erro
	pontuacao -= tempo_extra_total / 5.0        # Penalidade por tempo extra (1pt a cada 5s)
	
	# Função max(0, ...) implícita através do clamp (trava a nota entre 0 e 100)
	pontuacao = clamp(pontuacao, 0.0, 100.0)
	
	# 3. Função por partes para mapear a pontuação na Nota Conceito (A até F)
	if pontuacao >= 90.0:
		return "A"
	elif pontuacao >= 75.0:
		return "B"
	elif pontuacao >= 60.0:
		return "C"
	elif pontuacao >= 45.0:
		return "D"
	elif pontuacao >= 25.0:
		return "E"
	else:
		return "F"


# ---------------------------------------------------------
# FUNÇÃO AUXILIAR: CONVERTE SEGUNDOS PARA RELÓGIO (MM:SS)
# ---------------------------------------------------------
func formatar_tempo_relogio(tempo_em_segundos: float) -> String:
	var minutos = int(tempo_em_segundos) / 60
	var segundos = int(tempo_em_segundos) % 60
	return "%02d:%02d" % [minutos, segundos]


# --- BOTÕES ---

func _on_botao_continuar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu_email.tscn")

func _on_botao_continuar_mouse_entered() -> void:
	if $botao != null:
		$botao.stop()
		$botao.play()
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.1, 1.1), 0.15)

func _on_botao_continuar_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.0, 1.0), 0.15)
