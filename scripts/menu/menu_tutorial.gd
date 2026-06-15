extends Control

@onready var video = $AreaVideo/tutorial
@onready var area_video = $AreaVideo
@onready var placeholder = $placeholder
@onready var play1 = $placeholder/play1
@onready var pausar = $placeholder/pausar
@onready var forward = $placeholder/forward
@onready var rewind = $placeholder/rewind

var escala_video_original
var escala_placeholder_original

func _ready() -> void:
	$mensagem.play()
	$woosh.play()
	play1.visible = false
	pausar.visible = false
	rewind.visible = false
	forward.visible = false

	escala_video_original = area_video.scale
	escala_placeholder_original = placeholder.scale


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


func _on_play_2_pressed() -> void:
	var tween = create_tween()

	$play2.visible = false
	play1.visible = false
	pausar.visible = true
	rewind.visible = true
	forward.visible = true
	
	var tween_musica = create_tween()
	tween_musica.tween_property(
	MusicManager,
	"volume_db",
	-50,
	1.0
)
	tween.parallel().tween_property(
		area_video,
		"scale",
		escala_video_original * 1.3,
		0.3
	)

	tween.parallel().tween_property(
		placeholder,
		"scale",
		escala_placeholder_original * 1.3,
		0.3
	)

	video.paused = false
	video.play()


func _on_play_2_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($play2, "scale", Vector2(1.1, 1.1), 0.15)


func _on_play_2_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($play2, "scale", Vector2(1.0, 1.0), 0.15)


func _on_play_1_pressed() -> void:
	video.paused = false
	video.play()
	play1.visible = false
	pausar.visible = true


func _on_pausar_pressed() -> void:
	video.paused = !video.paused
	play1.visible = true
	pausar.visible = false


func _on_forward_pressed() -> void:
	video.stream_position += 5.0


func _on_rewind_pressed() -> void:
	video.stream_position = max(
		0.0,
		video.stream_position - 5.0
	)


func _on_tutorial_finished() -> void:
	var tween_musica = create_tween()

	tween_musica.tween_property(
		MusicManager,
		"volume_db",
		-25,
		1.0
	)
