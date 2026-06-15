extends Control

@onready var video = $AreaVideo/tutorial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$woosh.play()


func _on_botao_continuar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fase1_1/fase_1_1.tscn")


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
	get_tree().change_scene_to_file("res://scenes/menu/menu_nome.tscn")


func _on_botao_voltar_mouse_entered() -> void:
	$botao.stop()
	$botao.play()
	$voltar.stop()
	$voltar.play()
	var tween = create_tween()
	tween.tween_property($botao_voltar, "scale", Vector2(1.1, 1.1), 0.15)


func _on_botao_voltar_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_voltar, "scale", Vector2(1.0, 1.0), 0.15)


func _on_play_pressed() -> void:
	video.paused = false
	video.play()


func _on_playback_pressed() -> void:
	video.stream_position = max(
		0.0,
		video.stream_position - 5.0
	)


func _on_playforward_pressed() -> void:
	video.stream_position += 5.0


func _on_pause_pressed() -> void:
	video.paused = !video.paused
