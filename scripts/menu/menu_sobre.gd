extends Control


func _on_botao_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_botao_voltar_mouse_entered() -> void:
	$voltar.play()
