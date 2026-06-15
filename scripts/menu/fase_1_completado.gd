extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$tadaa.play()
	$celebration.play()
	$instrucao.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_botao_continuar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fase2/fase_2.tscn")


func _on_botao_continuar_mouse_entered() -> void:
	$botao.stop()
	$botao.play()
	
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.1, 1.1), 0.15)


func _on_botao_continuar_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.0, 1.0), 0.15)
