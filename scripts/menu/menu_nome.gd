extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$woosh.play()
	$mensagem.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_botao_continuar_pressed() -> void:
	# 1. Pega o texto e remove espaços inúteis do começo e do fim
	var nome_digitado = $caixa_de_texto/imput_nome.text.strip_edges()
	
	# 2. SE o nome estiver completamente vazio, bloqueia a transição
	if nome_digitado == "":
		# Feedback auditivo: Toca o som de botão para avisar que falhou 
		if $botao != null:
			$botao.stop()
			$botao.play()
			
		# O 'return' para o código aqui mesmo, impedindo de ler a linha do change_scene
		return 
		
	# 3. Se passou da validação, salva o nome limpo e avança para o tutorial
	PlayerName.player_name = nome_digitado
	get_tree().change_scene_to_file("res://scenes/menu/menu_tutorial.tscn")


func _on_botao_continuar_mouse_entered() -> void:
	$botao.stop()
	$botao.play()
	$continuar.play()
	
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.1, 1.1), 0.15)


func _on_botao_continuar_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.0, 1.0), 0.15)


func _on_botao_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_botao_voltar_mouse_entered() -> void:
	$botao.stop()
	$botao.play()
	$voltar.stop()
	$voltar.play()
	var tween = create_tween()
	tween.tween_property($botao_voltar, "scale", Vector2(1.1, 1.1), 0.15)


func _on_imput_nome_text_changed(new_text: String) -> void:
	$digitando.stop()
	$digitando.play()


func _on_botao_voltar_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_voltar, "scale", Vector2(1.0, 1.0), 0.15)


func _on_titulo_mouse_entered() -> void:
	$nome.play()
