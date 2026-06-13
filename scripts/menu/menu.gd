extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.tocar_menu()
	
	# --- ZERANDO TODOS OS DADOS DO JOGADOR ---
	PlayerName.player_name = ""
	
	PlayerName.erros_fase1 = 0
	PlayerName.tempo_fase1 = 0.0
	
	PlayerName.erros_fase1_2 = 0
	PlayerName.tempo_fase1_2 = 0.0
	
	PlayerName.erros_fase2 = 0
	PlayerName.tempo_fase2 = 0.0


func _on_botao_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/menu_nome.tscn")


func _on_botao_sobre_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/menu_sobre.tscn")


func _on_botao_relatorio_pressed() -> void:
	if PlayerName.lista_historico_jogadores.size() == 0:
		print("⚠️ Planilha não gerada: Nenhum jogador terminou a partida nesta sessão ainda.")
		return
		
	# 🌟 CORREÇÃO 1: Salva direto na pasta "Documentos" do Windows do usuário
	var pasta_documentos = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	var caminho_arquivo = pasta_documentos + "/relatorio_contingencia_luz_do_tempo.csv"
	
	var arquivo = FileAccess.open(caminho_arquivo, FileAccess.WRITE)
	
	if arquivo:
		# 🌟 CORREÇÃO 3: Cabeçalho com visual "formatadinho" e profissional
		arquivo.store_line("=================================================================================================================================")
		arquivo.store_line("                                     RELATÓRIO DE CONTINGÊNCIA - JOGO LUZ DO TEMPO                                              ")
		arquivo.store_line("=================================================================================================================================")
		arquivo.store_line("Nome do Aluno;Porcentagem de Acertos;Tempo Médio por Fase;Maior Tempo em Fase;Menor Tempo em Fase;Nota Conceito;Feedback Pedagógico")
		arquivo.store_line("---------------------------------------------------------------------------------------------------------------------------------")
		
		for dados in PlayerName.lista_historico_jogadores:
			var linha = "%s;%s;%s;%s;%s;%s;%s" % [
				dados["nome"],
				dados["porcentagem"],
				formatar_tempo_csv(dados["tempo_medio"]),
				formatar_tempo_csv(dados["maior_tempo"]),
				formatar_tempo_csv(dados["menor_tempo"]),
				dados["nota"],
				dados["feedback"]
			]
			arquivo.store_line(linha)
			
		arquivo.store_line("=================================================================================================================================")
		arquivo.close()
		print("✅ PLANILHA EXPORTADA COM SUCESSO EM: ", caminho_arquivo)
	else:
		print("❌ Erro ao tentar criar o arquivo na pasta Documentos.")


func formatar_tempo_csv(tempo_em_segundos: float) -> String:
	var minutos = int(tempo_em_segundos) / 60
	var segundos = int(tempo_em_segundos) % 60
	return "%02d:%02d" % [minutos, segundos]


func _on_botao_sair_pressed() -> void:
	get_tree().quit()


func _on_botao_jogar_mouse_entered() -> void:
	$botao.stop()
	$botao.play()
	
	var tween = create_tween()
	tween.tween_property($botao_jogar, "scale", Vector2(1.1, 1.1), 0.15)


func _on_botao_jogar_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_jogar, "scale", Vector2(1.0, 1.0), 0.15)


func _on_botao_sobre_mouse_entered() -> void:
	$botao.stop()
	$botao.play()
	
	var tween = create_tween()
	tween.tween_property($botao_sobre, "scale", Vector2(1.1, 1.1), 0.15)


func _on_botao_sobre_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_sobre, "scale", Vector2(1.0, 1.0), 0.15)


func _on_botao_relatorio_mouse_entered() -> void:
	$botao.stop()
	$botao.play()
	var tween = create_tween()
	tween.tween_property($botao_relatorio, "scale", Vector2(1.1, 1.1), 0.15)


func _on_botao_relatorio_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_relatorio, "scale", Vector2(1.0, 1.0), 0.15)


func _on_botao_sair_mouse_entered() -> void:
	$botao.stop()
	$botao.play()
	var tween = create_tween()
	tween.tween_property($botao_sair, "scale", Vector2(1.1, 1.1), 0.15)


func _on_botao_sair_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_sair, "scale", Vector2(1.0, 1.0), 0.15)
