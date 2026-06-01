extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_botao_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/menu_nome.tscn")


func _on_botao_sobre_pressed() -> void:
	pass


func _on_botao_relatorio_pressed() -> void:
	pass


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
