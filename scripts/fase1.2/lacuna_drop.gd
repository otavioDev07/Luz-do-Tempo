extends Label

var letra_correta: String = ""
var preenchida: bool = false

func _ready()->void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	
func configurar_lacuna(nova_letra_correta: String) -> void:
	letra_correta = nova_letra_correta
	text = "_"
	preenchida = false
	modulate = Color.WHITE
