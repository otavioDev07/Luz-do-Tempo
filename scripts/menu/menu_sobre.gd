extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$woosh.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_botao_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_botao_voltar_mouse_entered() -> void:
	$voltar.play()
