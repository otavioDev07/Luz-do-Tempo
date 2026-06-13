extends Node2D

func _ready() -> void:
	gerar_relatorio()

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
	# Colocamos os três tempos numa lista (Array)
	var lista_tempos = [PlayerName.tempo_fase1, PlayerName.tempo_fase1_2, PlayerName.tempo_fase2]
	
	# O Godot já tem funções prontas para achar o maior e o menor número de uma lista!
	var pior_tempo_valor = lista_tempos.max()
	var melhor_tempo_valor = lista_tempos.min()

	# ---------------------------------------------------------
	# 4. EXIBIR OS DADOS NOS LABELS (APENAS CONCATENANDO)
	# ---------------------------------------------------------
	
	$PorAcerto.text += " " + str(total_erros)
	
	$MedTempo.text += " " + str(snapped(tempo_medio, 0.1)) + "s"
	
	$MaiorTempo.text += " " + str(snapped(pior_tempo_valor, 0.1)) + "s"
	
	$MenorTempo.text += " " + str(snapped(melhor_tempo_valor, 0.1)) + "s"


# --- BOTÕES ---

func _on_botao_continuar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")

func _on_botao_continuar_mouse_entered() -> void:
	if $botao != null:
		$botao.stop()
		$botao.play()
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.1, 1.1), 0.15)

func _on_botao_continuar_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.0, 1.0), 0.15)
