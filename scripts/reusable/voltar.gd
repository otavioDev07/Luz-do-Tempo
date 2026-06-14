extends TextureButton # Se você usou um Button normal, mude aqui para "extends Button"

# Cria um campo no Inspector com um ícone de pasta para você escolher a cena!
@export_file("*.tscn") var cena_destino: String

@onready var som_hover = $AudioStreamPlayer2D

func _ready() -> void:
	# O próprio código já conecta os sinais automaticamente
	mouse_entered.connect(_on_mouse_entered)
	pressed.connect(_on_pressed)
	# NOVO: Conecta a saída do mouse para voltar ao tamanho normal
	mouse_exited.connect(_on_mouse_exited)
	
	# DICA: Isso faz o botão crescer a partir do centro, e não do canto superior esquerdo
	pivot_offset = size / 2


func _on_mouse_entered() -> void:
	$som.stop()
	$som.play()
	
	var tween = create_tween()
	# CORRIGIDO: Agora usa 'self' para aplicar a animação no próprio botão
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.15)
	
	# Quando o mouse passa por cima, toca o som (se não estiver tocando já)
	if som_hover != null and not som_hover.playing:
		som_hover.play()


# NOVO: Função para o botão "encolher" de volta ao normal
func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15)


func _on_pressed() -> void:
	# Troca para a tela que você configurou no Inspector
	if cena_destino != "":
		get_tree().change_scene_to_file(cena_destino)
	else:
		print("Aviso: O caminho da cena não foi configurado neste botão!")
