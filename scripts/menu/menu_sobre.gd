extends Control
@onready  var tocador_audio = $sobre


func _on_botao_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_botao_voltar_mouse_entered() -> void:
	$voltar.play()


func _on_rich_text_label_mouse_entered() -> void:
	if tocador_audio != null:
		tocador_audio.play()
