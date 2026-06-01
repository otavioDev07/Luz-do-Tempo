extends Label

var letra_correta: String = ""
var preenchida: bool = false

func _ready() -> void:
	# Força a label a detetar o arrasto do rato
	mouse_filter = Control.MOUSE_FILTER_STOP

func configurar_lacuna(nova_letra_correta: String) -> void:
	letra_correta = nova_letra_correta
	text = "_"
	preenchida = false
	modulate = Color.WHITE

func _can_drop_data(_at_position, data) -> bool:
	var fase_principal = get_tree().current_scene
	
	# Só aceita se for texto, se a fase liberou o jogo e se a lacuna não tá cheia
	return typeof(data) == TYPE_STRING and fase_principal.pode_interagir and not preenchida

func _drop_data(_at_position, data) -> void:
	# Envia diretamente para a fase validar
	get_tree().current_scene.validar_resposta(data, self)
