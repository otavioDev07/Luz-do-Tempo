extends TextureButton # Se você usou um Button normal, mude aqui para "extends Button"

# Cria um campo no Inspector com um ícone de pasta para você escolher a cena!
@export_file("*.tscn") var cena_destino: String

@onready var som_hover = $AudioStreamPlayer2D

func _ready() -> void:
	# O próprio código já conecta os sinais automaticamente, 
	# assim você não precisa ir na aba "Node" conectar toda vez!
	mouse_entered.connect(_on_mouse_entered)
	pressed.connect(_on_pressed)


func _on_mouse_entered() -> void:
	# Quando o mouse passa por cima, toca o som (se não estiver tocando já)
	if som_hover != null and not som_hover.playing:
		som_hover.play()


func _on_pressed() -> void:
	# Troca para a tela que você configurou no Inspector
	if cena_destino != "":
		get_tree().change_scene_to_file(cena_destino)
	else:
		print("Aviso: O caminho da cena não foi configurado neste botão!")
